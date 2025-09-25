import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:management_software/features/application/authentification/controller/auth_controller.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/application/lead_management/model/lead_management_dto.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/data/lead_management/repositories/lead_management_repo.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/network/network_calls.dart';

final infoCollectionProgression = StateProvider((ref) => 0);
final fromNewLead = StateProvider((ref) => false);

enum LeadTab { currentFollowUps, drafts, newEnquiries }

final leadTabProvider = StateProvider<LeadTab>(
  (ref) => LeadTab.currentFollowUps,
);

class LeadDateFilter {
  final DateTime? start;
  final DateTime? end;

  const LeadDateFilter({this.start, this.end});

  LeadDateFilter copyWith({DateTime? start, DateTime? end}) {
    return LeadDateFilter(start: start ?? this.start, end: end ?? this.end);
  }
}

final leadDateFilterProvider = StateProvider<LeadDateFilter>((ref) {
  return const LeadDateFilter();
});

final currentFollowUpsProvider = Provider<List<LeadsListModel>>((ref) {
  final filter = ref.watch(leadDateFilterProvider);
  final controller = ref.read(leadMangementcontroller.notifier);
  // Ensure the provider rebuilds when the lead state changes
  ref.watch(leadMangementcontroller);
  return controller.currentFollowUps(filter: filter);
});

class DraftLead {
  final LeadsListModel lead;
  final LeadCallLog latestCall;
  final DateTime latestCallDate;
  final int totalCalls;

  const DraftLead({
    required this.lead,
    required this.latestCall,
    required this.latestCallDate,
    required this.totalCalls,
  });
}

final draftLeadsProvider = Provider<List<DraftLead>>((ref) {
  final filter = ref.watch(leadDateFilterProvider);
  ref.watch(leadMangementcontroller);
  final controller = ref.read(leadMangementcontroller.notifier);
  return controller.draftLeads(filter: filter);
});

final leadMangementcontroller =
    StateNotifierProvider<LeadController, LeadManagementDTO>((ref) {
      final repository = LeadManagementRepo(ref.watch(networkServiceProvider));
      return LeadController(ref, repository);
    });

class LeadController extends StateNotifier<LeadManagementDTO> {
  final LeadManagementRepo _leadManagementRepo;
  final Ref ref;
  List<LeadsListModel> _allLeadsCache = const [];
  Map<int, List<LeadCallLog>> _callLogsByLeadId = <int, List<LeadCallLog>>{};

  LeadController(this.ref, this._leadManagementRepo)
    : super(const LeadManagementDTO());

  void _setActiveLeads(List<LeadsListModel> leads, {bool updateCache = false}) {
    final safeLeads = List<LeadsListModel>.unmodifiable(leads);
    if (updateCache) {
      _allLeadsCache = safeLeads;
    }
    state = state.copyWith(leadsList: safeLeads);
    _refreshFilters();
  }

  void clearDateFilter() {
    _updateDateFilter();
    if (_allLeadsCache.isNotEmpty) {
      state = state.copyWith(
        leadsList: List<LeadsListModel>.from(_allLeadsCache),
      );
    }
    applyFilters();
  }

  List<LeadsListModel> _fallbackLeads() {
    if (_allLeadsCache.isNotEmpty) {
      return List<LeadsListModel>.from(_allLeadsCache);
    }
    if (state.leadsList.isNotEmpty) {
      return List<LeadsListModel>.from(state.leadsList);
    }
    return <LeadsListModel>[];
  }

  void _updateDateFilter({DateTime? start, DateTime? end}) {
    ref.read(leadDateFilterProvider.notifier).state = LeadDateFilter(
      start: start,
      end: end,
    );
    _refreshFilters();
  }

  DateTime? _normalizeDate(DateTime? date) {
    if (date == null) return null;
    return DateTime(date.year, date.month, date.day);
  }

  void _refreshFilters() {
    final dateFilter = ref.read(leadDateFilterProvider);
    final filtered = _applyCreatedAtFilter(
      _applyCommonFilters(state.leadsList),
      dateFilter,
    );
    state = state.copyWith(filteredLeadsList: filtered);
  }

  List<LeadsListModel> _applyCreatedAtFilter(
    List<LeadsListModel> leads,
    LeadDateFilter filter,
  ) {
    final normalizedStart = _normalizeDate(filter.start);
    final normalizedEnd = _normalizeDate(filter.end ?? filter.start);
    if (normalizedStart == null && normalizedEnd == null) {
      return leads;
    }

    bool withinRange(DateTime createdAt) {
      final normalizedCreated = _normalizeDate(createdAt);
      if (normalizedCreated == null) return false;
      if (normalizedStart != null && normalizedEnd != null) {
        return !normalizedCreated.isBefore(normalizedStart) &&
            !normalizedCreated.isAfter(normalizedEnd);
      }
      if (normalizedStart != null) {
        return !normalizedCreated.isBefore(normalizedStart);
      }
      if (normalizedEnd != null) {
        return !normalizedCreated.isAfter(normalizedEnd);
      }
      return true;
    }

    return leads.where((lead) {
      final createdAt = lead.createdAt;
      if (createdAt == null) {
        return normalizedStart == null && normalizedEnd == null;
      }
      return withinRange(createdAt.toLocal());
    }).toList();
  }

