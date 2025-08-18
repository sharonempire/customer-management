import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart';
import 'package:management_software/features/presentation/widgets/image_icon.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/consts/images.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class LeadInfoPopup extends StatelessWidget {
  const LeadInfoPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CommonAppbar(title: "Lead Info"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorConsts.activeColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      height10,
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            width30,
                            Column(
                              children: [
                                ImageIconContainer(
                                  size: 55,
                                  image: ImageConsts.basicInfoIcon,
                                ),
                                Text(
                                  "Basic Info",
                                  style: myTextstyle(fontSize: 14),
                                ),
                              ],
                            ),
                            width10,
                            Column(
                              children: [
                                ImageIconContainer(
                                  size: 55,

                                  image: ImageConsts.educationIcon,
                                ),
                                Text(
                                  "Education",
                                  style: myTextstyle(fontSize: 14),
                                ),
                              ],
                            ),
                            width10,
                            Column(
                              children: [
                                ImageIconContainer(
                                  size: 55,

                                  image: ImageConsts.workExperienceIcon,
                                ),
                                Text(
                                  "Work Experience",
                                  style: myTextstyle(fontSize: 14),
                                ),
                              ],
                            ),
                            width10,
                            Column(
                              children: [
                                ImageIconContainer(
                                  size: 55,
                                  image: ImageConsts.budgetIcon,
                                ),
                                Text(
                                  "Budget Info",
                                  style: myTextstyle(fontSize: 14),
                                ),
                              ],
                            ),
                            width10,
                            Column(
                              children: [
                                ImageIconContainer(
                                  size: 55,
                                  image: ImageConsts.preferences,
                                ),
                                Text(
                                  "Preferences",
                                  style: myTextstyle(fontSize: 14),
                                ),
                              ],
                            ),
                            width10,
                            Column(
                              children: [
                                ImageIconContainer(
                                  size: 55,
                                  image: ImageConsts.language,
                                ),
                                Text(
                                  "English Proficiency",
                                  style: myTextstyle(fontSize: 14),
                                ),
                              ],
                            ),
                            width30,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
