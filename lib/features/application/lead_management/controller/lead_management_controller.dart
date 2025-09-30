import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/authentification/controller/auth_controller.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/application/lead_management/model/lead_management_dto.dart';
import 'package:management_software/features/data/lead_management/models/call_event_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/data/lead_management/repositories/lead_management_repo.dart';
import 'package:management_software/features/data/lead_management/services/voxbay_call_service.dart';
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
      final repository = LeadManagementRepo(
        ref.watch(networkServiceProvider),
        ref.watch(voxbayCallServiceProvider),
      );
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
  Timer? _callEventsReconnectTimer;
  bool _callEventsReconnectEnabled = false;
  Timer? _callEventsPollingTimer;
  final Set<int> _reportedCallEventIds = <int>{};
  final Set<String> _reportedCallEventUuids = <String>{};
  final Set<String> _reportedCallEventFingerprints = <String>{};

  static const int _maxRealtimeCallEventsStored = 500;
  static const int _callEventsFetchLimit = _maxRealtimeCallEventsStored * 2;

  bool get isSubscribedToCallEvents => _callEventsChannel != null;

  List<LeadCallLog> get realtimeCallLogs => state.callEvents
      .map((event) => event.toLeadCallLog())
      .toList(growable: false);

  int get realtimeCallCount => state.callEvents.length;

  void _replaceCallEvents(List<CallEventModel> events) {
    if (events.isEmpty) {
      if (state.callEvents.isEmpty) return;
      state = state.copyWith(callEvents: const <CallEventModel>[]);
      return;
    }

    final sorted = List<CallEventModel>.from(events)..sort((a, b) {
      final aDate = a.createdAt;
      final bDate = b.createdAt;
      if (aDate == null && bDate == null) return 0;
      if (aDate == null) return 1;
      if (bDate == null) return -1;
      return bDate.compareTo(aDate);
    });

    final seenIds = <int>{};
    final seenUuids = <String>{};
    final deduped = <CallEventModel>[];

    for (final event in sorted) {
      var skip = false;

      final id = event.id;
      if (id != null && !seenIds.add(id)) {
        skip = true;
      }

      if (!skip) {
        final uuid = event.callUuid?.trim();
        if (uuid != null && uuid.isNotEmpty && !seenUuids.add(uuid)) {
          skip = true;
        }
      }

      if (skip) continue;

      deduped.add(event);
      if (deduped.length >= _maxRealtimeCallEventsStored) {
        break;
      }
    }

    if (deduped.isEmpty) {
      if (state.callEvents.isEmpty) return;
      state = state.copyWith(callEvents: const <CallEventModel>[]);
      return;
    }

    state = state.copyWith(
      callEvents: List<CallEventModel>.unmodifiable(deduped),
    );
  }

  void _upsertCallEvent(CallEventModel event) {
    final isDuplicate = state.callEvents.any(
      (existing) => _callEventsEqual(existing, event),
    );

    final combined = <CallEventModel>[event, ...state.callEvents];
    _replaceCallEvents(combined);

    if (!isDuplicate) {
      _handleCallEventForCdr(event);
    }
  }

  bool _callEventsEqual(CallEventModel a, CallEventModel b) {
    final aId = a.id;
    final bId = b.id;
    if (aId != null && bId != null && aId == bId) {
      return true;
    }

    final aUuid = a.callUuid?.trim();
    final bUuid = b.callUuid?.trim();
    if (aUuid != null && aUuid.isNotEmpty && bUuid != null && bUuid.isNotEmpty) {
      return aUuid == bUuid;
    }

    return false;
  }

  void _handleCallEventForCdr(CallEventModel event) {
    if (!_shouldSendCdr(event)) return;
    if (!_markCallEventReported(event)) return;

    final extension = _digitsOnly(
      event.agentNumber ?? event.extension ?? event.callerNumber,
    );
    final destination = _digitsOnly(
      event.calledNumber ?? event.destination ?? event.callerNumber,
    );
    if (extension.isEmpty || destination.isEmpty) {
      return;
    }

    final candidateCallerId = _digitsOnly(event.callerId);
    final callerId = candidateCallerId.isNotEmpty
        ? candidateCallerId
        : ref.read(voxbayCallServiceProvider).config.defaultCallerId;

    final duration = event.totalDuration ?? event.conversationDuration;
    final status = (event.callStatus?.isNotEmpty ?? false)
        ? event.callStatus!
        : event.eventType;
    final date = event.callDate ??
        event.callEndTime?.toIso8601String() ??
        event.callStartTime?.toIso8601String() ??
        event.createdAt?.toIso8601String();

    unawaited(() async {
      try {
        final result = await _leadManagementRepo.pushCallCdr(
          extension: extension,
          destination: destination,
          callerId: callerId,
          durationSeconds: duration?.toString(),
          status: status,
          dateTime: date,
          recordingUrl: event.recordingUrl,
        );

        if (!result.success) {
          log('Call CDR push failed: ${result.message}');
        }
      } catch (error, stackTrace) {
        log('Call CDR push error: $error', stackTrace: stackTrace);
      }
    }());
  }

  bool _shouldSendCdr(CallEventModel event) {
    final status = event.callStatus?.toLowerCase();
    const completedStatuses = <String>{
      'completed',
      'complete',
      'hangup',
      'hungup',
      'answered',
      'no-answer',
      'busy',
      'failed',
      'disconnected',
    };

    if (status != null && completedStatuses.contains(status)) {
      return true;
    }

    final eventType = event.eventType.toLowerCase();
    if (eventType.contains('cdr') || eventType.contains('hangup')) {
      return true;
    }

    if (event.callEndTime != null) return true;
    if ((event.totalDuration ?? 0) > 0) return true;
    if ((event.recordingUrl ?? '').isNotEmpty) return true;

    return false;
  }

  bool _markCallEventReported(CallEventModel event) {
    final id = event.id;
    if (id != null && !_reportedCallEventIds.add(id)) {
      return false;
    }

    final uuid = event.callUuid?.trim();
    if (uuid != null && uuid.isNotEmpty && !_reportedCallEventUuids.add(uuid)) {
      return false;
    }

    if (id == null && (uuid == null || uuid.isEmpty)) {
      final fingerprint = <String?>[
        _digitsOnly(event.agentNumber ?? event.extension ?? event.callerNumber),
        _digitsOnly(event.calledNumber ?? event.destination ?? event.callerNumber),
        event.callStartTime?.toIso8601String(),
        event.callEndTime?.toIso8601String(),
      ].whereType<String>().join('|');

      if (fingerprint.isNotEmpty &&
          !_reportedCallEventFingerprints.add(fingerprint)) {
        return false;
      }
    }

    return true;
  }

  String _digitsOnly(String? value) {
    if (value == null) return '';
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    return digits;
  }

  void _removeCallEvent(CallEventModel event) {
    final current = state.callEvents;
    if (current.isEmpty) return;

    final updated = current
        .where((existing) {
          final matchesId =
              event.id != null &&
              existing.id != null &&
              existing.id == event.id;
          final matchesUuid =
              event.callUuid != null &&
              existing.callUuid != null &&
              existing.callUuid == event.callUuid;
          return !(matchesId || matchesUuid);
        })
        .toList(growable: false);

    if (updated.length == current.length) return;
    _replaceCallEvents(updated);
  }

  Future<void> loadRecentCallEvents({int limit = _callEventsFetchLimit}) async {
    try {
      final targetLimit = limit.clamp(1, _callEventsFetchLimit);
      final events = await _leadManagementRepo.fetchRecentCallEvents(
        limit: targetLimit,
      );

      if (events.isEmpty) {
        _replaceCallEvents(const <CallEventModel>[]);
        return;
      }

      log('Loaded ${events.length} recent call events.');

      _replaceCallEvents(events);
    } catch (error, stackTrace) {
      log('Load call events error: $error', stackTrace: stackTrace);
    }
  }

  void _cancelCallEventsReconnect() {
    if (kIsWeb) {
      final timer = _callEventsPollingTimer;
      if (timer != null) {
        timer.cancel();
        _callEventsPollingTimer = null;
      }
      return;
    }
    final timer = _callEventsReconnectTimer;
    if (timer != null) {
      timer.cancel();
      _callEventsReconnectTimer = null;
    }
  }

  void _scheduleCallEventsReconnect() {
    if (kIsWeb) {
      _callEventsPollingTimer ??=
          Timer.periodic(const Duration(seconds: 6), (timer) {
        if (!_callEventsReconnectEnabled) return;
        unawaited(loadRecentCallEvents(limit: _maxRealtimeCallEventsStored));
      });
      return;
    }
    if (!_callEventsReconnectEnabled || _callEventsChannel != null) return;

    _cancelCallEventsReconnect();
    _callEventsReconnectTimer = Timer(const Duration(seconds: 3), () {
      if (!_callEventsReconnectEnabled || _callEventsChannel != null) return;
      subscribeToCallEvents();
    });
  }

  void subscribeToCallEvents() {
    _callEventsReconnectEnabled = true;
    if (kIsWeb) {
      _cancelCallEventsReconnect();
      unawaited(loadRecentCallEvents());
      _scheduleCallEventsReconnect();
      return;
    }
    if (_callEventsChannel != null) return;

    _cancelCallEventsReconnect();

    unawaited(loadRecentCallEvents());

    late final RealtimeChannel channel;
    channel = _leadManagementRepo.subscribeToCallEvents(
      onInsert: _upsertCallEvent,
      onUpdate: _upsertCallEvent,
      onDelete: _removeCallEvent,
      onStatus: (status, error) {
        switch (status) {
          case RealtimeSubscribeStatus.subscribed:
            log('Call events realtime subscribed.');
            break;
          case RealtimeSubscribeStatus.closed:
            log('Call events realtime channel closed.');
            if (_callEventsChannel != null &&
                identical(_callEventsChannel, channel)) {
              _callEventsChannel = null;
            }
            unawaited(_leadManagementRepo.removeRealtimeChannel(channel));
            unawaited(loadRecentCallEvents());
            _scheduleCallEventsReconnect();
            break;
          case RealtimeSubscribeStatus.channelError:
            log('Call events realtime channel error: $error');
            if (_callEventsChannel != null &&
                identical(_callEventsChannel, channel)) {
              _callEventsChannel = null;
            }
            unawaited(_leadManagementRepo.removeRealtimeChannel(channel));
            unawaited(loadRecentCallEvents());
            _scheduleCallEventsReconnect();
            break;
          case RealtimeSubscribeStatus.timedOut:
            log('Call events realtime channel timed out.');
            unawaited(loadRecentCallEvents());
            _scheduleCallEventsReconnect();
            break;
        }
      },
    );

    _callEventsChannel = channel;
  }

  Future<void> unsubscribeFromCallEvents() async {
    _callEventsReconnectEnabled = false;
    _cancelCallEventsReconnect();

    if (kIsWeb) {
      return;
    }

    final channel = _callEventsChannel;
    if (channel == null) return;
    _callEventsChannel = null;

    await _leadManagementRepo.removeRealtimeChannel(channel);
  }

  @override
  void dispose() {
    _callEventsReconnectEnabled = false;
    _cancelCallEventsReconnect();
    unawaited(unsubscribeFromCallEvents());
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
