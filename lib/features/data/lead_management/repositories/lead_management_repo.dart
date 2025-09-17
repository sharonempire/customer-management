import 'dart:developer';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/data/storage/shared_preferences.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/supabase/keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeadManagementRepo {
  final NetworkService _networkService;

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
      final response = await _networkService.pull(
        table: SupabaseTables.leadList,
        filters: {
          'created_at': {'gte': startDate, 'lte': endDate},
        },
        orderBy: "created_at",
        ascending: false,
      );

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

  Future<List<LeadsListModel>> fetchLeadsByDate(String date) async {
    try {
      final response = await _networkService.pull(
        table: SupabaseTables.leadList,
        filters: {'date': date},
        orderBy: "created_at",
        ascending: false,
      );
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
