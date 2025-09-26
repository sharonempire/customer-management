import 'package:freezed_annotation/freezed_annotation.dart';

part 'course_finder_state.freezed.dart';

enum CourseFinderStatus { idle, loading, ready, error }

@freezed
class CourseFinderState with _$CourseFinderState {
  const factory CourseFinderState({
    @Default('') String query,
    @Default(CourseFinderStatus.idle) CourseFinderStatus status,
    @Default(<CourseSummary>[]) List<CourseSummary> results,
    @Default(<CourseSummary>[]) List<CourseSummary> featuredCourses,
    String? selectedCategory,
    String? selectedMode,
    String? errorMessage,
  }) = _CourseFinderState;

  const CourseFinderState._();

  bool get hasError =>
      status == CourseFinderStatus.error && errorMessage != null;
      
        @override
        // TODO: implement errorMessage
        String? get errorMessage => throw UnimplementedError();
      
        @override
        // TODO: implement featuredCourses
        List<CourseSummary> get featuredCourses => throw UnimplementedError();
      
        @override
        // TODO: implement query
        String get query => throw UnimplementedError();
      
        @override
        // TODO: implement results
        List<CourseSummary> get results => throw UnimplementedError();
      
        @override
        // TODO: implement selectedCategory
        String? get selectedCategory => throw UnimplementedError();
      
        @override
        // TODO: implement selectedMode
        String? get selectedMode => throw UnimplementedError();
      
        @override
        // TODO: implement status
        CourseFinderStatus get status => throw UnimplementedError();
}

@freezed
class CourseSummary with _$CourseSummary {
  const factory CourseSummary({
    required String id,
    required String title,
    String? category,
    String? level,
    String? mode,
    String? duration,
    String? provider,
    String? thumbnailUrl,
    String? shortDescription,
  }) = _CourseSummary;
  
  @override
  // TODO: implement category
  String? get category => throw UnimplementedError();
  
  @override
  // TODO: implement duration
  String? get duration => throw UnimplementedError();
  
  @override
  // TODO: implement id
  String get id => throw UnimplementedError();
  
  @override
  // TODO: implement level
  String? get level => throw UnimplementedError();
  
  @override
  // TODO: implement mode
  String? get mode => throw UnimplementedError();
  
  @override
  // TODO: implement provider
  String? get provider => throw UnimplementedError();
  
  @override
  // TODO: implement shortDescription
  String? get shortDescription => throw UnimplementedError();
  
  @override
  // TODO: implement thumbnailUrl
  String? get thumbnailUrl => throw UnimplementedError();
  
  @override
  // TODO: implement title
  String get title => throw UnimplementedError();
}
