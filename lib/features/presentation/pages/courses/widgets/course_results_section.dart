import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';

class CourseResultsSection extends StatelessWidget {
  final List<CourseListItem> courses;

  const CourseResultsSection({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
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
        Column(
          children: courses
              .map(
                (course) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _CourseCard(course: course),
                ),
              )
              .toList(),
        ),
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
    required this.tags,
  });
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
                  label: 'Campus',
                  value: '${course.city} · ${course.campus}',
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
