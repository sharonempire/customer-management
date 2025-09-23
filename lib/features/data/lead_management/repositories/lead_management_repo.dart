import 'dart:developer';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/supabase/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadManagementRepo {
  final NetworkService _networkService;

  static const String _leadWithAssignedProfileSelect =
      '*, assigned_profile:${SupabaseTables.profiles}!${SupabaseTables.leadList}_assigned_to_fkey(*)';

  LeadManagementRepo(this._networkService);

  Future<bool> studentExists(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString(SharedPrefsHelper.userId);
    try {
      final exists = await _networkService.recordExists(
        table: SupabaseTables.leadList,
        filters: {"phone": phone},
      );
      if (exists) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  /// ✅ Fetch Leads in Custom Date Range
  Future<List<LeadsListModel>> fetchLeadsInRange({
    required String startDate,
    required String endDate,
  }) async {
    try {
      final start =
          DateTime.parse(
            DateTimeHelper.toIsoDate(startDate, isStart: true),
          ).toUtc();
      final end =
          DateTime.parse(
            DateTimeHelper.toIsoDate(endDate, isStart: false),
          ).toUtc();

      log("Converted startDate: $start, endDate: $end");

      final response = await _networkService.pull(
        table: SupabaseTables.leadList,
        filters: {
          'created_at': {
            'gte': start.toIso8601String(),
            'lte': end.toIso8601String(),
          },
        },
        orderBy: "created_at",
        ascending: false,
        columns: _leadWithAssignedProfileSelect,
      );

      log("Leads fetched: ${response.length}");

      return response
          .map<LeadsListModel>((e) => LeadsListModel.fromJson(e))
          .toList();
    } catch (e) {
      log("Fetch Leads in Range Error: $e");
      return [];
    }
  }

  /// ✅ Update Existing Lead
  Future<LeadsListModel?> updateLead(
    String leadId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final response = await _networkService.update(
        table: SupabaseTables.leadList,
        id: leadId,
        data: updatedData,
      );

      if (response != null) {
        return LeadsListModel.fromJson(response);
      }
      return null;
    } catch (e) {
      log("Update Lead Error: $e");
      rethrow;
    }
  }

  /// ✅ Add New Lead
  Future<LeadsListModel> addLead(LeadsListModel lead) async {
    try {
      final response = await _networkService.push(
        table: SupabaseTables.leadList,
        data: lead.toJson(),
      );
      final createdLead = LeadsListModel.fromJson(response);
      return createdLead;
    } catch (e) {
      log("Add Lead Error: $e");
      rethrow;
    }
  }

  /// ✅ Fetch All Leads
  Future<List<LeadsListModel>> fetchAllLeads() async {
    try {
      final response = await _networkService.pull(
        table: SupabaseTables.leadList,
        orderBy: "created_at",
        ascending: false,
        columns: _leadWithAssignedProfileSelect,
      );
      log(response.toString());
      return response
          .map<LeadsListModel>((e) => LeadsListModel.fromJson(e))
          .toList();
    } catch (e) {
      log("Fetch Leads Error: $e");
      return [];
    }
  }

  Future<Map<int, List<LeadCallLog>>> fetchLeadCallLogs() async {
    try {
      final response = await _networkService.pull(
        table: SupabaseTables.leadInfo,
        columns: 'id, call_info',
      );

      final result = <int, List<LeadCallLog>>{};

      for (final record in response) {
        try {
          final info = LeadInfoModel.fromJson(record);
          final id = info.id;
          final calls = info.callInfo;
          if (id != null && calls != null && calls.isNotEmpty) {
            result[id] = List<LeadCallLog>.unmodifiable(calls);
          }
        } catch (e) {
          log('Call log parse error: $e');
        }
      }

      return result;
    } catch (e) {
      log('Fetch Call Logs Error: $e');
      return {};
    }
  }

  Future<List<UserProfileModel>> fetchCounsellors() async {
    try {
      final profilesResponse = List<Map<String, dynamic>>.from(
        await _networkService.pull(
          table: SupabaseTables.profiles,
          orderBy: 'diplay_name',
        ),
      );

      final profiles =
          profilesResponse
              .map<UserProfileModel>(
                (profile) => UserProfileModel.fromMap(profile),
              )
              .toList();

      final attendanceByEmployee = <String, String>{};

      try {
        final today = DateTimeHelper.formatDate(DateTime.now());
        final attendanceResponse = List<Map<String, dynamic>>.from(
          await _networkService.pull(
            table: SupabaseTables.attendance,
            filters: {'date': today},
            orderBy: 'created_at',
            ascending: false,
          ),
        );

        for (final record in attendanceResponse) {
          final employeeId = (record['employee_id'] as String?)?.trim();
          if (employeeId == null || employeeId.isEmpty) continue;

          attendanceByEmployee.putIfAbsent(
            employeeId,
            () => (record['attendance_status'] as String?)?.trim() ?? '',
          );
        }
      } catch (attendanceError, stackTrace) {
        log('Attendance lookup failed: $attendanceError\n$stackTrace');
      }

      final result =
          profiles
              .map<UserProfileModel>(
                (profile) => profile.copyWith(
                  attendanceStatus:
                      attendanceByEmployee[profile.id?.trim() ?? ''],
                ),
              )
              .toList();

      log(result.map((e) => e.toJson()).toString());
      return List<UserProfileModel>.from(result);
    } catch (e) {
      log('Fetch Counsellors Error: $e');
      return [];
    }
  }

  Future<List<LeadsListModel>> fetchLeadsByDate(String date) async {
    try {
      // Convert date to start and end of the day in UTC
      final start =
          DateTime.parse(DateTimeHelper.toIsoDate(date, isStart: true)).toUtc();

      final end =
          DateTime.parse(
            DateTimeHelper.toIsoDate(date, isStart: false),
          ).toUtc();

      log("Fetching leads for date: $date, start: $start, end: $end");

      final response = await _networkService.pull(
        table: SupabaseTables.leadList,
        filters: {
          'created_at': {
            'gte': start.toIso8601String(),
            'lte': end.toIso8601String(),
          },
        },
        orderBy: "created_at",
        ascending: false,
        columns: _leadWithAssignedProfileSelect,
      );

      log("Leads fetched for $date: ${response.length}");

      return response
          .map<LeadsListModel>((e) => LeadsListModel.fromJson(e))
          .toList();
    } catch (e) {
      log("Fetch Leads by Date Error: $e");
      return [];
    }
  }

  /// ✅ Fetch Today's Leads
  Future<List<LeadsListModel>> fetchTodaysLeads() async {
    final today = DateTime.now().toString().split(' ')[0];
    return fetchLeadsByDate(today);
  }

  /// ✅ Fetch Last Week Leads
  Future<List<LeadsListModel>> fetchLastWeekLeads() async {
    try {
      final now = DateTime.now();
      final lastWeek =
          now.subtract(const Duration(days: 7)).toString().split(' ')[0];

      final response = await _networkService.pull(
        table: SupabaseTables.leadList,
        filters: {
          'created_at': {'gte': lastWeek, 'lte': now.toString().split(' ')[0]},
        },
        orderBy: "created_at",
        ascending: false,
        columns: _leadWithAssignedProfileSelect,
      );

      return response
          .map<LeadsListModel>((e) => LeadsListModel.fromJson(e))
          .toList();
    } catch (e) {
      log("Fetch Last Week Leads Error: $e");
      return [];
    }
  }

  /// ✅ Fetch Last Month Leads
  Future<List<LeadsListModel>> fetchLastMonthLeads() async {
    try {
      final now = DateTime.now();
      final lastMonth =
          DateTime(now.year, now.month - 1, now.day).toString().split(' ')[0];

      final response = await _networkService.pull(
        table: SupabaseTables.leadList,
        filters: {
          'created_at': {'gte': lastMonth, 'lte': now.toString().split(' ')[0]},
        },
        orderBy: "created_at",
        ascending: false,
        columns: _leadWithAssignedProfileSelect,
      );

      return response
          .map<LeadsListModel>((e) => LeadsListModel.fromJson(e))
          .toList();
    } catch (e) {
      log("Fetch Last Month Leads Error: $e");
      return [];
    }
  }

  /// ✅ Fetch Lead Info by Lead ID
  Future<LeadInfoModel?> getLeadInfo(String leadId) async {
    try {
      final response = await _networkService.pull(
        table: SupabaseTables.leadInfo,
        filters: {'id': leadId},
      );

      if (response.isNotEmpty) {
        return LeadInfoModel.fromJson(response[0]);
      }
      return null;
    } catch (e) {
      log("Get Lead Info Error: $e");
      return null;
    }
  }

  /// ✅ Update Lead Info
  Future<LeadInfoModel?> updateLeadInfo(
    String leadId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final response = await _networkService.update(
        table: SupabaseTables.leadInfo,
        id: leadId, // foreign key to leadslist.id
        data: updatedData,
      );
      if (response != null) {
        return LeadInfoModel.fromJson(response);
      }
      return null;
    } catch (e) {
      log("Update Lead Info Error: $e");
      return null;
    }
  }

  /// ✅ Create Lead Info
  Future<LeadInfoModel?> createLeadInfo(LeadInfoModel leadInfo) async {
    try {
      final response = await _networkService.push(
        table: SupabaseTables.leadInfo,
        data: leadInfo.toJson(),
      );

      if (response != null) {
        return LeadInfoModel.fromJson(response);
      }
      return null;
    } catch (e) {
      log("Create Lead Info Error: $e");
      return null;
    }
  }

  /// ✅ Delete Lead and its LeadInfo
  Future<bool> deleteLead(String leadId) async {
    try {
      // 1️⃣ Delete LeadInfo first (foreign key)
      await _networkService.delete(
        table: SupabaseTables.leadInfo,
        id: leadId, // same id as lead in leadslist
      );

      // 2️⃣ Delete Lead from leadslist
      final deleted = await _networkService.delete(
        table: SupabaseTables.leadList,
        id: leadId,
      );

      return deleted;
    } catch (e) {
      log("Delete Lead Error: $e");
      return false;
    }
  }
}
