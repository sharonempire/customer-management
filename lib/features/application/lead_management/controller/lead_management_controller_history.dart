part of 'lead_management_controller.dart';

mixin LeadControllerHistoryMixin
    on LeadControllerBase, LeadControllerInfoMixin {
  UserProfileModel? _currentActorProfile() {
    final profile = ref.read(authControllerProvider);
    final hasIdentity =
        (profile.id?.trim().isNotEmpty ?? false) ||
        (profile.displayName?.trim().isNotEmpty ?? false) ||
        (profile.email?.trim().isNotEmpty ?? false);
    return hasIdentity ? profile : null;
  }

  String? _profileDisplayName(UserProfileModel? profile) {
    if (profile == null) return null;
    final name = profile.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final email = profile.email?.trim();
    if (email != null && email.isNotEmpty) return email;
    if (profile.phone != null) return profile.phone.toString();
    return null;
  }

  String? _resolveMentorNameById(String? mentorId) {
    final id = mentorId?.trim();
    if (id == null || id.isEmpty) return null;

    for (final mentor in state.counsellors) {
      final candidateId = mentor.id?.trim();
      if (candidateId != null && candidateId == id) {
        return _profileDisplayName(mentor) ?? candidateId;
      }
    }

    final assignedProfile = state.selectedLeadLocally?.assignedProfile;
    final assignedId = assignedProfile?.id?.trim();
    if (assignedId != null && assignedId == id) {
      return _profileDisplayName(assignedProfile) ?? assignedId;
    }

    return null;
  }

  String _truncateNote(String value, {int max = 120}) {
    final trimmed = value.trim();
    if (trimmed.length <= max) {
      return trimmed;
    }
    return '${trimmed.substring(0, max - 3)}...';
  }

  String? _formatFollowUpText(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = DateTimeHelper.parseDate(value);
    if (parsed != null) {
      return DateTimeHelper.formatDateForLead(parsed);
    }
    return value.trim();
  }

  LeadStatusChangeLog _createHistoryLog({
    required String statusLabel,
    String? previousStatus,
    String? note,
    DateTime? timestamp,
  }) {
    final actor = _currentActorProfile();
    return LeadStatusChangeLog(
      status: statusLabel,
      previousStatus: previousStatus,
      mentorId: actor?.id?.trim().isNotEmpty == true ? actor!.id : null,
      mentorName: _profileDisplayName(actor),
      note: note,
      changedAt: (timestamp ?? DateTime.now()).toUtc(),
    );
  }

  List<LeadStatusChangeLog> _buildLeadListHistoryEntries({
    required LeadsListModel? previous,
    required LeadsListModel updated,
  }) {
    if (previous == null) return const <LeadStatusChangeLog>[];

    final entries = <LeadStatusChangeLog>[];

    final prevStatus = previous.status?.trim();
    final newStatus = updated.status?.trim();
    if ((newStatus?.isNotEmpty ?? false) && newStatus != prevStatus) {
      entries.add(
        _createHistoryLog(
          statusLabel: newStatus!,
          previousStatus: prevStatus,
          note: 'Status updated to $newStatus',
        ),
      );
    }

    final prevFollow = previous.followUp?.trim();
    final newFollow = updated.followUp?.trim();
    if (prevFollow != newFollow) {
      final formattedNew = _formatFollowUpText(newFollow);
      final formattedPrev = _formatFollowUpText(prevFollow);
      final buffer = StringBuffer();
      if (formattedNew != null) {
        buffer.write('Follow-up set to $formattedNew');
      } else {
        buffer.write('Follow-up cleared');
      }
      if (formattedPrev != null) {
        buffer.write(' (was $formattedPrev)');
      }
      entries.add(
        _createHistoryLog(statusLabel: 'FOLLOW UP', note: buffer.toString()),
      );
    }

    final prevRemark = previous.remark?.trim() ?? '';
    final newRemark = updated.remark?.trim() ?? '';
    if (prevRemark != newRemark) {
      final buffer = StringBuffer();
      if (newRemark.isEmpty) {
        buffer.write('Remark cleared');
      } else {
        buffer.write('Remark updated: "${_truncateNote(newRemark)}"');
      }
      if (prevRemark.isNotEmpty) {
        buffer.write(' (was "${_truncateNote(prevRemark)}")');
      }
      entries.add(
        _createHistoryLog(statusLabel: 'REMARK', note: buffer.toString()),
      );
    }

    final prevMentor = previous.assignedTo?.trim();
    final newMentor = updated.assignedTo?.trim();
    if (prevMentor != newMentor) {
      final newMentorLabel = _resolveMentorNameById(newMentor);
      final prevMentorLabel = _resolveMentorNameById(prevMentor);
      final buffer = StringBuffer();
      if (newMentorLabel != null) {
        buffer.write('Mentor assigned to $newMentorLabel');
      } else if (newMentor != null && newMentor.isNotEmpty) {
        buffer.write('Mentor assigned to $newMentor');
      } else {
        buffer.write('Mentor unassigned');
      }
      if (prevMentorLabel != null) {
        buffer.write(' (was $prevMentorLabel)');
      } else if (prevMentor != null && prevMentor.isNotEmpty) {
        buffer.write(' (was $prevMentor)');
      }
      entries.add(
        _createHistoryLog(statusLabel: 'MENTOR', note: buffer.toString()),
      );
    }

    return entries;
  }

  List<LeadStatusChangeLog> _buildLeadInfoHistoryEntries(
    Map<String, dynamic> payload,
    LeadInfoModel? previous,
  ) {
    if (payload.isEmpty) return const <LeadStatusChangeLog>[];

    final entries = <LeadStatusChangeLog>[];
    final cleaned =
        Map<String, dynamic>.from(payload)
          ..remove('changes_history')
          ..remove('id')
          ..remove('created_at');

    void addEntry({
      required String key,
      required String label,
      dynamic previousValue,
      String? note,
    }) {
      if (!cleaned.containsKey(key)) return;
      final currentValue = cleaned[key];
      if (!_jsonContentChanged(previousValue, currentValue)) return;
      entries.add(
        _createHistoryLog(statusLabel: label, note: note ?? '$label edited'),
      );
    }

    addEntry(
      key: 'basic_info',
      label: 'BASIC INFO',
      previousValue: previous?.basicInfo?.toJson(),
      note: 'Basic info edited',
    );
    addEntry(
      key: 'education',
      label: 'EDUCATION',
      previousValue: previous?.education?.toJson(),
      note: 'Education details edited',
    );
    addEntry(
      key: 'work_expierience',
      label: 'WORK EXPERIENCE',
      previousValue: previous?.workExperience?.map((e) => e.toJson()).toList(),
      note: 'Work experience updated',
    );
    addEntry(
      key: 'budget_info',
      label: 'BUDGET',
      previousValue: previous?.budgetInfo?.toJson(),
      note: 'Budget info edited',
    );
    addEntry(
      key: 'preferences',
      label: 'PREFERENCES',
      previousValue: previous?.preferences?.toJson(),
      note: 'Preferences updated',
    );
    addEntry(
      key: 'english_proficiency',
      label: 'ENGLISH',
      previousValue: previous?.englishProficiency?.toJson(),
      note: 'English proficiency updated',
    );

    if (cleaned.containsKey('call_info')) {
      final previousCalls = previous?.callInfo?.map((e) => e.toJson()).toList();
      if (_jsonContentChanged(previousCalls, cleaned['call_info'])) {
        entries.add(
          _createHistoryLog(
            statusLabel: 'CALL LOG',
            note: 'Call history refreshed',
          ),
        );
      }
    }

    return entries;
  }

  String _normalizeJson(dynamic value) {
    if (value == null) return '';
    try {
      return jsonEncode(value);
    } catch (_) {
      return value.toString();
    }
  }

  bool _jsonContentChanged(dynamic previous, dynamic current) {
    return _normalizeJson(previous) != _normalizeJson(current);
  }

  Future<void> _appendHistoryEntries({
    required String leadId,
    required List<LeadStatusChangeLog> entries,
    LeadInfoModel? base,
  }) async {
    if (entries.isEmpty) return;

    try {
      final existingInfo = await _ensureLeadInfo(
        leadId,
        base ?? state.selectedLead,
      );
      final combined = <LeadStatusChangeLog>[
        ...?existingInfo?.changesHistory,
        ...entries,
      ];

      final payload = {
        'changes_history': combined.map((e) => e.toJson()).toList(),
      };

      final updated = await _leadManagementRepo.updateLeadInfo(leadId, payload);

      if (updated != null) {
        setLeadInfo(updated);
      } else if (existingInfo != null) {
        setLeadInfo(existingInfo.copyWith(changesHistory: combined));
      }
    } catch (e, stackTrace) {
      log('_appendHistoryEntries error: $e\n$stackTrace');
    }
  }
}
