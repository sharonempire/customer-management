// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceDTO _$AttendanceDTOFromJson(Map<String, dynamic> json) =>
    _AttendanceDTO(
      userAttendance:
          json['userAttendance'] == null
              ? null
              : AttendanceModel.fromJson(
                json['userAttendance'] as Map<String, dynamic>,
              ),
      allEmployeesAttendance:
          (json['allEmployeesAttendance'] as List<dynamic>?)
              ?.map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      employeeHistory:
          (json['employeeHistory'] as List<dynamic>?)
              ?.map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$AttendanceDTOToJson(_AttendanceDTO instance) =>
    <String, dynamic>{
      'userAttendance': instance.userAttendance,
      'allEmployeesAttendance': instance.allEmployeesAttendance,
      'employeeHistory': instance.employeeHistory,
    };
