import 'dart:convert';

class LeadsListModel {
  final int? id;
  final int? slNo;
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
    this.slNo,
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
    int? slNo,
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
      slNo: slNo ?? this.slNo,
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
      slNo: json['sl_no'] as int?,
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

  /// LeadsListModel → JSON (skip nulls)
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (id != null) data['id'] = id;
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (slNo != null) data['sl_no'] = slNo;
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    if (freelancerManager != null) data['freelancer_manager'] = freelancerManager;
    if (freelancer != null) data['freelancer'] = freelancer;
    if (source != null) data['source'] = source;
    if (status != null) data['status'] = status;
    if (followUp != null) data['follow_up'] = followUp;
    if (remark != null) data['remark'] = remark;
    if (assignedTo != null) data['assigned_to'] = assignedTo;
    if (draftStatus != null) data['draft_status'] = draftStatus;
    if (date != null) data['date'] = date;

    return data;
  }

  @override
  String toString() => jsonEncode(toJson());
}
