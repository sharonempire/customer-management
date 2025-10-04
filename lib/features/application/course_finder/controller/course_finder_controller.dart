import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/course_finder/model/course_finder_state.dart';
import 'package:management_software/features/data/course_finder/repositories/course_repository.dart';
import 'package:management_software/features/domain/course_finder/course_repository.dart';
import 'package:management_software/shared/network/network_calls.dart';

final courseFinderRepositoryProvider = Provider<CourseFinderRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return SupabaseCourseRepository(networkService);
});

final courseFinderControllerProvider =
    StateNotifierProvider<CourseFinderController, CourseFinderState>((ref) {
      final repository = ref.watch(courseFinderRepositoryProvider);
      return CourseFinderController(repository: repository);
    });

class CourseFinderController extends StateNotifier<CourseFinderState> {
  CourseFinderController({required CourseFinderRepository repository})
    : _repository = repository,
      super(const CourseFinderState());

  final CourseFinderRepository _repository;

}
