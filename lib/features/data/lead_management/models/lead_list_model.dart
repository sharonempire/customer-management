import 'dart:convert';

class LeadModel {
  final String id;
  final String leadName;
  final String freelancerManager;
  final String freelancer;
  final String source;
  final String phone;
  final String status;
  final String followUpDate;
  final String remark;
  final String assignedStaff;

  const LeadModel({
    required this.id,
    required this.leadName,
    required this.freelancerManager,
    required this.freelancer,
    required this.source,
    required this.phone,
    required this.status,
    required this.followUpDate,
    required this.remark,
    required this.assignedStaff,
  });

  /// CopyWith method for immutability
  LeadModel copyWith({
    String? id,
    String? leadName,
    String? freelancerManager,
    String? freelancer,
    String? source,
    String? phone,
    String? status,
    String? followUpDate,
    String? remark,
    String? assignedStaff,
  }) {
    return LeadModel(
      id: id ?? this.id,
      leadName: leadName ?? this.leadName,
      freelancerManager: freelancerManager ?? this.freelancerManager,
      freelancer: freelancer ?? this.freelancer,
      source: source ?? this.source,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      followUpDate: followUpDate ?? this.followUpDate,
      remark: remark ?? this.remark,
      assignedStaff: assignedStaff ?? this.assignedStaff,
    );
  }

  /// Convert JSON → LeadModel
  factory LeadModel.fromJson(Map<String, dynamic> json) {
    return LeadModel(
      id: json['id'] ?? '',
      leadName: json['leadName'] ?? '',
      freelancerManager: json['freelancerManager'] ?? '',
      freelancer: json['freelancer'] ?? '',
      source: json['source'] ?? '',
      phone: json['phone'] ?? '',
      status: json['status'] ?? '',
      followUpDate: json['followUpDate'] ?? '',
      remark: json['remark'] ?? '',
      assignedStaff: json['assignedStaff'] ?? '',
    );
  }

  /// Convert LeadModel → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'leadName': leadName,
      'freelancerManager': freelancerManager,
      'freelancer': freelancer,
      'source': source,
      'phone': phone,
      'status': status,
      'followUpDate': followUpDate,
      'remark': remark,
      'assignedStaff': assignedStaff,
    };
  }

  /// For debugging and printing
  @override
  String toString() => jsonEncode(toJson());
}
