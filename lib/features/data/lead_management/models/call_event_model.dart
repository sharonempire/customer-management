import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';

class CallEventModel {
  const CallEventModel({
    this.id,
    this.createdAt,
    required this.eventType,
    this.callUuid,
    this.callerNumber,
    this.calledNumber,
    this.agentNumber,
    this.callStatus,
    this.totalDuration,
    this.conversationDuration,
    this.callStartTime,
    this.callEndTime,
    this.recordingUrl,
    this.dtmf,
    this.transferredNumber,
    this.destination,
    this.callerId,
    this.callDate,
    this.extension,
  });

  final int? id;
  final DateTime? createdAt;
  final String eventType;
  final String? callUuid;
  final String? callerNumber;
  final String? calledNumber;
  final String? agentNumber;
  final String? callStatus;
  final int? totalDuration;
  final int? conversationDuration;
  final DateTime? callStartTime;
  final DateTime? callEndTime;
  final String? recordingUrl;
  final String? dtmf;
  final String? transferredNumber;
  final String? destination;
  final String? callerId;
  final String? callDate;
  final String? extension;

  factory CallEventModel.fromJson(Map<String, dynamic> json) {
    return CallEventModel(
      id: _parseInt(json['id']),
      createdAt: _parseDateTime(json['created_at']),
      eventType: _asString(json['event_type']) ?? 'unknown',
      callUuid: _asString(
        json['call_uuid'] ?? json['CallUUID'] ?? json['callUUlD'],
      ),
      callerNumber: _asString(json['caller_number'] ?? json['callerNumber']),
      calledNumber: _asString(json['called_number'] ?? json['calledNumber']),
      agentNumber: _asString(
        json['agent_number'] ?? json['AgentNumber'] ?? json['agentNumber'],
      ),
      callStatus: _asString(
        json['call_status'] ?? json['callStatus'] ?? json['status'],
      ),
      totalDuration: _parseInt(
        json['total_duration'] ?? json['totalCallDuration'] ?? json['duration'],
      ),
      conversationDuration: _parseInt(
        json['conversation_duration'] ?? json['conversationDuration'],
      ),
      callStartTime: _parseDateTime(
        json['call_start_time'] ?? json['callStartTime'],
      ),
      callEndTime: _parseDateTime(json['call_end_time'] ?? json['callEndTime']),
      recordingUrl: _asString(json['recording_url'] ?? json['recording_URL']),
      dtmf: _asString(json['dtmf']),
      transferredNumber: _asString(json['transferred_number']),
      destination: _asString(json['destination']),
      callerId: _asString(json['callerid'] ?? json['caller_id']),
      callDate: _asString(
        json['call_date'] ?? json['callDate'] ?? json['date'],
      ),
      extension: _asString(json['extension']),
    );
  }

  LeadCallLog toLeadCallLog() {
    final label = callDate ?? createdAt?.toIso8601String();
    return LeadCallLog(
      callUuid: callUuid,
      callerNumber: callerNumber,
      calledNumber: calledNumber,
      agentNumber: agentNumber,
      callerId: callerId,
      status: callStatus ?? eventType,
      startTime: callStartTime,
      endTime: callEndTime,
      callDateTime: callStartTime ?? createdAt,
      totalDurationSeconds: totalDuration,
      conversationDurationSeconds: conversationDuration,
      recordingUrl: recordingUrl,
      dtmf: dtmf,
      transferredNumber: transferredNumber,
      callDateLabel: label,
    );
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static String? _asString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    return value.toString();
  }
}
