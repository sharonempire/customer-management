import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';

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
        ],
      ),
    );
  }
}
