import 'package:management_software/features/application/course_finder/model/course_finder_state.dart';
import 'package:management_software/features/data/course_finder/model/course_model.dart';

abstract class CourseFinderRepository {
  Future<List<CourseSummary>> searchCourses({required String query});
  Future<List<CourseSummary>> fetchFeaturedCourses();
  Future<Course> addCourse(Course course);
  Future<int> importCourses(List<Course> courses);
}
