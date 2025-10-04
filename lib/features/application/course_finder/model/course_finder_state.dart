import 'package:management_software/features/data/course_finder/model/course_model.dart';
import 'package:management_software/features/domain/course_finder/course_repository.dart';

class CourseFinderState {
  CourseFinderState({
    required this.filters,
    this.isLoading = false,
    this.errorMessage,
    List<Course>? courses,
  }) : courses = courses ?? const <Course>[];

  final CourseFinderFilters filters;
  final bool isLoading;
  final String? errorMessage;
  final List<Course> courses;

  CourseFinderState copyWith({
    CourseFinderFilters? filters,
    bool? isLoading,
    String? errorMessage,
    bool overrideErrorMessage = false,
    List<Course>? courses,
  }) {
    return CourseFinderState(
      filters: filters ?? this.filters,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          overrideErrorMessage ? errorMessage : this.errorMessage,
      courses: courses ?? this.courses,
    );
  }

  static CourseFinderState initial() => CourseFinderState(
        filters: const CourseFinderFilters(),
        courses: const <Course>[],
      );
}
