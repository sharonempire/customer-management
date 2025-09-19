// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttendanceDTO {

 AttendanceModel? get userAttendance; List<AttendanceModel>? get allEmployeesAttendance; List<AttendanceModel>? get employeeHistory;
/// Create a copy of AttendanceDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceDTOCopyWith<AttendanceDTO> get copyWith => _$AttendanceDTOCopyWithImpl<AttendanceDTO>(this as AttendanceDTO, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceDTO&&(identical(other.userAttendance, userAttendance) || other.userAttendance == userAttendance)&&const DeepCollectionEquality().equals(other.allEmployeesAttendance, allEmployeesAttendance)&&const DeepCollectionEquality().equals(other.employeeHistory, employeeHistory));
}


@override
int get hashCode => Object.hash(runtimeType,userAttendance,const DeepCollectionEquality().hash(allEmployeesAttendance),const DeepCollectionEquality().hash(employeeHistory));

@override
String toString() {
  return 'AttendanceDTO(userAttendance: $userAttendance, allEmployeesAttendance: $allEmployeesAttendance, employeeHistory: $employeeHistory)';
}


}

/// @nodoc
abstract mixin class $AttendanceDTOCopyWith<$Res>  {
  factory $AttendanceDTOCopyWith(AttendanceDTO value, $Res Function(AttendanceDTO) _then) = _$AttendanceDTOCopyWithImpl;
@useResult
$Res call({
 AttendanceModel? userAttendance, List<AttendanceModel>? allEmployeesAttendance, List<AttendanceModel>? employeeHistory
});




}
/// @nodoc
class _$AttendanceDTOCopyWithImpl<$Res>
    implements $AttendanceDTOCopyWith<$Res> {
  _$AttendanceDTOCopyWithImpl(this._self, this._then);

  final AttendanceDTO _self;
  final $Res Function(AttendanceDTO) _then;

/// Create a copy of AttendanceDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userAttendance = freezed,Object? allEmployeesAttendance = freezed,Object? employeeHistory = freezed,}) {
  return _then(_self.copyWith(
userAttendance: freezed == userAttendance ? _self.userAttendance : userAttendance // ignore: cast_nullable_to_non_nullable
as AttendanceModel?,allEmployeesAttendance: freezed == allEmployeesAttendance ? _self.allEmployeesAttendance : allEmployeesAttendance // ignore: cast_nullable_to_non_nullable
as List<AttendanceModel>?,employeeHistory: freezed == employeeHistory ? _self.employeeHistory : employeeHistory // ignore: cast_nullable_to_non_nullable
as List<AttendanceModel>?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceDTO].
extension AttendanceDTOPatterns on AttendanceDTO {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceDTO() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceDTO value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceDTO():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceDTO value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceDTO() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AttendanceModel? userAttendance,  List<AttendanceModel>? allEmployeesAttendance,  List<AttendanceModel>? employeeHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceDTO() when $default != null:
return $default(_that.userAttendance,_that.allEmployeesAttendance,_that.employeeHistory);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AttendanceModel? userAttendance,  List<AttendanceModel>? allEmployeesAttendance,  List<AttendanceModel>? employeeHistory)  $default,) {final _that = this;
switch (_that) {
case _AttendanceDTO():
return $default(_that.userAttendance,_that.allEmployeesAttendance,_that.employeeHistory);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AttendanceModel? userAttendance,  List<AttendanceModel>? allEmployeesAttendance,  List<AttendanceModel>? employeeHistory)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceDTO() when $default != null:
return $default(_that.userAttendance,_that.allEmployeesAttendance,_that.employeeHistory);case _:
  return null;

}
}

}

/// @nodoc


class _AttendanceDTO extends AttendanceDTO {
  const _AttendanceDTO({this.userAttendance, final  List<AttendanceModel>? allEmployeesAttendance, final  List<AttendanceModel>? employeeHistory}): _allEmployeesAttendance = allEmployeesAttendance,_employeeHistory = employeeHistory,super._();
  

@override final  AttendanceModel? userAttendance;
 final  List<AttendanceModel>? _allEmployeesAttendance;
@override List<AttendanceModel>? get allEmployeesAttendance {
  final value = _allEmployeesAttendance;
  if (value == null) return null;
  if (_allEmployeesAttendance is EqualUnmodifiableListView) return _allEmployeesAttendance;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AttendanceModel>? _employeeHistory;
@override List<AttendanceModel>? get employeeHistory {
  final value = _employeeHistory;
  if (value == null) return null;
  if (_employeeHistory is EqualUnmodifiableListView) return _employeeHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AttendanceDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceDTOCopyWith<_AttendanceDTO> get copyWith => __$AttendanceDTOCopyWithImpl<_AttendanceDTO>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceDTO&&(identical(other.userAttendance, userAttendance) || other.userAttendance == userAttendance)&&const DeepCollectionEquality().equals(other._allEmployeesAttendance, _allEmployeesAttendance)&&const DeepCollectionEquality().equals(other._employeeHistory, _employeeHistory));
}


@override
int get hashCode => Object.hash(runtimeType,userAttendance,const DeepCollectionEquality().hash(_allEmployeesAttendance),const DeepCollectionEquality().hash(_employeeHistory));

@override
String toString() {
  return 'AttendanceDTO(userAttendance: $userAttendance, allEmployeesAttendance: $allEmployeesAttendance, employeeHistory: $employeeHistory)';
}


}

/// @nodoc
abstract mixin class _$AttendanceDTOCopyWith<$Res> implements $AttendanceDTOCopyWith<$Res> {
  factory _$AttendanceDTOCopyWith(_AttendanceDTO value, $Res Function(_AttendanceDTO) _then) = __$AttendanceDTOCopyWithImpl;
@override @useResult
$Res call({
 AttendanceModel? userAttendance, List<AttendanceModel>? allEmployeesAttendance, List<AttendanceModel>? employeeHistory
});




}
/// @nodoc
class __$AttendanceDTOCopyWithImpl<$Res>
    implements _$AttendanceDTOCopyWith<$Res> {
  __$AttendanceDTOCopyWithImpl(this._self, this._then);

  final _AttendanceDTO _self;
  final $Res Function(_AttendanceDTO) _then;

/// Create a copy of AttendanceDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userAttendance = freezed,Object? allEmployeesAttendance = freezed,Object? employeeHistory = freezed,}) {
  return _then(_AttendanceDTO(
userAttendance: freezed == userAttendance ? _self.userAttendance : userAttendance // ignore: cast_nullable_to_non_nullable
as AttendanceModel?,allEmployeesAttendance: freezed == allEmployeesAttendance ? _self._allEmployeesAttendance : allEmployeesAttendance // ignore: cast_nullable_to_non_nullable
as List<AttendanceModel>?,employeeHistory: freezed == employeeHistory ? _self._employeeHistory : employeeHistory // ignore: cast_nullable_to_non_nullable
as List<AttendanceModel>?,
  ));
}


}

// dart format on
