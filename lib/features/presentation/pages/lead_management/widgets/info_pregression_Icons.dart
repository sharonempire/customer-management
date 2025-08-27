import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class InfoProgressionIcons extends StatelessWidget {
  final int progressedIndex;
  const InfoProgressionIcons({super.key, required this.progressedIndex});

  Widget buildStep({
    required int stepIndex,
    required IconData icon,
    required String label,
  }) {
    final isSelected = progressedIndex >= stepIndex;
    return Column(
      children: [
        CircleAvatar(
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
  Widget build(BuildContext context) {
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
          ),
          width10,
          buildStep(
            stepIndex: 1,
            icon: Icons.school, // Education
            label: "Education",
          ),
          width10,
          buildStep(
            stepIndex: 2,
            icon: Icons.work, // Work Experience
            label: "Work Experience",
          ),
          width10,
          buildStep(
            stepIndex: 3,
            icon: Icons.attach_money, // Budget Info
            label: "Budget Info",
          ),
          width10,
          buildStep(
            stepIndex: 4,
            icon: Icons.settings_applications, // Preferences
            label: "Preferences",
          ),
          width10,
          buildStep(
            stepIndex: 5,
            icon: Icons.language, // English Proficiency
            label: "English Proficiency",
          ),
          width30,
        ],
      ),
    );
  }
}
