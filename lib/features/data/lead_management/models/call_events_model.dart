class CallEvent {
  final int? id;
  final DateTime? createdAt;
  final String? eventType;
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

  CallEvent({
    this.id,
    this.createdAt,
    this.eventType,
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
  });

  factory CallEvent.fromJson(Map<String, dynamic> json) {
    return CallEvent(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      eventType: json['event_type'] as String?,
      callUuid: json['call_uuid'] as String?,
      callerNumber: json['caller_number'] as String?,
      calledNumber: json['called_number'] as String?,
      agentNumber: json['agent_number'] as String?,
      callStatus: json['call_status'] as String?,
      totalDuration: json['total_duration'] as int?,
      conversationDuration: json['conversation_duration'] as int?,
      callStartTime: json['call_start_time'] != null
          ? DateTime.tryParse(json['call_start_time'] as String)
          : null,
      callEndTime: json['call_end_time'] != null
          ? DateTime.tryParse(json['call_end_time'] as String)
          : null,
      recordingUrl: json['recording_url'] as String?,
      dtmf: json['dtmf'] as String?,
      transferredNumber: json['transferred_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'event_type': eventType,
      'call_uuid': callUuid,
      'caller_number': callerNumber,
      'called_number': calledNumber,
      'agent_number': agentNumber,
      'call_status': callStatus,
      'total_duration': totalDuration,
      'conversation_duration': conversationDuration,
      'call_start_time': callStartTime?.toIso8601String(),
      'call_end_time': callEndTime?.toIso8601String(),
      'recording_url': recordingUrl,
      'dtmf': dtmf,
      'transferred_number': transferredNumber,
    };
  }
}
