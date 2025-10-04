import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/course_finder/controller/course_finder_controller.dart';
import 'package:management_software/features/data/course_finder/model/course_model.dart';
import 'package:management_software/features/domain/course_finder/course_repository.dart';

final courseSubmissionControllerProvider =
    StateNotifierProvider<CourseSubmissionController, AsyncValue<Course?>>( (
      ref,
    ) {
      final repository = ref.watch(courseFinderRepositoryProvider);
      return CourseSubmissionController(repository: repository);
    });

class CourseSubmissionController extends StateNotifier<AsyncValue<Course?>> {
  CourseSubmissionController({required CourseFinderRepository repository})
    : _repository = repository,
      super(const AsyncValue.data(null));

  final CourseFinderRepository _repository;

  Future<void> submitCourse({required Course course}) async {
    state = const AsyncValue.loading();

    try {
      final saved = await _repository.addCourse(course);
      state = AsyncValue.data(saved);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}
