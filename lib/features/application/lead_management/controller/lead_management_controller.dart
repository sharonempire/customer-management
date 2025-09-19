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
final fromNewLead = StateProvider((ref) => false);

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

  void setFromNewLead(bool isFromNewLead) {
    ref.read(fromNewLead.notifier).update((_) => isFromNewLead);
    log("${ref.read(fromNewLead).toString()}.////////////////");
  }

  void decreaseProgression() {
    ref.read(infoCollectionProgression.notifier).update((s) => s - 1);
  }

  void setProgression(int index) {
    ref.read(infoCollectionProgression.notifier).update((_) => index);
  }

  /// Fetch all leads and store in DTO
  Future<void> fetchAllLeads({required BuildContext context}) async {
    try {
      final leads = await _leadManagementRepo.fetchAllLeads();
      state = state.copyWith(leadsList: leads);

      ref.read(snackbarServiceProvider).showSuccess(context, 'Leads loaded');
      log('fetchAllLeads: loaded ${state.leadsList.length} leads');
    } catch (e) {
      log('fetchAllLeads error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to load leads: $e');
    }
  }

  Future<void> setLeadLocally(LeadsListModel lead, BuildContext context) async {
    state = state.copyWith(selectedLeadLocally: lead);
    await fetchSelectedLeadInfo(context: context, leadId: lead.id.toString());
  }

  void setLeadInfo(LeadInfoModel lead) {
    state = state.copyWith(selectedLead: lead);
  }

  Future<void> fetchLeadsByDate({
    required BuildContext context,
    required String date,
  }) async {
    try {
      final leads = await _leadManagementRepo.fetchLeadsByDate(date);
      state = state.copyWith(leadsList: leads);
      ref
          .read(snackbarServiceProvider)
          .showSuccess(context, 'Leads for selected date loaded');
      log('fetchLeadsByDate: ${leads.length} leads for $date');
    } catch (e) {
      log('fetchLeadsByDate error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to fetch leads for date: $e');
    }
  }

  /// Fetch leads between two dates (inclusive)
  Future<void> fetchLeadsByRange({
    required BuildContext context,
    required String start,
    required String end,
  }) async {
    try {
      final leads = await _leadManagementRepo.fetchLeadsInRange(
        startDate: start,
        endDate: end,
      );
      state = state.copyWith(leadsList: leads);
      ref
          .read(snackbarServiceProvider)
          .showSuccess(context, 'Leads loaded for selected range');
      log('fetchLeadsByRange: ${leads.length} leads between $start and $end');
    } catch (e) {
      log('fetchLeadsByRange error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to fetch leads for range: $e');
    }
  }

  /// Convenience: fetch today's leads
  Future<void> fetchTodaysLeads({required BuildContext context}) async {
    final today = DateTime.now();
    await fetchLeadsByDate(
      context: context,
      date: DateTimeHelper.formatDateForLead(today),
    );
  }

  /// Convenience: last 7 days
  Future<void> fetchLastWeekLeads({required BuildContext context}) async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));
    await fetchLeadsByRange(
      context: context,
      start: DateTimeHelper.formatDateForLead(start),
      end: DateTimeHelper.formatDateForLead(now),
    );
  }

  /// Convenience: last 30 days
  Future<void> fetchLastMonthLeads({required BuildContext context}) async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    await fetchLeadsByRange(
      context: context,
      start: DateTimeHelper.formatDateForLead(start),
      end: DateTimeHelper.formatDateForLead(now),
    );
  }

  Future<LeadInfoModel> fetchSelectedLeadInfo({
    required BuildContext context,
    required String leadId,
  }) async {
    try {
      final LeadInfoModel? info = await _leadManagementRepo.getLeadInfo(leadId);
      if (info != null) {
        state = state.copyWith(selectedLead: info);
        log('lead info fetched and stored : ${state.selectedLead?.toJson()}');

        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Lead details loaded');
        log('fetchSelectedLeadInfo: loaded info for lead $leadId');
        setLeadInfo(info);
        return info;
      } else {
        ref
            .read(snackbarServiceProvider)
            .showError(context, 'No lead details found');

        return LeadInfoModel();
      }
    } catch (e) {
      log('fetchSelectedLeadInfo error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to load lead details: $e');
      return LeadInfoModel();
    }
  }

  Future<LeadsListModel> addLead({
    required BuildContext context,
    required LeadsListModel lead,
  }) async {
    try {
      final response = await _leadManagementRepo.addLead(lead);
      if (response != null) {
        await _leadManagementRepo.createLeadInfo(
          LeadInfoModel(id: response.id),
        );

        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Lead added successfully!');
        await fetchAllLeads(context: context);
        state = state.copyWith(selectedLeadLocally: response);
        return response;
      } else {
        ref
            .read(snackbarServiceProvider)
            .showError(context, 'Failed to add lead.');
        return LeadsListModel();
      }
    } catch (e) {
      log('addLead error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to add lead: $e');
      return LeadsListModel();
    }
  }

  Future<bool> updateListDetails({
    required BuildContext context,
    required String leadId,
    required LeadsListModel updatedData,
  }) async {
    try {
      if (state.selectedLeadLocally?.id == int.parse(leadId)) {
        final leadinfo = await _leadManagementRepo.updateLead(
          leadId,
          updatedData.toJson(),
        );
        setLeadLocally(leadinfo??LeadsListModel(), context);

        if (leadinfo != null) {
          ref
              .read(snackbarServiceProvider)
              .showSuccess(context, 'Lead info updated');
          await fetchAllLeads(context: context);
        } else {
          ref
              .read(snackbarServiceProvider)
              .showError(context, 'Failed to update lead.');
          return false;
        }
      }
      return true;
    } catch (e) {
      log('updateLead error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to update lead: $e');
      return false;
    }
  }

  Future<bool> updateLeadInfo({
    required BuildContext context,
    required String leadId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      if (state.selectedLeadLocally?.id == int.parse(leadId)) {
        final leadinfo = await _leadManagementRepo.updateLeadInfo(
          leadId,
          updatedData,
        );
        setLeadInfo(leadinfo ?? LeadInfoModel());

        if (leadinfo != null) {
          ref
              .read(snackbarServiceProvider)
              .showSuccess(context, 'Lead updated successfully!');
          await fetchAllLeads(context: context);
        } else {
          ref
              .read(snackbarServiceProvider)
              .showError(context, 'Failed to update lead.');
          return false;
        }
      }
      return true;
    } catch (e) {
      log('updateLead error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to update lead: $e');
      return false;
    }
  }

  Future<bool> deleteLead({
    required BuildContext context,
    required String leadId,
  }) async {
    try {
      final bool ok = await _leadManagementRepo.deleteLead(leadId);
      if (ok) {
        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Lead deleted successfully!');
        await fetchAllLeads(context: context);
        // if deleted lead was selected, clear selection
        if (state.selectedLeadLocally?.id == leadId) {
          state = state.copyWith(selectedLead: null);
        }
        return true;
      } else {
        ref
            .read(snackbarServiceProvider)
            .showError(context, 'Failed to delete lead.');
        return false;
      }
    } catch (e) {
      log('deleteLead error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to delete lead: $e');
      return false;
    }
  }

  void selectLeadLocally(LeadsListModel lead) {
    state = state.copyWith(selectedLeadLocally: lead);
  }
}
