import 'package:management_software/features/application/authentification/model/user_profile_model.dart';

class AttendanceModel {
  final String? id;
  final DateTime? createdAt;
  final String? checkInAt;
  final String? checkOutAt;
  final String? attendanceStatus;
  final String? date;
  final String? employeeId;
  final UserProfileModel? profile; // ✅ Added for employee details

  AttendanceModel({
    this.id,
    this.createdAt,
    this.checkInAt,
    this.checkOutAt,
    this.attendanceStatus,
    this.date,
    this.employeeId,
    this.profile,
  });

  /// ✅ Convert Supabase JSON → Dart Object
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'] as String?,
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : null,
      checkInAt: json['checkinat'] as String?,
      checkOutAt: json['checkoutat'] as String?,
      attendanceStatus: json['attendance_status'] as String?,
      date: json['date'] as String?,
      employeeId: json['employee_id'] as String?,
      profile:
          json['profiles'] != null
              ? UserProfileModel.fromMap(json['profiles'])
              : null, // ✅ Nested profile
    );
  }

  /// ✅ Convert Dart Object → JSON for Supabase
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) data['id'] = id;
    if (createdAt != null) data['created_at'] = createdAt!.toIso8601String();
    if (checkInAt != null) data['checkinat'] = checkInAt;
    if (checkOutAt != null) data['checkoutat'] = checkOutAt;
    if (attendanceStatus != null) data['attendance_status'] = attendanceStatus;
    if (date != null) data['date'] = date;
    if (employeeId != null) data['employee_id'] = employeeId;

    return data;
  }

  /// ✅ Copy object with updated fields
  AttendanceModel copyWith({
    String? id,
    DateTime? createdAt,
    String? checkInAt,
    String? checkOutAt,
    String? attendanceStatus,
    String? date,
    String? employeeId,
    UserProfileModel? profile,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      checkInAt: checkInAt ?? this.checkInAt,
      checkOutAt: checkOutAt ?? this.checkOutAt,
      attendanceStatus: attendanceStatus ?? this.attendanceStatus,
      date: date ?? this.date,
      employeeId: employeeId ?? this.employeeId,
      profile: profile ?? this.profile,
    );
  }
}
