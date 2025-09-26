// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_finder_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CourseFinderState {

 String get query; CourseFinderStatus get status; List<CourseSummary> get results; List<CourseSummary> get featuredCourses; String? get selectedCategory; String? get selectedMode; String? get errorMessage;
/// Create a copy of CourseFinderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseFinderStateCopyWith<CourseFinderState> get copyWith => _$CourseFinderStateCopyWithImpl<CourseFinderState>(this as CourseFinderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseFinderState&&(identical(other.query, query) || other.query == query)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.results, results)&&const DeepCollectionEquality().equals(other.featuredCourses, featuredCourses)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.selectedMode, selectedMode) || other.selectedMode == selectedMode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,query,status,const DeepCollectionEquality().hash(results),const DeepCollectionEquality().hash(featuredCourses),selectedCategory,selectedMode,errorMessage);

@override
String toString() {
  return 'CourseFinderState(query: $query, status: $status, results: $results, featuredCourses: $featuredCourses, selectedCategory: $selectedCategory, selectedMode: $selectedMode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CourseFinderStateCopyWith<$Res>  {
  factory $CourseFinderStateCopyWith(CourseFinderState value, $Res Function(CourseFinderState) _then) = _$CourseFinderStateCopyWithImpl;
@useResult
$Res call({
 String query, CourseFinderStatus status, List<CourseSummary> results, List<CourseSummary> featuredCourses, String? selectedCategory, String? selectedMode, String? errorMessage
});




}
/// @nodoc
class _$CourseFinderStateCopyWithImpl<$Res>
    implements $CourseFinderStateCopyWith<$Res> {
  _$CourseFinderStateCopyWithImpl(this._self, this._then);

  final CourseFinderState _self;
  final $Res Function(CourseFinderState) _then;

/// Create a copy of CourseFinderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? status = null,Object? results = null,Object? featuredCourses = null,Object? selectedCategory = freezed,Object? selectedMode = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CourseFinderStatus,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<CourseSummary>,featuredCourses: null == featuredCourses ? _self.featuredCourses : featuredCourses // ignore: cast_nullable_to_non_nullable
as List<CourseSummary>,selectedCategory: freezed == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String?,selectedMode: freezed == selectedMode ? _self.selectedMode : selectedMode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseFinderState].
extension CourseFinderStatePatterns on CourseFinderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseFinderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseFinderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseFinderState value)  $default,){
final _that = this;
switch (_that) {
case _CourseFinderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseFinderState value)?  $default,){
final _that = this;
switch (_that) {
case _CourseFinderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  CourseFinderStatus status,  List<CourseSummary> results,  List<CourseSummary> featuredCourses,  String? selectedCategory,  String? selectedMode,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseFinderState() when $default != null:
return $default(_that.query,_that.status,_that.results,_that.featuredCourses,_that.selectedCategory,_that.selectedMode,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  CourseFinderStatus status,  List<CourseSummary> results,  List<CourseSummary> featuredCourses,  String? selectedCategory,  String? selectedMode,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CourseFinderState():
return $default(_that.query,_that.status,_that.results,_that.featuredCourses,_that.selectedCategory,_that.selectedMode,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  CourseFinderStatus status,  List<CourseSummary> results,  List<CourseSummary> featuredCourses,  String? selectedCategory,  String? selectedMode,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CourseFinderState() when $default != null:
return $default(_that.query,_that.status,_that.results,_that.featuredCourses,_that.selectedCategory,_that.selectedMode,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CourseFinderState extends CourseFinderState {
  const _CourseFinderState({this.query = '', this.status = CourseFinderStatus.idle, final  List<CourseSummary> results = const <CourseSummary>[], final  List<CourseSummary> featuredCourses = const <CourseSummary>[], this.selectedCategory, this.selectedMode, this.errorMessage}): _results = results,_featuredCourses = featuredCourses,super._();
  

@override@JsonKey() final  String query;
@override@JsonKey() final  CourseFinderStatus status;
 final  List<CourseSummary> _results;
@override@JsonKey() List<CourseSummary> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}

 final  List<CourseSummary> _featuredCourses;
@override@JsonKey() List<CourseSummary> get featuredCourses {
  if (_featuredCourses is EqualUnmodifiableListView) return _featuredCourses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_featuredCourses);
}

@override final  String? selectedCategory;
@override final  String? selectedMode;
@override final  String? errorMessage;

/// Create a copy of CourseFinderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseFinderStateCopyWith<_CourseFinderState> get copyWith => __$CourseFinderStateCopyWithImpl<_CourseFinderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseFinderState&&(identical(other.query, query) || other.query == query)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._results, _results)&&const DeepCollectionEquality().equals(other._featuredCourses, _featuredCourses)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.selectedMode, selectedMode) || other.selectedMode == selectedMode)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,query,status,const DeepCollectionEquality().hash(_results),const DeepCollectionEquality().hash(_featuredCourses),selectedCategory,selectedMode,errorMessage);

@override
String toString() {
  return 'CourseFinderState(query: $query, status: $status, results: $results, featuredCourses: $featuredCourses, selectedCategory: $selectedCategory, selectedMode: $selectedMode, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CourseFinderStateCopyWith<$Res> implements $CourseFinderStateCopyWith<$Res> {
  factory _$CourseFinderStateCopyWith(_CourseFinderState value, $Res Function(_CourseFinderState) _then) = __$CourseFinderStateCopyWithImpl;
@override @useResult
$Res call({
 String query, CourseFinderStatus status, List<CourseSummary> results, List<CourseSummary> featuredCourses, String? selectedCategory, String? selectedMode, String? errorMessage
});




}
/// @nodoc
class __$CourseFinderStateCopyWithImpl<$Res>
    implements _$CourseFinderStateCopyWith<$Res> {
  __$CourseFinderStateCopyWithImpl(this._self, this._then);

  final _CourseFinderState _self;
  final $Res Function(_CourseFinderState) _then;

/// Create a copy of CourseFinderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? status = null,Object? results = null,Object? featuredCourses = null,Object? selectedCategory = freezed,Object? selectedMode = freezed,Object? errorMessage = freezed,}) {
  return _then(_CourseFinderState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CourseFinderStatus,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<CourseSummary>,featuredCourses: null == featuredCourses ? _self._featuredCourses : featuredCourses // ignore: cast_nullable_to_non_nullable
as List<CourseSummary>,selectedCategory: freezed == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String?,selectedMode: freezed == selectedMode ? _self.selectedMode : selectedMode // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$CourseSummary {

 String get id; String get title; String? get category; String? get level; String? get mode; String? get duration; String? get provider; String? get thumbnailUrl; String? get shortDescription;
/// Create a copy of CourseSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseSummaryCopyWith<CourseSummary> get copyWith => _$CourseSummaryCopyWithImpl<CourseSummary>(this as CourseSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.level, level) || other.level == level)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,category,level,mode,duration,provider,thumbnailUrl,shortDescription);

@override
String toString() {
  return 'CourseSummary(id: $id, title: $title, category: $category, level: $level, mode: $mode, duration: $duration, provider: $provider, thumbnailUrl: $thumbnailUrl, shortDescription: $shortDescription)';
}


}

/// @nodoc
abstract mixin class $CourseSummaryCopyWith<$Res>  {
  factory $CourseSummaryCopyWith(CourseSummary value, $Res Function(CourseSummary) _then) = _$CourseSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? category, String? level, String? mode, String? duration, String? provider, String? thumbnailUrl, String? shortDescription
});




}
/// @nodoc
class _$CourseSummaryCopyWithImpl<$Res>
    implements $CourseSummaryCopyWith<$Res> {
  _$CourseSummaryCopyWithImpl(this._self, this._then);

  final CourseSummary _self;
  final $Res Function(CourseSummary) _then;

/// Create a copy of CourseSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = freezed,Object? level = freezed,Object? mode = freezed,Object? duration = freezed,Object? provider = freezed,Object? thumbnailUrl = freezed,Object? shortDescription = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseSummary].
extension CourseSummaryPatterns on CourseSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseSummary value)  $default,){
final _that = this;
switch (_that) {
case _CourseSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseSummary value)?  $default,){
final _that = this;
switch (_that) {
case _CourseSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? category,  String? level,  String? mode,  String? duration,  String? provider,  String? thumbnailUrl,  String? shortDescription)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseSummary() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.level,_that.mode,_that.duration,_that.provider,_that.thumbnailUrl,_that.shortDescription);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? category,  String? level,  String? mode,  String? duration,  String? provider,  String? thumbnailUrl,  String? shortDescription)  $default,) {final _that = this;
switch (_that) {
case _CourseSummary():
return $default(_that.id,_that.title,_that.category,_that.level,_that.mode,_that.duration,_that.provider,_that.thumbnailUrl,_that.shortDescription);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? category,  String? level,  String? mode,  String? duration,  String? provider,  String? thumbnailUrl,  String? shortDescription)?  $default,) {final _that = this;
switch (_that) {
case _CourseSummary() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.level,_that.mode,_that.duration,_that.provider,_that.thumbnailUrl,_that.shortDescription);case _:
  return null;

}
}

}

