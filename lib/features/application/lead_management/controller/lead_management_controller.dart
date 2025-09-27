import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:management_software/features/application/authentification/controller/auth_controller.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/application/lead_management/model/lead_management_dto.dart';
import 'package:management_software/features/data/lead_management/models/call_event_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/data/lead_management/repositories/lead_management_repo.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'lead_management_controller_filters.dart';
part 'lead_management_controller_info.dart';
part 'lead_management_controller_history.dart';
part 'lead_management_controller_workflow.dart';

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

abstract class LeadControllerBase extends StateNotifier<LeadManagementDTO> {
  LeadControllerBase(this.ref, this._leadManagementRepo)
    : super(const LeadManagementDTO());

  final LeadManagementRepo _leadManagementRepo;
  final Ref ref;
  List<LeadsListModel> _allLeadsCache = const [];
  Map<int, List<LeadCallLog>> _callLogsByLeadId = <int, List<LeadCallLog>>{};
  RealtimeChannel? _callEventsChannel;

  static const int _maxRealtimeCallEventsStored = 100;

  bool get isSubscribedToCallEvents => _callEventsChannel != null;

  List<LeadCallLog> get realtimeCallLogs => state.callEvents
      .map((event) => event.toLeadCallLog())
      .toList(growable: false);

  int get realtimeCallCount => state.callEvents.length;

  Future<void> loadRecentCallEvents({int limit = 50}) async {
    final events = await _leadManagementRepo.fetchRecentCallEvents(
      limit: limit.clamp(1, _maxRealtimeCallEventsStored),
    );

    if (events.isEmpty) return;

    final trimmed =
        events.length > _maxRealtimeCallEventsStored
            ? events.sublist(0, _maxRealtimeCallEventsStored)
            : events;

    log('Loaded ${trimmed.length} recent call events.');

    state = state.copyWith(
      callEvents: List<CallEventModel>.unmodifiable(trimmed),
    );
  }

  void subscribeToCallEvents({PostgresChangeFilter? filter}) {
    if (_callEventsChannel != null) return;

    unawaited(loadRecentCallEvents());

    _callEventsChannel = _leadManagementRepo.subscribeToCallEvents(
      filter: filter,
      onInsert:
          (payload) => _upsertCallEvent(
            payload.newRecord,
            fallbackOld: payload.oldRecord,
          ),
      onUpdate:
          (payload) => _upsertCallEvent(
            payload.newRecord,
            fallbackOld: payload.oldRecord,
          ),
      onDelete: (payload) => _removeCallEvent(payload.oldRecord),
    );
  }

  Future<void> unsubscribeFromCallEvents() async {
    final channel = _callEventsChannel;
    if (channel == null) return;
    _callEventsChannel = null;
    try {
      await channel.unsubscribe();
    } catch (error, stackTrace) {
      log('Call events unsubscribe error: $error', stackTrace: stackTrace);
    }
  }

  void _upsertCallEvent(
    Map<String, dynamic>? rawRecord, {
    Map<String, dynamic>? fallbackOld,
  }) {
    final record = rawRecord ?? fallbackOld;
    if (record == null || record.isEmpty) return;

    try {
      final event = CallEventModel.fromJson(Map<String, dynamic>.from(record));
      final int? id = event.id;
      final updated = <CallEventModel>[event];

      if (id != null) {
        updated.addAll(state.callEvents.where((existing) => existing.id != id));
      } else {
        updated.addAll(state.callEvents);
      }

      if (updated.length > _maxRealtimeCallEventsStored) {
        updated.removeRange(_maxRealtimeCallEventsStored, updated.length);
      }

      state = state.copyWith(
        callEvents: List<CallEventModel>.unmodifiable(updated),
      );
    } catch (error, stackTrace) {
      log('Call event parse error: $error', stackTrace: stackTrace);
    }
  }

  void _removeCallEvent(Map<String, dynamic>? rawRecord) {
    if (rawRecord == null || rawRecord.isEmpty) return;
    final int? id = _parseRecordId(rawRecord);
    if (id == null) return;

    final updated = state.callEvents
        .where((event) => event.id != id)
        .toList(growable: false);
    state = state.copyWith(
      callEvents: List<CallEventModel>.unmodifiable(updated),
    );
  }

  int? _parseRecordId(Map<String, dynamic> record) {
    final dynamic value = record['id'];
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  @override
  void dispose() {
    final channel = _callEventsChannel;
    if (channel != null) {
      unawaited(channel.unsubscribe());
      _callEventsChannel = null;
    }
    super.dispose();
  }
}

class LeadController extends LeadControllerBase
    with
        LeadControllerFilterMixin,
        LeadControllerInfoMixin,
        LeadControllerHistoryMixin,
        LeadControllerWorkflowMixin {
  LeadController(Ref ref, LeadManagementRepo leadManagementRepo)
    : super(ref, leadManagementRepo);
}
