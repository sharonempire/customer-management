import 'package:management_software/features/data/course_finder/model/course_model.dart';

class CourseFinderFilters {
  const CourseFinderFilters({
    this.programQuery,
    this.intake,
    this.country,
    this.city,
    this.commissionTier,
    this.studyType,
    this.fieldOfStudy,
    this.programLevel,
    this.currency,
    this.language,
    this.englishTest,
    this.minEnglishScore,
  });

  final String? programQuery;
  final String? intake;
  final String? country;
  final String? city;
  final String? commissionTier;
  final String? studyType;
  final String? fieldOfStudy;
  final String? programLevel;
  final String? currency;
  final String? language;
  final String? englishTest;
  final String? minEnglishScore;

  CourseFinderFilters copyWith({
    String? programQuery,
    String? intake,
    String? country,
    String? city,
    String? commissionTier,
    String? studyType,
    String? fieldOfStudy,
    String? programLevel,
    String? currency,
    String? language,
    String? englishTest,
    String? minEnglishScore,
  }) {
    return CourseFinderFilters(
      programQuery: programQuery ?? this.programQuery,
      intake: intake ?? this.intake,
      country: country ?? this.country,
      city: city ?? this.city,
      commissionTier: commissionTier ?? this.commissionTier,
      studyType: studyType ?? this.studyType,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      programLevel: programLevel ?? this.programLevel,
      currency: currency ?? this.currency,
      language: language ?? this.language,
      englishTest: englishTest ?? this.englishTest,
      minEnglishScore: minEnglishScore ?? this.minEnglishScore,
    );
  }
}

abstract class CourseFinderRepository {
  Future<List<Course>> fetchCourses({CourseFinderFilters? filters});
  Future<Course> addCourse(Course course);
  Future<int> importCourses(List<Course> courses);
}
