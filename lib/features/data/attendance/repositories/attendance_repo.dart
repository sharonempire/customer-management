import 'dart:developer';
import 'package:management_software/features/data/attendance/model/attendance_model.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/supabase/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceRepository {
  final NetworkService _networkService;

  AttendanceRepository(this._networkService);

  /// ✅ Get user ID from SharedPreferences
  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPrefsHelper.userId);
  }

  /// ✅ Check if today's attendance exists
  Future<AttendanceModel?> getTodayAttendance() async {
    try {
      final userId = await _getUserId();
      if (userId == null || userId.isEmpty) return null;

      final dateToday = DateTime.now().toString().split(' ')[0];

      final response = await _networkService.pull(
        table: SupabaseTables.attendance,
        filters: {'employee_id': userId, 'date': dateToday},
      );

      return response.isNotEmpty ? AttendanceModel.fromJson(response[0]) : null;
    } catch (e) {
      log("Error getting today's attendance: $e");
      return null;
    }
  }

  /// ✅ Insert Check-In
  Future<void> insertCheckIn() async {
    try {
      final userId = await _getUserId();

      final dateToday = DateTime.now().toString().split(' ')[0];

      final attendance = AttendanceModel(
        id: "", // Supabase will generate UUID
        createdAt: DateTime.now(),
        checkInAt: DateTime.now().toIso8601String(),
        attendanceStatus: "Present",
        date: dateToday,
        employeeId: userId,
      );

      final response = await _networkService.push(
        table: SupabaseTables.attendance,
        data: attendance.toJson(),
      );

    } catch (e) {
      log("Insert check-in error: $e");

      rethrow;
    }
  }

  /// ✅ Update Check-Out
  Future<bool> updateCheckOut(String recordId) async {
    try {
      final updated = {
        "checkoutat": DateTime.now().toIso8601String(),
        "attendance_status": "Completed",
      };

      final response = await _networkService.update(
        table: SupabaseTables.attendance,
        id: recordId,
        data: updated,
      );

      return response != null;
    } catch (e) {
      log("Update check-out error: $e");
      return false;
    }
  }

  /// ✅ Get Full Attendance History
  Future<List<AttendanceModel>> getAttendanceHistory() async {
    try {
      final userId = await _getUserId();
      if (userId == null || userId.isEmpty) return [];

      final response = await _networkService.pull(
        table: SupabaseTables.attendance,
        filters: {'employee_id': userId},
        orderBy: "date",
        ascending: false,
      );

      return response
          .map<AttendanceModel>((e) => AttendanceModel.fromJson(e))
          .toList();
    } catch (e) {
      log("Get history error: $e");
      return [];
    }
  }
}