/// @nodoc


class _CourseSummary implements CourseSummary {
  const _CourseSummary({required this.id, required this.title, this.category, this.level, this.mode, this.duration, this.provider, this.thumbnailUrl, this.shortDescription});
  

@override final  String id;
@override final  String title;
@override final  String? category;
@override final  String? level;
@override final  String? mode;
@override final  String? duration;
@override final  String? provider;
@override final  String? thumbnailUrl;
@override final  String? shortDescription;

/// Create a copy of CourseSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseSummaryCopyWith<_CourseSummary> get copyWith => __$CourseSummaryCopyWithImpl<_CourseSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.level, level) || other.level == level)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.shortDescription, shortDescription) || other.shortDescription == shortDescription));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,category,level,mode,duration,provider,thumbnailUrl,shortDescription);

@override
String toString() {
  return 'CourseSummary(id: $id, title: $title, category: $category, level: $level, mode: $mode, duration: $duration, provider: $provider, thumbnailUrl: $thumbnailUrl, shortDescription: $shortDescription)';
}


}

/// @nodoc
abstract mixin class _$CourseSummaryCopyWith<$Res> implements $CourseSummaryCopyWith<$Res> {
  factory _$CourseSummaryCopyWith(_CourseSummary value, $Res Function(_CourseSummary) _then) = __$CourseSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? category, String? level, String? mode, String? duration, String? provider, String? thumbnailUrl, String? shortDescription
});




}
/// @nodoc
class __$CourseSummaryCopyWithImpl<$Res>
    implements _$CourseSummaryCopyWith<$Res> {
  __$CourseSummaryCopyWithImpl(this._self, this._then);

  final _CourseSummary _self;
  final $Res Function(_CourseSummary) _then;

/// Create a copy of CourseSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = freezed,Object? level = freezed,Object? mode = freezed,Object? duration = freezed,Object? provider = freezed,Object? thumbnailUrl = freezed,Object? shortDescription = freezed,}) {
  return _then(_CourseSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,level: freezed == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String?,mode: freezed == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String?,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,shortDescription: freezed == shortDescription ? _self.shortDescription : shortDescription // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
