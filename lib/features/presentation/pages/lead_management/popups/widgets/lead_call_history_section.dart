import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:intl/intl.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class LeadCallHistorySection extends StatelessWidget {
  final List<LeadCallLog> callLogs;
  final List<LeadStatusChangeLog> statusChanges;

  const LeadCallHistorySection({
    super.key,
    required this.callLogs,
    this.statusChanges = const <LeadStatusChangeLog>[],
  });

  @override
  Widget build(BuildContext context) {
    if (callLogs.isEmpty && statusChanges.isEmpty) {
      return const SizedBox.shrink();
    }

    final entries = <_LeadHistoryEntry>[
      for (final log in callLogs) _LeadHistoryEntry.fromCall(log),
      for (final change in statusChanges) _LeadHistoryEntry.fromStatus(change),
    ]..sort((a, b) => _compareHistory(a.timestamp, b.timestamp));

    if (entries.isEmpty) {
      return const SizedBox.shrink();
    }

    int callCounter = 0;
    final children = <Widget>[];

    for (var index = 0; index < entries.length; index++) {
      final entry = entries[index];
      Widget tile;

      if (entry.isCall) {
        callCounter += 1;
        tile = _LeadCallHistoryTile(log: entry.call!, index: callCounter);
      } else {
        tile = _LeadStatusChangeTile(change: entry.statusChange!);
      }

      children.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: index == entries.length - 1 ? 0 : 12,
          ),
          child: tile,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lead History',
          style: myTextstyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ColorConsts.secondaryColor,
          ),
        ),
        height10,
        Column(children: children),
      ],
    );
  }
}

class _LeadCallHistoryTile extends StatelessWidget {
  final LeadCallLog log;
  final int index;

  const _LeadCallHistoryTile({required this.log, required this.index});

