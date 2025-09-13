import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/attendance/models/attendance_dto.dart';
import 'package:management_software/features/data/attendance/model/attendance_model.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/supabase/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final attendanceServiceProvider =
    StateNotifierProvider<AttendanceService, AttendanceDTO>((ref) {
      final networkService = ref.watch(networkServiceProvider);
      return AttendanceService(networkService, ref);
    });

class AttendanceService extends StateNotifier<AttendanceDTO> {
  final NetworkService _networkService;
  final Ref ref;

  AttendanceService(this._networkService, this.ref) : super(AttendanceDTO());

  /// ✅ Check-In
  Future<void> checkIn({required BuildContext context}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(SharedPrefsHelper.userId);

      if (userId == null || userId.isEmpty) {
        ref
            .read(snackbarServiceProvider)
            .showError(context, "User not found. Please login again.");
        return;
      }
      final uuid = Uuid().v4();
      final data = {
        "id": uuid,
        "employee_id": userId,
        "checkinat": DateTimeHelper.formatTime(DateTime.now()),
        "date": DateTimeHelper.formatDate(DateTime.now()),
        "attendance_status": "Present",
      };
      final response = await _networkService.push(
        table: SupabaseTables.attendance,
        data: data,
      );
      log(response.toString());
      if (response != null) {
        getAllEmployeeAttendance(context: context);
        final userAttendance = AttendanceModel.fromJson(response);
        state = state.copyWith(userAttendance: userAttendance);
        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, "Checked in successfully!");
      } else {
        ref
            .read(snackbarServiceProvider)
            .showError(context, "Failed to check in.");
      }
    } catch (e) {
      log("Check-in error: $e");
      ref.read(snackbarServiceProvider).showError(context, "Error: $e");
    }
  }

  /// ✅ Check-Out
  Future<void> checkOut({required BuildContext context}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(SharedPrefsHelper.userId);

      if (userId == null || userId.isEmpty) {
        ref
            .read(snackbarServiceProvider)
            .showError(context, "User not found. Please login again.");
        return;
      }
      final dateToday = DateTimeHelper.formatDate(DateTime.now());
      final existing = await _networkService.pull(
        table: SupabaseTables.attendance,
        filters: {'employee_id': userId, 'date': dateToday},
      );
      if (existing.isEmpty) {
        ref
            .read(snackbarServiceProvider)
            .showError(context, "No check-in record found for today!");
        return;
      }
      log("Record ID: ${existing}");
      final recordId = existing[0]['id'];
      log(recordId.toString());
      final response = await _networkService.update(
        table: SupabaseTables.attendance,
        id: recordId,
        data: {
          "checkoutat": DateTimeHelper.formatTime(DateTime.now()),
          "attendance_status": "Checked out",
        },
      );
      log(response.toString());
      if (response != null) {
        getAllEmployeeAttendance(context: context);

        final userAttendance = AttendanceModel.fromJson(response);
        state = state.copyWith(userAttendance: userAttendance);
        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, "Checked out successfully!");
      } else {
        ref
            .read(snackbarServiceProvider)
            .showError(context, "Failed to check out.");
      }
    } catch (e) {
      log("Check-out error: $e");
      ref.read(snackbarServiceProvider).showError(context, "Error: $e");
    }
  }

  Future<void> getTodayStatus({required BuildContext context}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(SharedPrefsHelper.userId);
      final dateToday = DateTimeHelper.formatDate(DateTime.now());
      final existing = await _networkService.recordExists(
        table: SupabaseTables.attendance,
        filters: {'employee_id': userId, 'date': dateToday},
      );
      if (existing == false) {
        state = state.copyWith(
          userAttendance: AttendanceModel(
            employeeId: userId,
            date: dateToday,
            attendanceStatus: "Not checked in",
          ),
        );
      }
      final response = await _networkService.pull(
        table: SupabaseTables.attendance,
        filters: {'employee_id': userId, 'date': dateToday},
      );
      final userAttendance = AttendanceModel.fromJson(response[0]);
      state = state.copyWith(userAttendance: userAttendance);
    } catch (e) {
      log("Get today status error: $e");
    }
  }

  Future<void> getAllEmployeeAttendance({required BuildContext context}) async {
    try {
      final response = await _networkService.supabase
          .from(SupabaseTables.attendance)
          .select('*, profiles(diplay_name, designation, email)')
          .eq('date', DateTimeHelper.formatDate(DateTime.now()))
          .order('created_at', ascending: false);
      log(response.toString());
      final allEmployeesAttendance =
          response
              .map<AttendanceModel>((e) => AttendanceModel.fromJson(e))
              .toList();
      state = state.copyWith(allEmployeesAttendance: allEmployeesAttendance);
    } catch (e) {
      log("Get all employee attendance error: $e");
    }
  }

  /// ✅ Full Attendance History
  Future<void> getAttendanceHistory({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      final response = await _networkService.supabase
          .from(SupabaseTables.attendance)
          .select('*, profiles(diplay_name, designation, email)')
          .eq('employee_id', userId)
          .order('date', ascending: false);
      final attendanceHistory =
          response.map((e) => AttendanceModel.fromJson(e)).toList();
      state = state.copyWith(employeeHistory: attendanceHistory);
    } catch (e) {
      log("Get history error: $e");
    }
  }
}
