import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';

class CourseFiltersPanel extends StatelessWidget {
  final List<CourseFilterSectionData> sections;
  final VoidCallback onSearch;
  final VoidCallback onClear;
  final bool isProcessing;

  const CourseFiltersPanel({
    super.key,
    required this.sections,
    required this.onSearch,
    required this.onClear,
    this.isProcessing = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: ColorConsts.greyContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Search Filters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorConsts.secondaryColor,
                  ),
            ),
            height10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < sections.length; index++) ...[
                  _CourseFilterSection(data: sections[index]),
                  if (index != sections.length - 1)
                    const SizedBox(height: 16),
                ],
              ],
            ),
            height20,
            Row(
              children: [
                PrimaryButton(
                  onpressed: isProcessing ? null : onSearch,
                  text: isProcessing ? 'Searching…' : 'Search Courses',
                  icon: Icons.search,
                ),
                width10,
                TextButton(
                  onPressed: isProcessing ? null : onClear,
                  style: TextButton.styleFrom(
                    foregroundColor: ColorConsts.primaryColor,
                  ),
                  child: const Text('Clear Filters'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CourseFilterSectionData {
  final String title;
  final List<Widget> rows;

  const CourseFilterSectionData({required this.title, required this.rows});
}

class _CourseFilterSection extends StatelessWidget {
  final CourseFilterSectionData data;

  const _CourseFilterSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorConsts.lightGrey),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: ColorConsts.secondaryColor,
                ),
          ),
          height10,
          for (var index = 0; index < data.rows.length; index++) ...[
            data.rows[index],
            if (index != data.rows.length - 1) height10,
          ],
        ],
      ),
    );
  }
}
