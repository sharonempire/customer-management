import 'dart:typed_data';
import 'dart:io' as io;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/application/course_finder/controller/course_finder_controller.dart';
import 'package:management_software/features/application/course_finder/controller/course_import_controller.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/network/network_calls.dart';

class AddCourseLandingScreen extends ConsumerStatefulWidget {
  const AddCourseLandingScreen({super.key});

  @override
  ConsumerState<AddCourseLandingScreen> createState() =>
      _AddCourseLandingScreenState();
}

class _AddCourseLandingScreenState
    extends ConsumerState<AddCourseLandingScreen> {
  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<int>>(
      courseImportControllerProvider,
      (previous, next) {
        if (previous?.isLoading != true) return;
        if (next.isLoading) return;

        next.when(
          data: (count) {
            if (count > 0) {
              ref.read(snackbarServiceProvider).showSuccess(
                    context,
                    'Imported $count courses successfully.',
                  );
              ref.read(courseFinderControllerProvider.notifier).loadCourses();
            } else {
              ref.read(snackbarServiceProvider).showError(
                    context,
                    'No valid courses were found in the selected file.',
                  );
            }
            ref.read(courseImportControllerProvider.notifier).reset();
          },
          error: (error, _) {
            ref.read(snackbarServiceProvider).showError(
                  context,
                  error.toString(),
                );
            ref.read(courseImportControllerProvider.notifier).reset();
          },
          loading: () {},
        );
      },
    );

    final importState = ref.watch(courseImportControllerProvider);
    final isImporting = importState.isLoading;

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
                'Choose the workflow that fits your needs. You can import a prepared sheet or add courses manually.',
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
                actionLabel: isImporting ? 'Importing...' : 'Bulk Import',
                iconColor: ColorConsts.primaryColor,
                onPressed:
                    isImporting ? null : () => _pickBulkImportFile(context),
                isLoading: isImporting,
              ),
              height20,
              _AddCourseOptionCard(
                icon: Icons.add_circle_outline,
                title: 'Add single courses one by one',
                description:
                    'Use guided forms to configure course details, pricing, and availability individually.',
                actionLabel: 'Add Single Course',
                iconColor: ColorConsts.activeColor,
                onPressed: () {
                  final routerConsts = RouterConsts();
                  context.push(
                    '${routerConsts.courseFinder.route}/${routerConsts.addCourse.route}/${routerConsts.addSingleCourse.route}',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickBulkImportFile(BuildContext context) async {
    final notifier = ref.read(courseImportControllerProvider.notifier);
    final snackbar = ref.read(snackbarServiceProvider);

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'xlsx', 'xls'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;
      Uint8List? bytes = file.bytes;

      if (bytes == null && !kIsWeb && file.path != null) {
        bytes = await io.File(file.path!).readAsBytes();
      }

      if (bytes == null) {
        throw 'Unable to read the selected file. Please try again.';
      }

      await notifier.importFromBytes(bytes: bytes, fileName: file.name);
    } catch (error) {
      snackbar.showError(context, error.toString());
    }
  }
}

class _AddCourseOptionCard extends StatelessWidget {
  const _AddCourseOptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.iconColor,
    this.onPressed,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final String actionLabel;
  final Color iconColor;
  final VoidCallback? onPressed;
  final bool isLoading;

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
              child: isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        width10,
                        Text('Importing...'),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.chevron_right),
                        width5,
                        Text(actionLabel),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
