import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';

class AddCourseLandingScreen extends StatelessWidget {
  const AddCourseLandingScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This flow will let you add courses soon.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppbar(title: 'Add Courses'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bulk import or add single courses',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorConsts.secondaryColor,
                    ),
              ),
              height5,
              Text(
                'Choose the workflow that fits your needs. Detailed forms will be available in the next iteration.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorConsts.textColor,
                    ),
              ),
              height30,
              _AddCourseOptionCard(
                icon: Icons.cloud_upload_outlined,
                title: 'Bulk import courses',
                description:
                    'Upload a CSV or Excel file to bring multiple courses into the system in one go.',
                actionLabel: 'Bulk Import',
                iconColor: ColorConsts.primaryColor,
                onPressed: () => _showComingSoon(context),
              ),
              height20,
              _AddCourseOptionCard(
                icon: Icons.add_circle_outline,
                title: 'Add single courses one by one',
                description:
                    'Use guided forms to configure course details, pricing, and availability individually.',
                actionLabel: 'Add Single Course',
                iconColor: ColorConsts.activeColor,
                onPressed: () => _showComingSoon(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddCourseOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final Color iconColor;
  final VoidCallback onPressed;

  const _AddCourseOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: ColorConsts.lightGrey.withOpacity(0.8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            width20,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorConsts.secondaryColor,
                        ),
                  ),
                  height5,
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorConsts.textColor,
                        ),
                  ),
                ],
              ),
            ),
            width20,
            FilledButton(
              onPressed: onPressed,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
