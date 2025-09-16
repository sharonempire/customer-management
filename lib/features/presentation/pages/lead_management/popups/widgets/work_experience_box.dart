import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class WorkExperienceInfo extends StatefulWidget {
  const WorkExperienceInfo({super.key});

  @override
  State<WorkExperienceInfo> createState() => _WorkExperienceInfoState();
}

class _WorkExperienceInfoState extends State<WorkExperienceInfo> {
  final companyNameController = TextEditingController();
  final descriptionController = TextEditingController();
  final companyAdressController = TextEditingController();
  final designationController = TextEditingController();
  bool haveWorkExperience = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommonSwitch(
                text: "Work experience",
                onChanged: (val) {
                  haveWorkExperience = val;
                  setState(() {});
                },
              ),
            ],
          ),
          height20,
          Row(
            children: [
              width20,
              Text(
                "Work Experience Details",
                style: myTextstyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          height20,
          Row(
            children: [
              CommonTextField(
                controller: companyAdressController,
                text: "Company Name",
              ),
              CommonTextField(
                controller: designationController,
                text: "Designation",
              ),
            ],
          ),
          Row(
            children: [
              CommonDropdown(
                label: "Job Type",
                items: ["Full Time", "Part Time", "Internship"],
                onChanged: (value) {},
              ),
              CommonDropdown(
                label: "Location",
                items: ["Remote", "Onsite", "Hybrid"],
                onChanged: (value) {},
              ),
            ],
          ),
          Row(
            children: [
              CommonDatePicker(label: "Date of Joining"),
              CommonDatePicker(label: "Date of Leaving"),
            ],
          ),
          Row(
            children: [
              CommonTextField(
                controller: companyNameController,
                text: "Company Address",
              ),
            ],
          ),
          Row(
            children: [
              CommonTextField(
                controller: descriptionController,
                text: "Description",
              ),
            ],
          ),
          Row(
            children: [
              Spacer(),
              TextButton.icon(
                onPressed: () {},
                label: Text(
                  "Add Another Experience",
                  style: myTextstyle(color: ColorConsts.primaryColor),
                ),
                icon: Icon(Icons.add, color: ColorConsts.primaryColor),
              ),
              width10,
            ],
          ),
          height20,
          PreviousAndNextButtons(
            onSavePressed: () {},
            onPrevPressed: () {},
            onNextPressed: () {},
          ),
        ],
      ),
    );
  }
}