  @override
  Widget build(BuildContext context) {
    final callWindow = _formatCallWindow(log);
    final totalDurationLabel = _formatDuration(log.totalDurationSeconds);
    final conversationDurationLabel =
        (log.conversationDurationSeconds != null &&
                log.conversationDurationSeconds != log.totalDurationSeconds)
            ? _formatDuration(log.conversationDurationSeconds)
            : null;

    final chips = _buildInfoChips(
      log,
      totalDurationLabel: totalDurationLabel,
      conversationDurationLabel: conversationDurationLabel,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorConsts.greyContainer),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CallHeader(index: index, status: log.status),
          if (callWindow != null) ...[
            height10,
            _CallDetailRow(
              icon: Icons.schedule_outlined,
              label: 'Call Window',
              value: callWindow,
            ),
          ] else if (_isNotEmpty(log.callDateLabel)) ...[
            height10,
            _CallDetailRow(
              icon: Icons.schedule_outlined,
              label: 'Call Date',
              value: log.callDateLabel!.trim(),
            ),
          ],
          if (chips.isNotEmpty) ...[
            height10,
            Wrap(spacing: 12, runSpacing: 12, children: chips),
          ],
          if (_isNotEmpty(log.recordingUrl)) ...[
            height10,
            _CallDetailRow(
              icon: Icons.mic_none_outlined,
              label: 'Recording',
              valueWidget: _CallRecordingPlayer(url: log.recordingUrl!.trim()),
            ),
          ],
          if (_isNotEmpty(log.callUuid)) ...[
            height10,
            _CallDetailRow(
              icon: Icons.fingerprint,
              label: 'Call UUID',
              value: log.callUuid!.trim(),
            ),
          ],
          if (_isNotEmpty(log.dtmf)) ...[
            height10,
            _CallDetailRow(
              icon: Icons.dialpad,
              label: 'DTMF',
              value: log.dtmf!.trim(),
            ),
          ],
          if (_isNotEmpty(log.transferredNumber)) ...[
            height10,
            _CallDetailRow(
              icon: Icons.swap_calls_outlined,
              label: 'Transferred To',
              value: log.transferredNumber!.trim(),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildInfoChips(
    LeadCallLog log, {
    String? totalDurationLabel,
    String? conversationDurationLabel,
  }) {
    final chips = <Widget>[];

    void addChip(IconData icon, String label, String? value) {
      if (!_isNotEmpty(value)) return;
      chips.add(_CallInfoChip(icon: icon, label: label, value: value!.trim()));
    }

    addChip(Icons.call_received_outlined, 'Caller', log.callerNumber);
    addChip(Icons.call_made_outlined, 'Dialled', log.calledNumber);
    addChip(Icons.headset_mic_outlined, 'Agent', log.agentNumber);
    addChip(Icons.badge_outlined, 'Caller ID', log.callerId);

    if (totalDurationLabel != null) {
      addChip(Icons.timer_outlined, 'Total', totalDurationLabel);
    }

    if (conversationDurationLabel != null) {
      addChip(
        Icons.record_voice_over_outlined,
        'Conversation',
        conversationDurationLabel,
      );
    }

    return chips;
  }
}

class _LeadStatusChangeTile extends StatelessWidget {
  final LeadStatusChangeLog change;

  const _LeadStatusChangeTile({required this.change});

  @override
  Widget build(BuildContext context) {
    final newStatus = change.status?.trim();
    final previousStatus = change.previousStatus?.trim();
    final note = change.note?.trim();
    final mentorName = change.mentorName?.trim();
    final mentorId = change.mentorId?.trim();
    final mentorLabel = _isNotEmpty(mentorName) ? mentorName : mentorId;
    final statusFlow =
        _isNotEmpty(previousStatus) && _isNotEmpty(newStatus)
            ? '${previousStatus!.trim()} → ${newStatus!.trim()}'
            : null;
    final updatedAtText =
        change.changedAt != null
            ? DateFormat(
              'MMM d, yyyy • h:mm a',
            ).format(change.changedAt!.toLocal())
            : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorConsts.greyContainer),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Status Update',
                style: myTextstyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ColorConsts.textColor,
                ),
              ),
              const Spacer(),
              if (_isNotEmpty(newStatus))
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ColorConsts.primaryColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    newStatus!.toUpperCase(),
                    style: myTextstyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ColorConsts.primaryColor,
                    ),
                  ),
                ),
            ],
          ),
          if (_isNotEmpty(updatedAtText)) ...[
            height10,
            _CallDetailRow(
              icon: Icons.schedule_outlined,
              label: 'Updated At',
              value: updatedAtText!,
            ),
          ],
          if (_isNotEmpty(mentorLabel)) ...[
            height10,
            _CallDetailRow(
              icon: Icons.person_outline,
              label: 'Updated By',
              value: mentorLabel!,
            ),
          ],
          if (_isNotEmpty(statusFlow)) ...[
            height10,
            _CallDetailRow(
              icon: Icons.swap_horiz_outlined,
              label: 'Status Change',
              value: statusFlow!,
            ),
          ],
          if (_isNotEmpty(note)) ...[
            height10,
            _CallDetailRow(
              icon: Icons.sticky_note_2_outlined,
              label: 'Notes',
              value: note!,
            ),
          ],
        ],
      ),
    );
  }
}

class _CallHeader extends StatelessWidget {
  final int index;
  final String? status;

  const _CallHeader({required this.index, this.status});

  @override
  Widget build(BuildContext context) {
    final statusText = status?.trim();

    return Row(
      children: [
        Text(
          'Call ${index.toString().padLeft(2, '0')}',
          style: myTextstyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ColorConsts.textColor,
          ),
        ),
        const Spacer(),
        if (statusText != null && statusText.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor(statusText).withOpacity(0.12),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              statusText.toUpperCase(),
              style: myTextstyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: _statusColor(statusText),
              ),
            ),
          ),
      ],
    );
  }
}

