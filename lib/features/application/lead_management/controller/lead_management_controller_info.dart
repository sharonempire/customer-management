part of 'lead_management_controller.dart';

mixin LeadControllerInfoMixin on LeadControllerBase {
  LeadsListModel? _findLeadById(int leadId) {
    if (state.selectedLeadLocally?.id == leadId) {
      return state.selectedLeadLocally;
    }

    for (final lead in state.leadsList) {
      if (lead.id == leadId) return lead;
    }

    for (final lead in _allLeadsCache) {
      if (lead.id == leadId) return lead;
    }

    return null;
  }

  LeadInfoModel _buildInfoFromLeadRow(LeadsListModel lead) {
    final id = lead.id;
    final displayName = (lead.name ?? '').trim();
    String? firstName;
    String? secondName;
    if (displayName.isNotEmpty) {
      final segments = displayName.split(RegExp(r'\s+'));
      firstName = segments.isNotEmpty ? segments.first : null;
      if (segments.length > 1) {
        secondName = segments.sublist(1).join(' ');
      }
    }

    final callLogs =
        id != null && _callLogsByLeadId.containsKey(id)
            ? List<LeadCallLog>.from(_callLogsByLeadId[id]!)
            : null;

    return LeadInfoModel(
      id: id,
      basicInfo: BasicInfo(
        firstName: firstName ?? (displayName.isNotEmpty ? displayName : null),
        secondName: secondName,
        email: lead.email,
        phone: lead.phone?.toString(),
      ),
      callInfo: callLogs,
    );
  }

  Future<LeadInfoModel> _bootstrapLeadInfo({required int leadId}) async {
    final baseLead = _findLeadById(leadId);
    if (baseLead == null) {
      return LeadInfoModel(id: leadId);
    }

    var placeholder = _buildInfoFromLeadRow(baseLead);

    try {
      final created = await _leadManagementRepo.createLeadInfo(placeholder);
      if (created != null) {
        placeholder = created.copyWith(
          callInfo: placeholder.callInfo ?? created.callInfo,
          changesHistory: created.changesHistory ?? placeholder.changesHistory,
        );
      }
    } catch (e, stackTrace) {
      log('_bootstrapLeadInfo create error: $e\n$stackTrace');
    }

    return placeholder;
  }

  Future<LeadInfoModel?> _ensureLeadInfo(
    String leadId,
    LeadInfoModel? base,
  ) async {
    if (base != null) return base;
    try {
      return await _leadManagementRepo.getLeadInfo(leadId);
    } catch (e, stackTrace) {
      log('_ensureLeadInfo error: $e\n$stackTrace');
      return null;
    }
  }

  Future<void> setLeadLocally(LeadsListModel lead, BuildContext context) async {
    state = state.copyWith(selectedLeadLocally: lead);
    await fetchSelectedLeadInfo(context: context, leadId: lead.id.toString());
  }

  void setLeadInfo(LeadInfoModel lead) {
    state = state.copyWith(selectedLead: lead);
  }

  Future<LeadInfoModel> fetchSelectedLeadInfo({
    required BuildContext context,
    required String leadId,
  }) async {
    try {
      final resolvedId = int.tryParse(leadId);
      final fetched = await _leadManagementRepo.getLeadInfo(leadId);

      LeadInfoModel result;
      if (fetched != null) {
        if (resolvedId != null) {
          final fallback = _findLeadById(resolvedId);
          if (fallback != null) {
            final scaffold = _buildInfoFromLeadRow(fallback);
            result = fetched.copyWith(
              basicInfo: fetched.basicInfo ?? scaffold.basicInfo,
              callInfo: fetched.callInfo ?? scaffold.callInfo,
            );
          } else {
            result = fetched;
          }
        } else {
          result = fetched;
        }

        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Lead details loaded');
      } else {
        if (resolvedId != null) {
          result = await _bootstrapLeadInfo(leadId: resolvedId);
        } else {
          result = LeadInfoModel();
        }

        ref
            .read(snackbarServiceProvider)
            .showSuccess(context, 'Lead details ready to edit');
      }

      setLeadInfo(result);
      log('fetchSelectedLeadInfo: prepared info for lead $leadId');
      return result;
    } catch (e) {
      log('fetchSelectedLeadInfo error: $e');
      ref
          .read(snackbarServiceProvider)
          .showError(context, 'Failed to load lead details: $e');
      return LeadInfoModel();
    }
  }
}
