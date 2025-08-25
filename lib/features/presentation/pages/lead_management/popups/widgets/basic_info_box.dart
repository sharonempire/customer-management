import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class BasicInfoCollection extends StatelessWidget {
  const BasicInfoCollection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        children: [
          Row(
            children: [
              CommonTextField(text: "First Name"),
              width20,
              CommonTextField(text: "Second Name"),
            ],
          ),
          Row(
            children: [
              CommonDropdown(
                label: "Gender",
                items: ["Male", "Female", "Other"],
                value: "Male",
                onChanged: (val) {},
              ),
              width20,
              CommonDropdown(
                label: "Marital Status",
                items: ["Married", "Single"],
                value: "Single",
                onChanged: (val) {},
              ),
            ],
          ),
          Row(
            children: [
              CommonDatePicker(label: "Date Of Birth"),
              width20,
              Expanded(child: SizedBox()),
            ],
          ),
          CommonInfoBox(),
          height20,
          Row(
            children: [
              width10,
              IconButton(
                onPressed: () {},
                icon: Row(
                  children: [
                    Icon(Icons.arrow_back_ios_new, size: 16),
                    width10,
                    Text("Previous", style: myTextstyle(fontSize: 16)),
                  ],
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: Text("Save", style: myTextstyle(fontSize: 16)),
              ),
              width30,
              PrimaryButton(onpressed: () {}, text: "Next"),
              width10,
            ],
          ),
          height20,
        ],
      ),
    );
  }
}
