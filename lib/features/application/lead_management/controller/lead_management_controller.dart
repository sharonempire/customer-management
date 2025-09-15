import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:management_software/features/application/lead_management/model/lead_management_dto.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/data/lead_management/repositories/lead_management_repo.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/network/network_calls.dart';

final infoCollectionProgression = StateProvider((ref) => 0);

final leadMangementcontroller =
    StateNotifierProvider<LeadController, LeadManagementDTO>((ref) {
  final repository = LeadManagementRepo(ref.watch(networkServiceProvider));
  return LeadController(ref, repository);
});

class LeadController extends StateNotifier<LeadManagementDTO> {
  final LeadManagementRepo _leadManagementRepo;
  final Ref ref;

  LeadController(this.ref, this._leadManagementRepo)
      : super(const LeadManagementDTO());

  /* -------------------------
     Progression helpers
     ------------------------- */
  void increaseProgression() {
    ref.read(infoCollectionProgression.notifier).update((s) => s + 1);
  }

  void decreaseProgression() {
    ref.read(infoCollectionProgression.notifier).update((s) => s - 1);
  }

  void setProgression(int index) {
    ref.read(infoCollectionProgression.notifier).update((_) => index);
  }

  /* -------------------------
     CRUD / Fetch operations
     Note: all methods accept a BuildContext to show snackbars
     ------------------------- */

  /// Fetch all leads and store in DTO
  Future<void> fetchAllLeads({required BuildContext context}) async {
    try {
      final leads = await _leadManagementRepo.fetchAllLeads();
      state = state.copyWith(leadsList: leads);
      ref.read(snackbarServiceProvider).showSuccess(context, 'Leads loaded');
      log('fetchAllLeads: loaded ${leads.length} leads');
    } catch (e) {
      log('fetchAllLeads error: $e');
      ref.read(snackbarServiceProvider).showError(context, 'Failed to load leads: $e');
    }
  }

  /// Fetch leads for a specific calendar date (date's string format is handled by repo)
  Future<void> fetchLeadsByDate({
    required BuildContext context,
    required String date,
  }) async {
    try {
      final leads = await _leadManagementRepo.fetchLeadsByDate(date);
      state = state.copyWith(leadsList: leads);
      ref.read(snackbarServiceProvider).showSuccess(context, 'Leads for selected date loaded');
      log('fetchLeadsByDate: ${leads.length} leads for $date');
    } catch (e) {
      log('fetchLeadsByDate error: $e');
      ref.read(snackbarServiceProvider).showError(context, 'Failed to fetch leads for date: $e');
    }
  }

  /// Fetch leads between two dates (inclusive)
  Future<void> fetchLeadsByRange({
    required BuildContext context,
    required String start,
    required String end,
  }) async {
    try {
      final leads = await _leadManagementRepo.fetchLeadsInRange(startDate: start, endDate: end);
      state = state.copyWith(leadsList: leads);
      ref.read(snackbarServiceProvider).showSuccess(context, 'Leads loaded for selected range');
      log('fetchLeadsByRange: ${leads.length} leads between $start and $end');
    } catch (e) {
      log('fetchLeadsByRange error: $e');
      ref.read(snackbarServiceProvider).showError(context, 'Failed to fetch leads for range: $e');
    }
  }

  /// Convenience: fetch today's leads
  Future<void> fetchTodaysLeads({required BuildContext context}) async {
    final today = DateTime.now();
    await fetchLeadsByDate(context: context, date: DateTimeHelper.formatDateForLead(today));
  }

