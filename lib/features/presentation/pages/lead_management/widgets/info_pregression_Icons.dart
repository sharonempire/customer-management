import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/image_icon.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/consts/images.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class InfoProgressionIcons extends StatelessWidget {
  final int progressedIndex;
  const InfoProgressionIcons({super.key, required this.progressedIndex});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          width30,
          Column(
            children: [
              ImageIconContainer(size: 55, image: ImageConsts.basicInfoIcon),
              Text(
                "Basic Info",
                style: myTextstyle(
                  fontSize: 14,
                  color: ColorConsts.primaryColor,
                ),
              ),
            ],
          ),
          width10,
          Column(
            children: [
              ImageIconContainer(
                size: 55,
                image:
                    progressedIndex >= 1
                        ? ImageConsts.educationSelected
                        : ImageConsts.educationIcon,
              ),
              Text(
                "Education",
                style: myTextstyle(
                  fontSize: 14,
                  color:
                      progressedIndex >= 1
                          ? ColorConsts.primaryColor
                          : Colors.grey,
                ),
              ),
            ],
          ),
          width10,
          Column(
            children: [
              ImageIconContainer(
                size: 55,
                image:
                    progressedIndex >= 2
                        ? ImageConsts.workExperienceSelected
                        : ImageConsts.workExperienceIcon,
              ),
              Text(
                "Work Experience",
                style: myTextstyle(
                  fontSize: 14,
                  color:
                      progressedIndex >= 2
                          ? ColorConsts.primaryColor
                          : Colors.grey,
                ),
              ),
            ],
          ),
          width10,
          Column(
            children: [
              ImageIconContainer(size: 55, image: ImageConsts.budgetIcon),
              Text("Budget Info", style: myTextstyle(fontSize: 14)),
            ],
          ),
          width10,
          Column(
            children: [
              ImageIconContainer(size: 55, image: ImageConsts.preferences),
              Text("Preferences", style: myTextstyle(fontSize: 14)),
            ],
          ),
          width10,
          Column(
            children: [
              ImageIconContainer(size: 55, image: ImageConsts.language),
              Text("English Proficiency", style: myTextstyle(fontSize: 14)),
            ],
          ),
          width30,
        ],
      ),
    );
  }
}
