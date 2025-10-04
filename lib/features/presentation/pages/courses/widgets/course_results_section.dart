import 'package:flutter/material.dart';
import 'package:management_software/features/data/course_finder/model/course_model.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';

class CourseResultsSection extends StatelessWidget {
  final List<CourseListItem> courses;
  final bool isLoading;
  final String? errorMessage;

  const CourseResultsSection({
    super.key,
    required this.courses,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (isLoading) {
      content = const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (errorMessage != null) {
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Text(
          errorMessage!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
    } else if (courses.isEmpty) {
      content = Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Text(
          'No courses match the selected filters yet.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConsts.textColor,
              ),
        ),
      );
    } else {
      content = Column(
        children: courses
            .map(
              (course) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _CourseCard(course: course),
              ),
            )
            .toList(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course results',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: ColorConsts.secondaryColor,
              ),
        ),
        height10,
        content,
      ],
    );
  }
}

class CourseListItem {
  final String programName;
  final String university;
  final String country;
  final String city;
  final String campus;
  final String tuitionFee;
  final String studyType;
  final String programLevel;
  final String duration;
  final String intake;
  final String englishRequirement;
  final String commission;
  final String currency;
  final String fieldOfStudy;
  final String language;
  final List<String> tags;

  const CourseListItem({
    required this.programName,
    required this.university,
    required this.country,
    required this.city,
    required this.campus,
    required this.tuitionFee,
    required this.studyType,
    required this.programLevel,
    required this.duration,
    required this.intake,
    required this.englishRequirement,
    required this.commission,
    required this.currency,
    required this.fieldOfStudy,
    required this.language,
    required this.tags,
  });

  factory CourseListItem.fromCourse(Course course) {
    final intakes = course.intakes ?? const <String>[];
    final requiredSubjects = course.requiredSubjects ?? const <String>[];

    final commissionValue = course.commission?.toString();
    final tags = <String>[];
    if (requiredSubjects.isNotEmpty) tags.addAll(requiredSubjects);
    if ((course.fieldOfStudy ?? '').isNotEmpty) {
      tags.add(course.fieldOfStudy!);
    }

    if ((course.studyType ?? '').isNotEmpty) {
      tags.add(course.studyType!);
    }

    return CourseListItem(
      programName: course.programName ?? 'Unnamed program',
      university: course.university ?? 'Unknown university',
      country: course.country ?? 'Unknown country',
      city: course.city ?? 'Unknown city',
      campus: course.campus ?? 'Main campus',
      tuitionFee: course.tuitionFee ?? 'N/A',
      studyType: course.studyType ?? 'Not specified',
      programLevel: course.programLevel ?? 'Not specified',
      duration: course.duration ?? 'Not specified',
      intake: intakes.isNotEmpty ? intakes.join(', ') : 'Not specified',
      englishRequirement: course.englishProficiency ?? 'Not specified',
      commission:
          commissionValue != null ? '$commissionValue%' : 'Not specified',
      currency: course.currency ?? '—',
      fieldOfStudy: course.fieldOfStudy ?? 'Not specified',
      language: course.language ?? 'Not specified',
      tags: tags,
    );
  }
}

class _CourseCard extends StatelessWidget {
  final CourseListItem course;

  const _CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: ColorConsts.lightGrey.withOpacity(0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.programName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: ColorConsts.secondaryColor,
                            ),
                      ),
                      height5,
                      Text(
                        '${course.university} · ${course.country}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: ColorConsts.textColor,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${course.currency} ${course.tuitionFee}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: ColorConsts.primaryColor,
                          ),
                    ),
                    height5,
                    Text(
                      'Commission ${course.commission}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: ColorConsts.textColor,
                          ),
                    ),
                  ],
                ),
              ],
            ),
            height20,
            Wrap(
              spacing: 24,
              runSpacing: 12,
              children: [
                _CourseInfoTile(
                  label: 'Field of study',
                  value: course.fieldOfStudy,
                ),
                _CourseInfoTile(
                  label: 'Campus',
                  value: '${course.city} · ${course.campus}',
                ),
                _CourseInfoTile(
                  label: 'Language',
                  value: course.language,
                ),
                _CourseInfoTile(
                  label: 'Study type',
                  value: course.studyType,
                ),
                _CourseInfoTile(
                  label: 'Program level',
                  value: course.programLevel,
                ),
                _CourseInfoTile(
                  label: 'Duration',
                  value: course.duration,
                ),
                _CourseInfoTile(
                  label: 'Upcoming intake',
                  value: course.intake,
                ),
                _CourseInfoTile(
                  label: 'English requirement',
                  value: course.englishRequirement,
                ),
              ],
            ),
            height20,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: course.tags
                  .map(
                    (tag) => Chip(
                      backgroundColor: ColorConsts.primaryColor.withOpacity(0.08),
                      label: Text(
                        tag,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorConsts.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            height20,
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline),
                  label: const Text('View details'),
                ),
                width10,
                TextButton(
                  onPressed: () {},
                  child: const Text('Send to student'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _CourseInfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: ColorConsts.textColor,
                fontWeight: FontWeight.w500,
              ),
        ),
        height5,
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConsts.secondaryColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
