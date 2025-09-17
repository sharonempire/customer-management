// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lead_management_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeadManagementDTO {

 List<LeadsListModel> get leadsList; LeadInfoModel? get selectedLead; LeadsListModel? get selectedLeadLocally;
/// Create a copy of LeadManagementDTO
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeadManagementDTOCopyWith<LeadManagementDTO> get copyWith => _$LeadManagementDTOCopyWithImpl<LeadManagementDTO>(this as LeadManagementDTO, _$identity);

  /// Serializes this LeadManagementDTO to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeadManagementDTO&&const DeepCollectionEquality().equals(other.leadsList, leadsList)&&(identical(other.selectedLead, selectedLead) || other.selectedLead == selectedLead)&&(identical(other.selectedLeadLocally, selectedLeadLocally) || other.selectedLeadLocally == selectedLeadLocally));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(leadsList),selectedLead,selectedLeadLocally);

@override
String toString() {
  return 'LeadManagementDTO(leadsList: $leadsList, selectedLead: $selectedLead, selectedLeadLocally: $selectedLeadLocally)';
}


}

/// @nodoc
abstract mixin class $LeadManagementDTOCopyWith<$Res>  {
  factory $LeadManagementDTOCopyWith(LeadManagementDTO value, $Res Function(LeadManagementDTO) _then) = _$LeadManagementDTOCopyWithImpl;
@useResult
$Res call({
 List<LeadsListModel> leadsList, LeadInfoModel? selectedLead, LeadsListModel? selectedLeadLocally
});




}
/// @nodoc
class _$LeadManagementDTOCopyWithImpl<$Res>
    implements $LeadManagementDTOCopyWith<$Res> {
  _$LeadManagementDTOCopyWithImpl(this._self, this._then);

  final LeadManagementDTO _self;
  final $Res Function(LeadManagementDTO) _then;

/// Create a copy of LeadManagementDTO
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leadsList = null,Object? selectedLead = freezed,Object? selectedLeadLocally = freezed,}) {
  return _then(_self.copyWith(
leadsList: null == leadsList ? _self.leadsList : leadsList // ignore: cast_nullable_to_non_nullable
as List<LeadsListModel>,selectedLead: freezed == selectedLead ? _self.selectedLead : selectedLead // ignore: cast_nullable_to_non_nullable
as LeadInfoModel?,selectedLeadLocally: freezed == selectedLeadLocally ? _self.selectedLeadLocally : selectedLeadLocally // ignore: cast_nullable_to_non_nullable
as LeadsListModel?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeadManagementDTO].
extension LeadManagementDTOPatterns on LeadManagementDTO {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeadManagementDTO value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeadManagementDTO() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeadManagementDTO value)  $default,){
final _that = this;
switch (_that) {
case _LeadManagementDTO():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeadManagementDTO value)?  $default,){
final _that = this;
switch (_that) {
case _LeadManagementDTO() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LeadsListModel> leadsList,  LeadInfoModel? selectedLead,  LeadsListModel? selectedLeadLocally)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeadManagementDTO() when $default != null:
return $default(_that.leadsList,_that.selectedLead,_that.selectedLeadLocally);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LeadsListModel> leadsList,  LeadInfoModel? selectedLead,  LeadsListModel? selectedLeadLocally)  $default,) {final _that = this;
switch (_that) {
case _LeadManagementDTO():
return $default(_that.leadsList,_that.selectedLead,_that.selectedLeadLocally);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LeadsListModel> leadsList,  LeadInfoModel? selectedLead,  LeadsListModel? selectedLeadLocally)?  $default,) {final _that = this;
switch (_that) {
case _LeadManagementDTO() when $default != null:
return $default(_that.leadsList,_that.selectedLead,_that.selectedLeadLocally);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeadManagementDTO extends LeadManagementDTO {
  const _LeadManagementDTO({final  List<LeadsListModel> leadsList = const [], this.selectedLead, this.selectedLeadLocally}): _leadsList = leadsList,super._();
  factory _LeadManagementDTO.fromJson(Map<String, dynamic> json) => _$LeadManagementDTOFromJson(json);

 final  List<LeadsListModel> _leadsList;
@override@JsonKey() List<LeadsListModel> get leadsList {
  if (_leadsList is EqualUnmodifiableListView) return _leadsList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_leadsList);
}

@override final  LeadInfoModel? selectedLead;
@override final  LeadsListModel? selectedLeadLocally;

/// Create a copy of LeadManagementDTO
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeadManagementDTOCopyWith<_LeadManagementDTO> get copyWith => __$LeadManagementDTOCopyWithImpl<_LeadManagementDTO>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeadManagementDTOToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeadManagementDTO&&const DeepCollectionEquality().equals(other._leadsList, _leadsList)&&(identical(other.selectedLead, selectedLead) || other.selectedLead == selectedLead)&&(identical(other.selectedLeadLocally, selectedLeadLocally) || other.selectedLeadLocally == selectedLeadLocally));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_leadsList),selectedLead,selectedLeadLocally);

@override
String toString() {
  return 'LeadManagementDTO(leadsList: $leadsList, selectedLead: $selectedLead, selectedLeadLocally: $selectedLeadLocally)';
}


}

/// @nodoc
abstract mixin class _$LeadManagementDTOCopyWith<$Res> implements $LeadManagementDTOCopyWith<$Res> {
  factory _$LeadManagementDTOCopyWith(_LeadManagementDTO value, $Res Function(_LeadManagementDTO) _then) = __$LeadManagementDTOCopyWithImpl;
@override @useResult
$Res call({
 List<LeadsListModel> leadsList, LeadInfoModel? selectedLead, LeadsListModel? selectedLeadLocally
});




}
/// @nodoc
class __$LeadManagementDTOCopyWithImpl<$Res>
    implements _$LeadManagementDTOCopyWith<$Res> {
  __$LeadManagementDTOCopyWithImpl(this._self, this._then);

  final _LeadManagementDTO _self;
  final $Res Function(_LeadManagementDTO) _then;

/// Create a copy of LeadManagementDTO
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leadsList = null,Object? selectedLead = freezed,Object? selectedLeadLocally = freezed,}) {
  return _then(_LeadManagementDTO(
leadsList: null == leadsList ? _self._leadsList : leadsList // ignore: cast_nullable_to_non_nullable
as List<LeadsListModel>,selectedLead: freezed == selectedLead ? _self.selectedLead : selectedLead // ignore: cast_nullable_to_non_nullable
as LeadInfoModel?,selectedLeadLocally: freezed == selectedLeadLocally ? _self.selectedLeadLocally : selectedLeadLocally // ignore: cast_nullable_to_non_nullable
as LeadsListModel?,
  ));
}


}

// dart format on
