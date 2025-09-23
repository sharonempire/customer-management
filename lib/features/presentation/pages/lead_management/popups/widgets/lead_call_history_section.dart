import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class LeadCallHistorySection extends StatelessWidget {
  final List<LeadCallLog> callLogs;

  const LeadCallHistorySection({super.key, required this.callLogs});

  @override
  Widget build(BuildContext context) {
    if (callLogs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Call History',
          style: myTextstyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: ColorConsts.secondaryColor,
          ),
        ),
        height10,
        Column(
          children: List.generate(
            callLogs.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == callLogs.length - 1 ? 0 : 12,
              ),
              child: _LeadCallHistoryTile(
                log: callLogs[index],
                index: index + 1,
              ),
            ),
          ),
        ),
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
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: chips,
            ),
          ],
          if (_isNotEmpty(log.recordingUrl)) ...[
            height10,
            _CallDetailRow(
              icon: Icons.mic_none_outlined,
              label: 'Recording URL',
              valueWidget: SelectableText(
                log.recordingUrl!,
                style: myTextstyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: ColorConsts.primaryColor,
                ),
              ),
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
      chips.add(
        _CallInfoChip(
          icon: icon,
          label: label,
          value: value!.trim(),
        ),
      );
    }

    addChip(Icons.call_received_outlined, 'Caller', log.callerNumber);
    addChip(Icons.call_made_outlined, 'Dialled', log.calledNumber);
    addChip(Icons.headset_mic_outlined, 'Agent', log.agentNumber);
    addChip(Icons.badge_outlined, 'Caller ID', log.callerId);

    if (totalDurationLabel != null) {
      addChip(Icons.timer_outlined, 'Total', totalDurationLabel);
    }

    if (conversationDurationLabel != null) {
      addChip(Icons.record_voice_over_outlined, 'Conversation',
          conversationDurationLabel);
    }

    return chips;
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

    final display = valueWidget ??
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
  final sameDay = localStart.year == localEnd.year &&
      localStart.month == localEnd.month &&
      localStart.day == localEnd.day;
  final endFormatter = sameDay
      ? DateFormat('h:mm a')
      : DateFormat('MMM d, yyyy • h:mm a');
  final endText = endFormatter.format(localEnd);
  return '$startText – $endText';
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
    endTime: DateTime.now().subtract(const Duration(days: 1, hours: 1, minutes: 45)),
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