  List<LeadsListModel> _applyCommonFilters(List<LeadsListModel> leads) {
    var filtered = leads;

    final query = state.searchQuery.trim();
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      filtered =
          filtered.where((lead) {
            final nameMatch =
                lead.name?.toLowerCase().contains(lowerQuery) ?? false;
            final emailMatch =
                lead.email?.toLowerCase().contains(lowerQuery) ?? false;
            final phoneMatch =
                lead.phone?.toString().contains(lowerQuery) ?? false;
            return nameMatch || emailMatch || phoneMatch;
          }).toList();
    }

    if (state.filterSource.isNotEmpty) {
      filtered =
          filtered.where((lead) => lead.source == state.filterSource).toList();
    }

    if (state.filterStatus.isNotEmpty) {
      filtered =
          filtered.where((lead) => lead.status == state.filterStatus).toList();
    }

    if (state.filterFreelancer.isNotEmpty) {
      filtered =
          filtered
              .where((lead) => lead.freelancer == state.filterFreelancer)
              .toList();
    }

    if (state.filterLeadType.isNotEmpty) {
      filtered =
          filtered
              .where((lead) => lead.draftStatus == state.filterLeadType)
              .toList();
    }

    return filtered;
  }

  DateTime? _extractCallLogDate(LeadCallLog log) {
    return log.callDateTime ??
        log.endTime ??
        log.startTime ??
        DateTimeHelper.parseDate(log.callDateLabel);
  }

  LeadCallLog? _latestCallLog(List<LeadCallLog> callLogs) {
    LeadCallLog? latest;
    DateTime? latestDate;
    for (final log in callLogs) {
      final callDate = _extractCallLogDate(log);
      if (callDate == null) continue;
      if (latestDate == null || callDate.isAfter(latestDate)) {
        latest = log;
        latestDate = callDate;
      }
    }
    return latest;
  }

  Future<void> _loadCallLogs(List<LeadsListModel> leads) async {
    try {
      if (leads.isEmpty) {
        _callLogsByLeadId = <int, List<LeadCallLog>>{};
        return;
      }

      final callLogs = await _leadManagementRepo.fetchLeadCallLogs();
      if (callLogs.isEmpty) {
        _callLogsByLeadId = <int, List<LeadCallLog>>{};
        return;
      }

      final sanitized = <int, List<LeadCallLog>>{};
      callLogs.forEach((id, logs) {
        if (logs != null && logs.isNotEmpty) {
          sanitized[id] = List<LeadCallLog>.unmodifiable(logs);
        }
      });

      _callLogsByLeadId = sanitized;
    } catch (e, stackTrace) {
      log('_loadCallLogs error: $e\n$stackTrace');
      _callLogsByLeadId = <int, List<LeadCallLog>>{};
    } finally {
      applyFilters();
    }
  }

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

    final callLogs = id != null && _callLogsByLeadId.containsKey(id)
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
        _createHistoryLog(
          statusLabel: 'FOLLOW UP',
          note: buffer.toString(),
        ),
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
        _createHistoryLog(
          statusLabel: 'REMARK',
          note: buffer.toString(),
        ),
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
        _createHistoryLog(
          statusLabel: 'MENTOR',
          note: buffer.toString(),
        ),
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
    final cleaned = Map<String, dynamic>.from(payload)
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
        _createHistoryLog(
          statusLabel: label,
          note: note ?? '$label edited',
        ),
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
      previousValue:
          previous?.workExperience?.map((e) => e.toJson()).toList(),
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
      final previousCalls =
          previous?.callInfo?.map((e) => e.toJson()).toList();
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

  Future<void> _appendHistoryEntries({
    required String leadId,
    required List<LeadStatusChangeLog> entries,
    LeadInfoModel? base,
  }) async {
    if (entries.isEmpty) return;

    try {
      final existingInfo =
          await _ensureLeadInfo(leadId, base ?? state.selectedLead);
      final combined = <LeadStatusChangeLog>[
        ...?existingInfo?.changesHistory,
        ...entries,
      ];

      final payload = {
        'changes_history': combined.map((e) => e.toJson()).toList(),
      };

      final updated = await _leadManagementRepo.updateLeadInfo(
        leadId,
        payload,
      );

      if (updated != null) {
        setLeadInfo(updated);
      } else if (existingInfo != null) {
        setLeadInfo(existingInfo.copyWith(changesHistory: combined));
      }
    } catch (e, stackTrace) {
      log('_appendHistoryEntries error: $e\n$stackTrace');
    }
  }

  List<LeadsListModel> currentFollowUps({LeadDateFilter? filter}) {
    final selectedFilter = filter ?? ref.read(leadDateFilterProvider);
    final filteredLeads = _applyCommonFilters(state.leadsList);

    final normalizedStart = _normalizeDate(selectedFilter?.start);
    final normalizedEnd = _normalizeDate(
      selectedFilter?.end ?? selectedFilter?.start,
    );

    bool withinRange(DateTime date) {
      final normalized = _normalizeDate(date)!;
      if (normalizedStart != null && normalizedEnd != null) {
        return !normalized.isBefore(normalizedStart) &&
            !normalized.isAfter(normalizedEnd);
      }
      if (normalizedStart != null) {
        return !normalized.isBefore(normalizedStart);
      }
      if (normalizedEnd != null) {
        return !normalized.isAfter(normalizedEnd);
      }
      return true;
    }

    final followUps =
        filteredLeads.where((lead) {
            final followUpDate = DateTimeHelper.parseDate(lead.followUp);
            if (followUpDate == null) {
              return false;
            }
            return withinRange(followUpDate);
          }).toList()
          ..sort((a, b) {
            final aDate = DateTimeHelper.parseDate(a.followUp);
            final bDate = DateTimeHelper.parseDate(b.followUp);
            if (aDate == null && bDate == null) return 0;
            if (aDate == null) return 1;
            if (bDate == null) return -1;
            return aDate.compareTo(bDate);
          });

    return followUps;
  }

  List<DraftLead> draftLeads({LeadDateFilter? filter}) {
    final selectedFilter = filter ?? ref.read(leadDateFilterProvider);
    final filteredLeads = _applyCommonFilters(state.leadsList);

    final normalizedStart = _normalizeDate(selectedFilter?.start);
    final normalizedEnd = _normalizeDate(
      selectedFilter?.end ?? selectedFilter?.start,
    );

    bool withinRange(DateTime date) {
      final normalized = _normalizeDate(date)!;
      if (normalizedStart != null && normalizedEnd != null) {
        return !normalized.isBefore(normalizedStart) &&
            !normalized.isAfter(normalizedEnd);
      }
      if (normalizedStart != null) {
        return !normalized.isBefore(normalizedStart);
      }
      if (normalizedEnd != null) {
        return !normalized.isAfter(normalizedEnd);
      }
      return true;
    }

    final drafts = <DraftLead>[];

    for (final lead in filteredLeads) {
      final id = lead.id;
      if (id == null) continue;

      final normalizedStatus =
          (lead.status ?? '')
              .toLowerCase()
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
      if (normalizedStatus == 'course sent') {
        continue;
      }

      final callLogs = _callLogsByLeadId[id];
      if (callLogs == null || callLogs.isEmpty) continue;

      final latestCall = _latestCallLog(callLogs);
      if (latestCall == null) continue;

      final callDateTime = _extractCallLogDate(latestCall);
      if (callDateTime == null) continue;

      if (!withinRange(callDateTime)) continue;

      drafts.add(
        DraftLead(
          lead: lead,
          latestCall: latestCall,
          latestCallDate: callDateTime,
          totalCalls: callLogs.length,
        ),
      );
    }

    drafts.sort((a, b) => b.latestCallDate.compareTo(a.latestCallDate));

    return drafts;
  }

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

  void clearFilters() {
    state = state.copyWith(
      filterSource: '',
      filterStatus: '',
      filterLeadType: '',
      filterFreelancer: '',
      searchQuery: '',
    );
    clearDateFilter();
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

  /// Convenience: fetch today's leads
  Future<void> fetchTodaysLeads({required BuildContext context}) async {
    final today = DateTime.now();
    await fetchLeadsByDate(
      context: context,
      date: DateTimeHelper.formatDateForLead(today),
    );
  }

  /// Convenience: last 7 days
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

  Future<LeadsListModel> addLead({
    required BuildContext context,
    required LeadsListModel lead,
  }) async {
    try {
      final response = await _leadManagementRepo.addLead(lead);
      if (response != null) {
        final creationEntry = _createHistoryLog(
          statusLabel: 'CREATED',
          note: response.status != null && response.status!.trim().isNotEmpty
              ? 'Lead created with status ${response.status}'
              : 'Lead created',
        );

        await _leadManagementRepo.createLeadInfo(
          LeadInfoModel(
            id: response.id,
            changesHistory: [creationEntry],
          ),
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
      final baseInfo =
          await _ensureLeadInfo(leadId, isSelectedLead ? state.selectedLead : null);

      final historyEntries =
          baseInfo != null ? _buildLeadInfoHistoryEntries(updatedData, baseInfo) : const <LeadStatusChangeLog>[];

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

  void changeStatus(String status) {
    state = state.copyWith(filterStatus: status);
    _refreshFilters();
  }

  void changeSource(String source) {
    state = state.copyWith(filterSource: source);
    _refreshFilters();
  }

  void changeFreelancer(String freelancer) {
    state = state.copyWith(filterFreelancer: freelancer);
    _refreshFilters();
  }

  void changeLeadType(String leadType) {
    state = state.copyWith(filterLeadType: leadType);
    _refreshFilters();
  }

  void changeSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _refreshFilters();
  }

  void applyFilters() {
    _refreshFilters();
  }

  void selectLeadLocally(LeadsListModel lead) {
    state = state.copyWith(selectedLeadLocally: lead);
  }
}