  /// Convenience: last 7 days
  Future<void> fetchLastWeekLeads({required BuildContext context}) async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));
    await fetchLeadsByRange(context: context, start: DateTimeHelper.formatDateForLead(start), end:  DateTimeHelper.formatDateForLead(now),);
  }

  /// Convenience: last 30 days
  Future<void> fetchLastMonthLeads({required BuildContext context}) async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    await fetchLeadsByRange(context: context, start: DateTimeHelper.formatDateForLead(start), end:  DateTimeHelper.formatDateForLead(now),);
  }

  /// Fetch detailed lead info (lead_info table) for a given lead id
  Future<void> fetchSelectedLeadInfo({
    required BuildContext context,
    required String leadId,
  }) async {
    try {
      final LeadInfoModel? info = await _leadManagementRepo.getLeadInfo(leadId);
      if (info != null) {
        state = state.copyWith(selectedLead: info);
        ref.read(snackbarServiceProvider).showSuccess(context, 'Lead details loaded');
        log('fetchSelectedLeadInfo: loaded info for lead $leadId');
      } else {
        ref.read(snackbarServiceProvider).showError(context, 'No lead details found');
      }
    } catch (e) {
      log('fetchSelectedLeadInfo error: $e');
      ref.read(snackbarServiceProvider).showError(context, 'Failed to load lead details: $e');
    }
  }

  /* -------------------------
     Add / Update / Delete operations
     ------------------------- */

  /// Add a new lead and refresh list
  Future<bool> addLead({
    required BuildContext context,
    required LeadsListModel lead,
  }) async {
    try {
      final  ok = await _leadManagementRepo.addLead(lead);
      if (ok!=null) {
        ref.read(snackbarServiceProvider).showSuccess(context, 'Lead added successfully!');
        await fetchAllLeads(context: context);
        return true;
      } else {
        ref.read(snackbarServiceProvider).showError(context, 'Failed to add lead.');
        return false;
      }
    } catch (e) {
      log('addLead error: $e');
      ref.read(snackbarServiceProvider).showError(context, 'Failed to add lead: $e');
      return false;
    }
  }

  /// Update an existing lead by id and refresh list / selected lead if needed
  Future<bool> updateLead({
    required BuildContext context,
    required String leadId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      final response = await _leadManagementRepo.updateLead(leadId, updatedData);
      if (response != null) {
        ref.read(snackbarServiceProvider).showSuccess(context, 'Lead updated successfully!');
        // refresh list and selected lead (if currently selected)
        await fetchAllLeads(context: context);
        if (state.selectedLead?.id == leadId) {
          await fetchSelectedLeadInfo(context: context, leadId:  leadId);
        }
        return true;
      } else {
        ref.read(snackbarServiceProvider).showError(context, 'Failed to update lead.');
        return false;
      }
    } catch (e) {
      log('updateLead error: $e');
      ref.read(snackbarServiceProvider).showError(context, 'Failed to update lead: $e');
      return false;
    }
  }

  /// Delete a lead and refresh list
  Future<bool> deleteLead({
    required BuildContext context,
    required String leadId,
  }) async {
    try {
      final bool ok = await _leadManagementRepo.deleteLead(leadId);
      if (ok) {
        ref.read(snackbarServiceProvider).showSuccess(context, 'Lead deleted successfully!');
        await fetchAllLeads(context: context);
        // if deleted lead was selected, clear selection
        if (state.selectedLead?.id == leadId) {
          state = state.copyWith(selectedLead: null);
        }
        return true;
      } else {
        ref.read(snackbarServiceProvider).showError(context, 'Failed to delete lead.');
        return false;
      }
    } catch (e) {
      log('deleteLead error: $e');
      ref.read(snackbarServiceProvider).showError(context, 'Failed to delete lead: $e');
      return false;
    }
  }

  /* -------------------------
     Local helpers
     ------------------------- */

  /// Locally select a lead (without fetching remote details)
  void selectLeadLocally(LeadsListModel lead) {
    state = state.copyWith(selectedLead: null); // clear remote details
    // You might want to convert LeadsListModel -> LeadInfoModel or fetch details
    // For now set only selectedLead to null (or convert if you have a conversion)
    // If you'd like to store a minimal selected lead (LeadsListModel) add a field to DTO
  }
}