class _CallInfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _CallInfoChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: ColorConsts.lightGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConsts.greyContainer),
      ),
      constraints: const BoxConstraints(minWidth: 140, maxWidth: 220),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: ColorConsts.secondaryColor),
              width5,
              Flexible(
                child: Text(
                  label,
                  style: myTextstyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ColorConsts.secondaryColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          height5,
          Text(
            value,
            style: myTextstyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorConsts.textColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _CallRecordingPlayer extends StatefulWidget {
  final String url;

  const _CallRecordingPlayer({required this.url});

  @override
  State<_CallRecordingPlayer> createState() => _CallRecordingPlayerState();
}

class _CallRecordingPlayerState extends State<_CallRecordingPlayer> {
  late final AudioPlayer _player;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  Duration _position = Duration.zero;
  Duration? _totalDuration;
  bool _initializing = true;
  bool _isBuffering = false;
  bool _isPlaying = false;
  bool _loadError = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _durationSub = _player.durationStream.listen((duration) {
      if (!mounted) return;
      setState(() => _totalDuration = duration);
    });
    _positionSub = _player.positionStream.listen((position) {
      if (!mounted) return;
      setState(() => _position = position);
    });
    _playerStateSub = _player.playerStateStream.listen((state) {
      final buffering =
          state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering;
      if (state.processingState == ProcessingState.completed) {
        unawaited(_player.seek(Duration.zero));
        unawaited(_player.pause());
      }
      if (!mounted) return;
      setState(() {
        _isBuffering = buffering;
        _isPlaying = state.playing && !buffering;
      });
    });
    _loadSource();
  }

  @override
  void didUpdateWidget(covariant _CallRecordingPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _resetState();
      _loadSource();
    }
  }

  void _resetState() {
    setState(() {
      _position = Duration.zero;
      _totalDuration = null;
      _initializing = true;
      _isBuffering = false;
      _isPlaying = false;
      _loadError = false;
    });
    unawaited(_player.stop());
  }

  Future<void> _loadSource() async {
    try {
      await _player.setUrl(widget.url);
      if (!mounted) return;
      setState(() => _initializing = false);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = true;
        _initializing = false;
      });
    }
  }

  @override
  void dispose() {
    _durationSub?.cancel();
    _positionSub?.cancel();
    _playerStateSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlayback() async {
    if (_loadError) {
      _resetState();
      await _loadSource();
      return;
    }

    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> _seekTo(double milliseconds) async {
    await _player.seek(Duration(milliseconds: milliseconds.round()));
  }

  @override
  Widget build(BuildContext context) {
    if (_loadError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.withOpacity(0.24)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.redAccent),
                width10,
                Expanded(
                  child: Text(
                    'Unable to load the recording. Tap retry to try again.',
                    style: myTextstyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: ColorConsts.textColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _resetState();
                    _loadSource();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          height10,
          SelectableText(
            widget.url,
            style: myTextstyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ColorConsts.primaryColor,
            ),
          ),
        ],
      );
    }

    final waiting = _initializing || _isBuffering;
    final totalMs = _totalDuration?.inMilliseconds ?? 0;
    final sliderMax = totalMs <= 0 ? 1.0 : totalMs.toDouble();
    final sliderValue =
        totalMs <= 0
            ? 0.0
            : _position.inMilliseconds.clamp(0, totalMs).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ColorConsts.lightGrey,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: ColorConsts.greyContainer),
          ),
          child: Row(
            children: [
              _buildControlButton(waiting),
              width10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Slider(
                      value: sliderValue,
                      min: 0,
                      max: sliderMax,
                      onChanged:
                          (waiting || totalMs <= 0)
                              ? null
                              : (value) => _seekTo(value),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatAudioPosition(_position),
                          style: myTextstyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorConsts.secondaryColor,
                          ),
                        ),
                        Text(
                          _formatAudioPosition(_totalDuration),
                          style: myTextstyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: ColorConsts.secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        height10,
        // SelectableText(
        //   widget.url,
        //   style: myTextstyle(
        //     fontSize: 12,
        //     fontWeight: FontWeight.w500,
        //     color: ColorConsts.primaryColor,
        //   ),
        // ),
      ],
    );
  }

  Widget _buildControlButton(bool waiting) {
    final background = ColorConsts.primaryColor.withOpacity(0.12);

    if (waiting) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(color: background, shape: BoxShape.circle),
        child: const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: background,
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: () {
            _togglePlayback();
          },
          icon: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: ColorConsts.primaryColor,
          ),
        ),
      ),
    );
  }
}

String _formatAudioPosition(Duration? duration) {
  if (duration == null) return '--:--';
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
  }
  return '$minutes:$seconds';
}

class _CallDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? valueWidget;

  const _CallDetailRow({
    required this.icon,
    required this.label,
    this.value,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    if ((_isNotEmpty(value) == false) && valueWidget == null) {
      return const SizedBox.shrink();
    }

    final display =
        valueWidget ??
        Text(
          value!.trim(),
          style: myTextstyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ColorConsts.textColor,
          ),
        );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: ColorConsts.secondaryColor),
        width10,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: myTextstyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: ColorConsts.secondaryColor,
                ),
              ),
              height5,
              display,
            ],
          ),
        ),
      ],
    );
  }
}

