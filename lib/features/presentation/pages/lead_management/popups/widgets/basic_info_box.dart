import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/date_time_helper.dart';

class BasicInfoCollection extends ConsumerStatefulWidget {
  const BasicInfoCollection({super.key});

  @override
  ConsumerState<BasicInfoCollection> createState() =>
      _BasicInfoCollectionState();
}

class _BasicInfoCollectionState extends ConsumerState<BasicInfoCollection> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  String? selectedGender = "Male";
  String? maritalStatusSelected = "Single";
  String? dateOfBirth = "";
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        children: [
          Row(
            children: [
              CommonTextField(
                text: "First Name",
                controller: firstNameController,
              ),
              width20,
              CommonTextField(
                text: "Second Name",
                controller: secondNameController,
              ),
            ],
          ),
          Row(
            children: [
              CommonDropdown(
                label: "Gender",
                items: ["Male", "Female", "Other", "Rather not say"],
                value: "Male",
                onChanged: (val) {
                  setState(() {
                    selectedGender = val;
                  });
                },
              ),
              width20,
              CommonDropdown(
                label: "Marital Status",
                items: ["Single", "Married"],
                value: "Single",
                onChanged: (val) {
                  setState(() {
                    maritalStatusSelected = val;
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              CommonDatePicker(
                label: "Date Of Birth",
                onDateSelected: (value) {
                  dateOfBirth = DateTimeHelper.formatDateForLead(
                    value ?? DateTime.now(),
                  );
                  setState(() {});
                },
              ),
              width20,
              Expanded(child: SizedBox()),
            ],
          ),
          height20,
          PreviousAndNextButtons(
            onSavePressed: () {
              final isFromNewLead = ref.watch(fromNewLead);
              if (isFromNewLead) {
                ref
                    .read(leadMangementcontroller.notifier)
                    .addLead(
                      context: context,
                      lead: LeadsListModel(name: firstNameController.text),
                    );
                ref
                    .read(leadMangementcontroller.notifier)
                    .updateLeadInfo(
                      context: context,
                      leadId: 1.toString(),
                      updatedData:LeadInfoModel(basicInfo: BasicInfo(firstName: firstNameController.text, secondName: secondNameController.text, gender: selectedGender, maritalStatus: maritalStatusSelected, dateOfBirth: dateOfBirth)).toJson(),
                    );
              } else {
                ref
                    .read(leadMangementcontroller.notifier)
                    .updateLeadInfo(
                      context: context,
                      leadId: 1.toString(),
                      updatedData: {},
                    );
              }
            },
            onPrevPressed: () {},
            onNextPressed: () {},
          ),
        ],
      ),
    );
  }
}
