import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:management_software/features/data/attendance/model/attendance_model.dart';

part 'attendance_dto.freezed.dart';

@freezed
class AttendanceDTO with _$AttendanceDTO {
  // ✅ Private constructor for adding custom methods later
  const AttendanceDTO._();

  const factory AttendanceDTO({
    AttendanceModel? userAttendance,
    List<AttendanceModel>? allEmployeesAttendance,
    List<AttendanceModel>? employeeHistory,
  }) = _AttendanceDTO;
  
  @override
  // TODO: implement allEmployeesAttendance
  List<AttendanceModel>? get allEmployeesAttendance => throw UnimplementedError();
  
  @override
  // TODO: implement employeeHistory
  List<AttendanceModel>? get employeeHistory => throw UnimplementedError();
  
  @override
  // TODO: implement userAttendance
  AttendanceModel? get userAttendance => throw UnimplementedError();

  
     
}
