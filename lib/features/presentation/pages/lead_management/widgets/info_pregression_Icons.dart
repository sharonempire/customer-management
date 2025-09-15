import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class InfoProgressionIcons extends ConsumerWidget {
  const InfoProgressionIcons({super.key});

  Widget buildStep({
    required int stepIndex,
    required IconData icon,
    required String label,
    required WidgetRef ref,
  }) {
    final isSelected = ref.watch(infoCollectionProgression) >= stepIndex;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            ref
                .read(infoCollectionProgression.notifier)
                .update((state) => stepIndex);
          },
          child: CircleAvatar(
            radius: 25, // avatar size
            backgroundColor:
                isSelected ? ColorConsts.primaryColor : Colors.grey.shade300,
            child: Center(
              child: Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white : Colors.black54,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: myTextstyle(
            fontSize: 14,
            color: isSelected ? ColorConsts.primaryColor : Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          width30,
          buildStep(
            stepIndex: 0,
            icon: Icons.person, // Basic Info
            label: "Basic Info",
            ref: ref,
          ),
          width10,
          buildStep(
            stepIndex: 1,
            icon: Icons.school, // Education
            label: "Education",
            ref: ref,
          ),
          width10,
          buildStep(
            stepIndex: 2,
            icon: Icons.work, // Work Experience
            label: "Work Experience",
            ref: ref,
          ),
          width10,
          buildStep(
            stepIndex: 3,
            icon: Icons.attach_money, // Budget Info
            label: "Budget Info",
            ref: ref,
          ),
          width10,
          buildStep(
            stepIndex: 4,
            icon: Icons.settings_applications, // Preferences
            label: "Preferences",
            ref: ref,
          ),
          width10,
          buildStep(
            stepIndex: 5,
            icon: Icons.language, // English Proficiency
            label: "English Proficiency",
            ref: ref,
          ),
          width30,
        ],
      ),
    );
  }
}
