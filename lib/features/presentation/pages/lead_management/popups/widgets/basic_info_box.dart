import 'dart:developer';

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
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedGender = "Male";
  String? maritalStatusSelected = "Single";
  String? dateOfBirth = "";

  @override
  void initState() {
    Future.microtask(() async {
      final leadInfo = ref.watch(leadMangementcontroller).selectedLead;
      log("leadInfo: ${leadInfo.toString()}");
      if (leadInfo != null) {
        firstNameController.text = leadInfo.basicInfo?.firstName ?? "";
        secondNameController.text = leadInfo.basicInfo?.secondName ?? "";
        phoneController.text = leadInfo.basicInfo?.phone ?? "";
        emailController.text = leadInfo.basicInfo?.email ?? "";
        selectedGender = leadInfo.basicInfo?.gender ?? "Male";
        maritalStatusSelected = leadInfo.basicInfo?.maritalStatus ?? "Single";
        dateOfBirth = leadInfo.basicInfo?.dateOfBirth ?? "";

        log(
          "leadInfo.basicInfo?.dateOfBirth: ${leadInfo.basicInfo?.dateOfBirth}",
        );
        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isFromNewLead = ref.watch(fromNewLead);
    log("${isFromNewLead.toString()}////////////");
    Future<void> saveBasicInfo() async {
      log("${isFromNewLead.toString()}////////////");
      if (isFromNewLead) {
        ref.read(leadMangementcontroller.notifier).setFromNewLead(false);

        final response = await ref
            .read(leadMangementcontroller.notifier)
            .addLead(
              context: context,
              lead: LeadsListModel(
                status: "Lead creation",
                source: "crm",
                name: firstNameController.text,
                assignedTo: null,
                phone: int.parse(phoneController.text),
                email: emailController.text,
              ),
            );
        await ref
            .read(leadMangementcontroller.notifier)
            .updateLeadInfo(
              context: context,
              leadId: response.id.toString(),
              updatedData:
                  LeadInfoModel(
                    basicInfo: BasicInfo(
                      email: emailController.text,
                      phone: phoneController.text,
                      firstName: firstNameController.text,
                      secondName: secondNameController.text,
                      gender: selectedGender,
                      maritalStatus: maritalStatusSelected,
                      dateOfBirth: dateOfBirth,
                    ),
                  ).toJson(),
            );
      } else {
        await ref
            .read(leadMangementcontroller.notifier)
            .updateLeadInfo(
              context: context,
              leadId:
                  ref
                      .watch(leadMangementcontroller)
                      .selectedLeadLocally
                      ?.id
                      .toString() ??
                  "",
              updatedData:
                  LeadInfoModel(
                    basicInfo: BasicInfo(
                      email: emailController.text,
                      phone: phoneController.text,
                      firstName: firstNameController.text,
                      secondName: secondNameController.text,
                      gender: selectedGender,
                      maritalStatus: maritalStatusSelected,
                      dateOfBirth: dateOfBirth,
                    ),
                  ).toJson(),
            );
      }
    }

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
              CommonTextField(text: "Email", controller: emailController),
              width20,
              CommonTextField(text: "Phone", controller: phoneController),
            ],
          ),
          Row(
            children: [
              CommonDropdown(
                label: "Gender",
                items: ["Male", "Female", "Other", "Rather not say"],
                value: selectedGender,
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
                value: maritalStatusSelected,
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
                initialDate: dateOfBirth,
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
            onSavePressed: () async {
              await saveBasicInfo();
            },
            onPrevPressed: () async {},
            onNextPressed: () async {
              await saveBasicInfo();
            },
          ),
        ],
      ),
    );
  }
}
