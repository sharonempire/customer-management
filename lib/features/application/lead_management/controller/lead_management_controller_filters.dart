part of 'lead_management_controller.dart';

mixin LeadControllerFilterMixin on LeadControllerBase {
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

  List<LeadsListModel> currentFollowUps({LeadDateFilter? filter}) {
    final LeadDateFilter selectedFilter =
        filter ?? ref.read(leadDateFilterProvider);
    final filteredLeads = _applyCommonFilters(state.leadsList);

    final normalizedStart = _normalizeDate(selectedFilter.start);
    final normalizedEnd = _normalizeDate(
      selectedFilter.end ?? selectedFilter.start,
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
        if (logs.isNotEmpty) {
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

  List<DraftLead> draftLeads({LeadDateFilter? filter}) {
    final LeadDateFilter selectedFilter =
        filter ?? ref.read(leadDateFilterProvider);
    final filteredLeads = _applyCommonFilters(state.leadsList);

    final normalizedStart = _normalizeDate(selectedFilter.start);
    final normalizedEnd = _normalizeDate(
      selectedFilter.end ?? selectedFilter.start,
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
}