String? _formatCallWindow(LeadCallLog log) {
  final start = log.startTime ?? log.callDateTime;
  final end = log.endTime;
  if (start == null) return null;

  final localStart = start.toLocal();
  final startText = DateFormat('MMM d, yyyy • h:mm a').format(localStart);

  if (end == null) {
    return startText;
  }

  final localEnd = end.toLocal();
  final sameDay =
      localStart.year == localEnd.year &&
      localStart.month == localEnd.month &&
      localStart.day == localEnd.day;
  final endFormatter =
      sameDay ? DateFormat('h:mm a') : DateFormat('MMM d, yyyy • h:mm a');
  final endText = endFormatter.format(localEnd);
  return '$startText – $endText';
}

DateTime? _callTimestamp(LeadCallLog log) {
  return log.callDateTime ??
      log.endTime ??
      log.startTime ??
      DateTimeHelper.parseDate(log.callDateLabel);
}

int _compareHistory(DateTime? a, DateTime? b) {
  final left = a ?? DateTime.fromMillisecondsSinceEpoch(0);
  final right = b ?? DateTime.fromMillisecondsSinceEpoch(0);
  return right.compareTo(left);
}

class _LeadHistoryEntry {
  final bool isCall;
  final LeadCallLog? call;
  final LeadStatusChangeLog? statusChange;
  final DateTime? timestamp;

  const _LeadHistoryEntry._({
    required this.isCall,
    required this.timestamp,
    this.call,
    this.statusChange,
  });

  factory _LeadHistoryEntry.fromCall(LeadCallLog call) => _LeadHistoryEntry._(
    isCall: true,
    timestamp: _callTimestamp(call),
    call: call,
  );

  factory _LeadHistoryEntry.fromStatus(LeadStatusChangeLog change) =>
      _LeadHistoryEntry._(
        isCall: false,
        timestamp: change.changedAt,
        statusChange: change,
      );
}

String? _formatDuration(int? seconds) {
  if (seconds == null || seconds <= 0) return null;
  final duration = Duration(seconds: seconds);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final secs = duration.inSeconds.remainder(60);
  final parts = <String>[];
  if (hours > 0) parts.add('${hours}h');
  if (minutes > 0) parts.add('${minutes}m');
  if (secs > 0) parts.add('${secs}s');
  return parts.isEmpty ? '${seconds}s' : parts.join(' ');
}

Color _statusColor(String status) {
  final normalized = status.toUpperCase();
  switch (normalized) {
    case 'ANSWERED':
    case 'COMPLETED':
      return ColorConsts.activeColor;
    case 'NOANSWER':
    case 'NO ANSWER':
    case 'CANCEL':
    case 'FAILED':
      return Colors.orange;
    case 'BUSY':
    case 'CONGESTION':
    case 'CHANUNAVAIL':
      return Colors.redAccent;
    default:
      return ColorConsts.secondaryColor;
  }
}

bool _isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;

final sampleCallLogs = [
  LeadCallLog(
    callerNumber: '+91 98765 43210',
    calledNumber: '+91 91234 56789',
    agentNumber: '100',
    callerId: 'Main Line',
    status: 'ANSWERED',
    callUuid: 'abc-123-uuid',
    dtmf: '1,5',
    transferredNumber: '+91 90000 11111',
    callDateLabel: 'Monday, 23 Sept 2025',
    callDateTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    startTime: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    endTime: DateTime.now().subtract(
      const Duration(days: 1, hours: 1, minutes: 45),
    ),
    totalDurationSeconds: 900, // 15 minutes
    conversationDurationSeconds: 720, // 12 minutes
    recordingUrl: 'https://example.com/recordings/sample-call-1.mp3',
  ),
  LeadCallLog(
    callerNumber: '+91 99999 88888',
    calledNumber: '+91 91234 56789',
    agentNumber: '101',
    callerId: 'Support Desk',
    status: 'NOANSWER',
    callUuid: 'def-456-uuid',
    dtmf: null,
    transferredNumber: null,
    callDateLabel: 'Tuesday, 24 Sept 2025',
    callDateTime: DateTime.now().subtract(const Duration(hours: 3)),
    startTime: DateTime.now().subtract(const Duration(hours: 3)),
    endTime: DateTime.now().subtract(const Duration(hours: 2, minutes: 50)),
    totalDurationSeconds: 0, // not answered
    conversationDurationSeconds: 0,
    recordingUrl: null,
  ),
];
