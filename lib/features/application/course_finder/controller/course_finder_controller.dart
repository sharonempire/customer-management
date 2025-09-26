import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/course_finder/model/course_finder_state.dart';


final courseFinderRepositoryProvider = Provider<CourseFinderRepository>((ref) {
  throw UnimplementedError('Provide a CourseFinderRepository implementation.');
});

final courseFinderControllerProvider =
    StateNotifierProvider<CourseFinderController, CourseFinderState>((ref) {
      final repository = ref.watch(courseFinderRepositoryProvider);
      return CourseFinderController(repository: repository);
    });

abstract class CourseFinderRepository {
  Future<List<CourseSummary>> searchCourses({required String query});
  Future<List<CourseSummary>> fetchFeaturedCourses();
}

class CourseFinderController extends StateNotifier<CourseFinderState> {
  CourseFinderController({required CourseFinderRepository repository})
    : _repository = repository,
      super(const CourseFinderState());

  final CourseFinderRepository _repository;

}
