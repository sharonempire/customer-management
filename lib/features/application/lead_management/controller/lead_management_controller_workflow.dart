part of 'lead_management_controller.dart';

mixin LeadControllerWorkflowMixin
    on
        LeadControllerBase,
        LeadControllerFilterMixin,
        LeadControllerInfoMixin,
        LeadControllerHistoryMixin {
  void increaseProgression() {
    ref.read(infoCollectionProgression.notifier).update((s) => s + 1);
  }

  void setFromNewLead(bool isFromNewLead) {
    ref.read(fromNewLead.notifier).update((_) => isFromNewLead);
    log('${ref.read(fromNewLead).toString()}.////////////////');
  }

  void decreaseProgression() {
    ref.read(infoCollectionProgression.notifier).update((s) => s - 1);
  }

  void setProgression(int index) {
    ref.read(infoCollectionProgression.notifier).update((_) => index);
  }

  Future<void> fetchAllLeads({required BuildContext context}) async {
    try {
      final leads = await _leadManagementRepo.fetchAllLeads();
      _setActiveLeads(leads, updateCache: true);
      await _loadCallLogs(leads);
      _updateDateFilter();

      ref.read(snackbarServiceProvider).showSuccess(context, 'Leads loaded');
      log('fetchAllLeads: loaded ${state.leadsList.length} leads');
    } catch (e) {
      log('fetchAllLeads error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to load leads: $e');
    }
  }

  Future<List<UserProfileModel>> fetchCounsellors({
    required BuildContext context,
    bool forceRefresh = false,
  }) async {
    if (state.counsellors.isNotEmpty && !forceRefresh) {
      return state.counsellors;
    }

    try {
      final counsellors = await _leadManagementRepo.fetchCounsellors();
      state = state.copyWith(counsellors: counsellors);
      return counsellors;
    } catch (e) {
      log('fetchCounsellors error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to load counsellors: $e');
      return [];
    }
  }

  Future<void> fetchLeadsByDate({
    required BuildContext context,
    required String date,
  }) async {
    try {
      final leads = await _leadManagementRepo.fetchLeadsByDate(date);
      final effectiveLeads = leads.isNotEmpty ? leads : _fallbackLeads();
      _setActiveLeads(effectiveLeads);
      await _loadCallLogs(effectiveLeads);
      final parsedDate = DateTimeHelper.parseDate(date);
      _updateDateFilter(start: parsedDate, end: parsedDate);
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
      final effectiveLeads = leads.isNotEmpty ? leads : _fallbackLeads();
      _setActiveLeads(effectiveLeads);
      await _loadCallLogs(effectiveLeads);
      final startDate = DateTimeHelper.parseDate(start);
      final endDate = DateTimeHelper.parseDate(end);
      _updateDateFilter(start: startDate, end: endDate);
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

  Future<void> fetchTodaysLeads({required BuildContext context}) async {
    final today = DateTime.now();
    await fetchLeadsByDate(
      context: context,
      date: DateTimeHelper.formatDateForLead(today),
    );
  }

  Future<void> fetchThisWeekLeads({required BuildContext context}) async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));
    await fetchLeadsByRange(
      context: context,
      start: DateTimeHelper.formatDateForLead(start),
      end: DateTimeHelper.formatDateForLead(now),
    );
  }

  Future<void> fetchLastWeekLeads({required BuildContext context}) async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 7));
    await fetchLeadsByRange(
      context: context,
      start: DateTimeHelper.formatDateForLead(
        now.subtract(const Duration(days: 14)),
      ),
      end: DateTimeHelper.formatDateForLead(start),
    );
  }

  Future<void> fetchLastMonthLeads({required BuildContext context}) async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 30));
    await fetchLeadsByRange(
      context: context,
      start: DateTimeHelper.formatDateForLead(start),
      end: DateTimeHelper.formatDateForLead(now),
    );
  }

  Future<void> initiateLeadCall({
    required BuildContext context,
    required LeadsListModel lead,
  }) async {
    final snackbar = ref.read(snackbarServiceProvider);

    const hardcodedSource = '+91 73565 33368';
    const hardcodedDestination = '+918129130745';
    const hardcodedExtension = '100';
    const hardcodedCallerId = '914847173130';

    final agentNumber = hardcodedSource.trim();
    final destination = hardcodedDestination.trim();
    if (destination.isEmpty) {
      snackbar.showError(context, 'Destination number is missing.');
      return;
    }

    if (agentNumber.isEmpty) {
      snackbar.showError(context, 'Source number is missing.');
      return;
    }

    final extension = hardcodedExtension.trim();
    final callerId = hardcodedCallerId.trim();

    try {
      final clickResult = await _leadManagementRepo.triggerClickToCall(
        source: agentNumber,
        destination: destination,
        extension: extension,
        callerId: callerId,
      );

      if (clickResult.success) {
        snackbar.showSuccess(context, 'Dialling $destination');
      } else {
        snackbar.showError(context, clickResult.message);
      }
    } catch (error) {
      snackbar.showError(context, 'Failed to initiate call: $error');
    }
  }

  String? _resolveAgentPhone(LeadsListModel lead) {
    final candidates = <String?>[];

    final assignedProfile = lead.assignedProfile;
    if (assignedProfile?.phone != null) {
      candidates.add(assignedProfile!.phone.toString());
    }

    final assignedId = lead.assignedTo?.trim();
    if (assignedId != null && assignedId.isNotEmpty) {
      for (final counsellor in state.counsellors) {
        final counsellorId = counsellor.id?.trim();
        if (counsellorId != null && counsellorId == assignedId) {
          if (counsellor.phone != null) {
            candidates.add(counsellor.phone.toString());
          }
          break;
        }
      }
    }

    final currentUser = ref.read(authControllerProvider);
    if (currentUser.phone != null) {
      candidates.add(currentUser.phone.toString());
    }

    for (final candidate in candidates) {
      final normalized = _normalizePhoneValue(candidate);
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }

    return null;
  }

  String _resolveAgentExtension(LeadsListModel lead, String agentPhone) {
    final preferred = _extractDigits(
      lead.assignedProfile?.designation ?? lead.assignedProfile?.freelancerStatus,
    );
    if (preferred != null && preferred.isNotEmpty) {
      return preferred;
    }

    final assignedId = lead.assignedTo?.trim();
    if (assignedId != null && assignedId.isNotEmpty) {
      for (final counsellor in state.counsellors) {
        final counsellorId = counsellor.id?.trim();
        if (counsellorId != null && counsellorId == assignedId) {
          final fallback = _extractDigits(counsellor.designation);
          if (fallback != null && fallback.isNotEmpty) {
            return fallback;
          }
          break;
        }
      }
    }

    final user = ref.read(authControllerProvider);
    final userExt = _extractDigits(user.designation);
    if (userExt != null && userExt.isNotEmpty) {
      return userExt;
    }

    return agentPhone;
  }

  String _resolveCallerId(LeadsListModel lead) {
    final assignedProfile = lead.assignedProfile;
    final preferred = _extractDigits(assignedProfile?.location);
    if (preferred != null && preferred.isNotEmpty) {
      return preferred;
    }

    return ref.read(voxbayCallServiceProvider).config.defaultCallerId;
  }

  String? _extractDigits(String? value) {
    if (value == null) return null;
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? null : digits;
  }

  Future<LeadsListModel> addLead({
    required BuildContext context,
    required LeadsListModel lead,
  }) async {
    try {
      final response = await _leadManagementRepo.addLead(lead);
      final creationEntry = _createHistoryLog(
        statusLabel: 'CREATED',
        note:
            response.status != null && response.status!.trim().isNotEmpty
                ? 'Lead created with status ${response.status}'
                : 'Lead created',
      );

      await _leadManagementRepo.createLeadInfo(
        LeadInfoModel(id: response.id, changesHistory: [creationEntry]),
      );

      ref
          .read(snackbarServiceProvider)
          .showSuccess(context, 'Lead added successfully!');
      await fetchAllLeads(context: context);
      state = state.copyWith(selectedLeadLocally: response);
      return response;
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
      final parsedId = int.tryParse(leadId);
      final isSelectedLead =
          parsedId != null && state.selectedLeadLocally?.id == parsedId;
      final previousLead = isSelectedLead ? state.selectedLeadLocally : null;
      final previousInfo = isSelectedLead ? state.selectedLead : null;

      final updatedLead = await _leadManagementRepo.updateLead(
        leadId,
        updatedData.toJson(),
      );

      if (updatedLead != null) {
        if (isSelectedLead) {
          final historyEntries = _buildLeadListHistoryEntries(
            previous: previousLead,
            updated: updatedLead,
          );
          await _appendHistoryEntries(
            leadId: leadId,
            entries: historyEntries,
            base: previousInfo,
          );
          await setLeadLocally(updatedLead, context);
        }

        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Lead info updated');
        await fetchAllLeads(context: context);
        return true;
      }

      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to update lead.');
      return false;
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
      final parsedId = int.tryParse(leadId);
      final isSelectedLead =
          parsedId != null && state.selectedLeadLocally?.id == parsedId;
      final baseInfo = await _ensureLeadInfo(
        leadId,
        isSelectedLead ? state.selectedLead : null,
      );

      final historyEntries =
          baseInfo != null
              ? _buildLeadInfoHistoryEntries(updatedData, baseInfo)
              : const <LeadStatusChangeLog>[];

      final payload = Map<String, dynamic>.from(updatedData);
      if (baseInfo != null && historyEntries.isNotEmpty) {
        final combinedHistory = <LeadStatusChangeLog>[
          ...?baseInfo.changesHistory,
          ...historyEntries,
        ];
        payload['changes_history'] =
            combinedHistory.map((entry) => entry.toJson()).toList();
      }

      final leadinfo = await _leadManagementRepo.updateLeadInfo(
        leadId,
        payload,
      );

      if (leadinfo != null) {
        if (isSelectedLead) {
          setLeadInfo(leadinfo);
        }
        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Lead updated successfully!');
        await fetchAllLeads(context: context);
        return true;
      }

      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to update lead.');

      if (isSelectedLead && baseInfo != null && historyEntries.isNotEmpty) {
        final combinedHistory = <LeadStatusChangeLog>[
          ...?baseInfo.changesHistory,
          ...historyEntries,
        ];
        setLeadInfo(baseInfo.copyWith(changesHistory: combinedHistory));
      }

      return false;
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
}
