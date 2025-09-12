import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/supabase/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

final attendanceServiceProvider =
    StateNotifierProvider<AttendanceService, bool>((ref) {
      final networkService = ref.watch(networkServiceProvider);
      return AttendanceService(networkService, ref);
    });

class AttendanceService extends StateNotifier<bool> {
  final NetworkService _networkService;
  final Ref ref;

  AttendanceService(this._networkService, this.ref) : super(false);

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

      final dateToday = DateTime.now().toString().split(' ')[0];

      final existing = await _networkService.pull(
        table: SupabaseTables.attendance,
        filters: {'employee_id': userId, 'date': dateToday},
      );

      if (existing.isNotEmpty) {
        ref
            .read(snackbarServiceProvider)
            .showError(context, "Already checked in today!");
        return;
      }

      final  data = {
        "employee_id": userId,
        "checkinat": DateTime.now().toIso8601String(),
        "date": dateToday,
        "attendance_status": "Present",
      };

      final response = await _networkService.push(
        table: SupabaseTables.attendance,
        data: data,
      );

      if (response != null) {
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

      final dateToday = DateTime.now().toString().split(' ')[0];

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

      final recordId = existing[0]['id'];

      final response = await _networkService.update(
        table: SupabaseTables.attendance,
        id: recordId,
        data: {
          "checkoutat": DateTime.now().toIso8601String(),
          "attendance_status": "Completed",
        },
      );

      if (response != null) {
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

  /// ✅ Get Today’s Status
  Future<Map<String, dynamic>?> getTodayStatus({
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(SharedPrefsHelper.userId);

      if (userId == null || userId.isEmpty) return null;

      final dateToday = DateTime.now().toString().split(' ')[0];

      final response = await _networkService.pull(
        table: SupabaseTables.attendance,
        filters: {'employee_id': userId, 'date': dateToday},
      );

      return response.isNotEmpty ? response[0] : null;
    } catch (e) {
      log("Get today status error: $e");
      return null;
    }
  }

  /// ✅ Full Attendance History
  Future<List<Map<String, dynamic>>> getAttendanceHistory({
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(SharedPrefsHelper.userId);

      if (userId == null || userId.isEmpty) return [];

      final response = await _networkService.pull(
        table: SupabaseTables.attendance,
        filters: {'employee_id': userId},
        orderBy: "date",
        ascending: false,
      );

      return response;
    } catch (e) {
      log("Get history error: $e");
      return [];
    }
  }
}
