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
  Timer? _callEventsTimer;

  static const int _maxRealtimeCallEventsStored = 100;

  bool get isSubscribedToCallEvents => _callEventsTimer != null;

  List<LeadCallLog> get realtimeCallLogs => state.callEvents
      .map((event) => event.toLeadCallLog())
      .toList(growable: false);

  int get realtimeCallCount => state.callEvents.length;

  Future<void> loadRecentCallEvents({int limit = 50}) async {
    try {
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
    } catch (error, stackTrace) {
      log('Load call events error: $error', stackTrace: stackTrace);
    }
  }

  void subscribeToCallEvents() {
    if (_callEventsTimer != null) return;

    unawaited(loadRecentCallEvents());

    _callEventsTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(loadRecentCallEvents());
    });
  }

  Future<void> unsubscribeFromCallEvents() async {
    final timer = _callEventsTimer;
    if (timer == null) return;
    _callEventsTimer = null;
    timer.cancel();
  }

  @override
  void dispose() {
    final timer = _callEventsTimer;
    if (timer != null) {
      timer.cancel();
      _callEventsTimer = null;
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
