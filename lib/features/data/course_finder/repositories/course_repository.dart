import 'dart:developer';

import 'package:management_software/features/application/course_finder/model/course_finder_state.dart';
import 'package:management_software/features/data/course_finder/model/course_model.dart';
import 'package:management_software/features/domain/course_finder/course_repository.dart';
import 'package:management_software/shared/network/network_calls.dart';
import 'package:management_software/shared/supabase/keys.dart';

class SupabaseCourseRepository implements CourseFinderRepository {
  SupabaseCourseRepository(this._networkService);

  final NetworkService _networkService;

  @override
  Future<Course> addCourse(Course course) async {
    final payload = course.toJson();

    try {
      final response = await _networkService.push(
        table: SupabaseTables.courses,
        data: payload,
      );

      return Course.fromJson(response);
    } catch (error, stack) {
      log('Add course error: $error', stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<List<CourseSummary>> fetchFeaturedCourses() async {
    // TODO: Implement fetching logic when ready.
    return const <CourseSummary>[];
  }

  @override
  Future<List<CourseSummary>> searchCourses({required String query}) async {
    // TODO: Implement search logic when ready.
    return const <CourseSummary>[];
  }
}
