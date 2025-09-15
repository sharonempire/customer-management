import 'dart:convert';

class LeadsListModel {
  final int? id;
  final DateTime? createdAt;
  final String? name;
  final String? email;
  final int? phone;
  final String? freelancerManager;
  final String? freelancer;
  final String? source;
  final String? status;
  final String? followUp;
  final String? remark;
  final String? assignedTo; // UUID as String
  final String? draftStatus;
  final String? date;

  const LeadsListModel({
    this.id,
    this.createdAt,
    this.name,
    this.email,
    this.phone,
    this.freelancerManager,
    this.freelancer,
    this.source,
    this.status,
    this.followUp,
    this.remark,
    this.assignedTo,
    this.draftStatus,
    this.date,
  });

  /// CopyWith for immutability
  LeadsListModel copyWith({
    int? id,
    DateTime? createdAt,
    String? name,
    String? email,
    int? phone,
    String? freelancerManager,
    String? freelancer,
    String? source,
    String? status,
    String? followUp,
    String? remark,
    String? assignedTo,
    String? draftStatus,
    String? date,
  }) {
    return LeadsListModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      freelancerManager: freelancerManager ?? this.freelancerManager,
      freelancer: freelancer ?? this.freelancer,
      source: source ?? this.source,
      status: status ?? this.status,
      followUp: followUp ?? this.followUp,
      remark: remark ?? this.remark,
      assignedTo: assignedTo ?? this.assignedTo,
      draftStatus: draftStatus ?? this.draftStatus,
      date: date ?? this.date,
    );
  }

  /// JSON → LeadsListModel
  factory LeadsListModel.fromJson(Map<String, dynamic> json) {
    return LeadsListModel(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] is int
          ? json['phone']
          : int.tryParse(json['phone']?.toString() ?? ''),
      freelancerManager: json['freelancer_manager'] as String?,
      freelancer: json['freelancer'] as String?,
      source: json['source'] as String?,
      status: json['status'] as String?,
      followUp: json['follow_up'] as String?,
      remark: json['remark'] as String?,
      assignedTo: json['assigned_to']?.toString(),
      draftStatus: json['draft_status'] as String?,
      date: json['date'] as String?,
    );
  }

  /// LeadsListModel → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'name': name,
      'email': email,
      'phone': phone,
      'freelancer_manager': freelancerManager,
      'freelancer': freelancer,
      'source': source,
      'status': status,
      'follow_up': followUp,
      'remark': remark,
      'assigned_to': assignedTo,
      'draft_status': draftStatus,
      'date': date,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
