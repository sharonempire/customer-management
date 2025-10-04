import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/course_finder/model/course_finder_state.dart';
import 'package:management_software/features/data/course_finder/model/course_model.dart';
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
      super(CourseFinderState.initial()) {
    Future<void>.microtask(loadCourses);
  }

  final CourseFinderRepository _repository;

  Future<void> loadCourses() async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      overrideErrorMessage: true,
    );

    try {
      final courses =
          await _repository.fetchCourses(filters: state.filters);
      final filtered = _applyClientSideFilters(courses, state.filters);
      state = state.copyWith(
        isLoading: false,
        courses: filtered,
        errorMessage: null,
        overrideErrorMessage: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString(),
        overrideErrorMessage: true,
      );
    }
  }

  Future<void> applyFilters(CourseFinderFilters filters) async {
    state = state.copyWith(filters: filters);
    await loadCourses();
  }

  Future<void> resetFilters() async {
    await applyFilters(const CourseFinderFilters());
  }

  List<Course> _applyClientSideFilters(
    List<Course> courses,
    CourseFinderFilters filters,
  ) {
    var filtered = courses;

    if (filters.commissionTier != null && filters.commissionTier!.isNotEmpty) {
      filtered = filtered
          .where((course) =>
              _matchesCommissionTier(course.commission, filters.commissionTier!))
          .toList(growable: false);
    }

    if (filters.englishTest != null && filters.englishTest!.trim().isNotEmpty) {
      final keyword = filters.englishTest!.toLowerCase().trim();
      filtered = filtered
          .where(
            (course) => course.englishProficiency
                ?.toLowerCase()
                .contains(keyword) ??
            false,
          )
          .toList(growable: false);
    }

    if (filters.minEnglishScore != null &&
        filters.minEnglishScore!.trim().isNotEmpty) {
      final keyword = filters.minEnglishScore!.toLowerCase().trim();
      filtered = filtered
          .where(
            (course) => course?.englishProficiency
                ?.toLowerCase()
                .contains(keyword) ??
            false,
          )
          .toList(growable: false);
    }

    return filtered;
  }

  bool _matchesCommissionTier(int? commission, String tierLabel) {
    if (commission == null) return false;

    switch (tierLabel) {
      case 'Tier 1 (20% +)':
        return commission >= 20;
      case 'Tier 2 (15% - 19%)':
        return commission >= 15 && commission < 20;
      case 'Tier 3 (10% - 14%)':
        return commission >= 10 && commission < 15;
      case 'Tier 4 (< 10%)':
        return commission < 10;
      default:
        return false;
    }
  }
}
