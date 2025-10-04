import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';

class CourseFinderHeader extends StatelessWidget {
  final VoidCallback onAddCourse;

  const CourseFinderHeader({super.key, required this.onAddCourse});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Find the right course for every learner',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: ColorConsts.secondaryColor,
                    ),
              ),
              height5,
              Text(
                'Use the filters below to refine your search or add new courses to the catalogue.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: ColorConsts.textColor,
                    ),
              ),
            ],
          ),
        ),
        width20,
        PrimaryButton(
          onpressed: onAddCourse,
          text: 'Add Course',
          icon: Icons.add,
        ),
      ],
    );
  }
}
