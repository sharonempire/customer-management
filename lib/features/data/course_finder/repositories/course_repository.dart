import 'dart:developer';

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
  Future<List<Course>> fetchCourses({CourseFinderFilters? filters}) async {
    try {
      var query = _networkService.supabase
          .from(SupabaseTables.courses)
          .select('*');

      final applied = filters;

      if (applied != null) {
        if (_isNotEmpty(applied.programQuery)) {
          query = query.ilike('program_name', '%${applied.programQuery!.trim()}%');
        }

        if (_isNotEmpty(applied.intake)) {
          query = query.contains('intakes', [applied.intake!.trim()]);
        }

        if (_isNotEmpty(applied.country)) {
          query = query.eq('country', applied.country!.trim());
        }

        if (_isNotEmpty(applied.city)) {
          query = query.eq('city', applied.city!.trim());
        }

        if (_isNotEmpty(applied.studyType)) {
          query = query.eq('study_type', applied.studyType!.trim());
        }

        if (_isNotEmpty(applied.fieldOfStudy)) {
          query = query.eq('field_of_study', applied.fieldOfStudy!.trim());
        }

        if (_isNotEmpty(applied.programLevel)) {
          query = query.eq('program_level', applied.programLevel!.trim());
        }

        if (_isNotEmpty(applied.currency)) {
          query = query.eq('currency', applied.currency!.trim());
        }

        if (_isNotEmpty(applied.language)) {
          query = query.eq('language', applied.language!.trim());
        }

        if (_isNotEmpty(applied.englishTest)) {
          query = query.ilike('english_proficiency',
              '%${applied.englishTest!.trim()}%');
        }

        if (_isNotEmpty(applied.minEnglishScore)) {
          query = query.ilike('english_proficiency',
              '%${applied.minEnglishScore!.trim()}%');
        }
      }

      final response = await query;
      if (response is! List) return const <Course>[];

      return response
          .whereType<Map<String, dynamic>>()
          .map(Course.fromJson)
          .toList(growable: false);
    } catch (error, stackTrace) {
      log('Fetch courses error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }

  @override
  Future<int> importCourses(List<Course> courses) async {
    if (courses.isEmpty) return 0;

    final payload = courses.map((course) => course.toJson()).toList();

    try {
      final response = await _networkService.supabase
          .from(SupabaseTables.courses)
          .insert(payload)
          .select('id');

      if (response is List) {
        return response.length;
      }

      return payload.length;
    } catch (error, stackTrace) {
      log('Bulk import error: $error', stackTrace: stackTrace);
      rethrow;
    }
  }

  bool _isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;
}
