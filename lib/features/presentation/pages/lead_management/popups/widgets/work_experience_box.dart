import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class WorkExperienceInfo extends ConsumerStatefulWidget {
  const WorkExperienceInfo({super.key});

  @override
  ConsumerState<WorkExperienceInfo> createState() => _WorkExperienceInfoState();
}

class _WorkExperienceInfoState extends ConsumerState<WorkExperienceInfo> {
  bool haveWorkExperience = false;

  // List to hold all work experiences
  List<WorkExperience> workExperiences = [];

  // Controllers for each experience field
  final List<Map<String, TextEditingController>> controllersList = [];

  @override
  void initState() {
    super.initState();
    _addNewExperience();
  }

  // Add a new experience with controllers
  void _addNewExperience() {
    workExperiences.add(WorkExperience());
    controllersList.add({
      "companyName": TextEditingController(),
      "designation": TextEditingController(),
      "companyAddress": TextEditingController(),
      "description": TextEditingController(),
    });
    setState(() {});
  }

  // Save or Next handler
  Future<void> _saveOrNext(BuildContext context) async {
    final leadId =
        ref
            .watch(leadMangementcontroller)
            .selectedLeadLocally
            ?.id
            ?.toString() ??
        "";

    // update model from controllers before sending
    for (int i = 0; i < workExperiences.length; i++) {
      workExperiences[i].companyName = controllersList[i]["companyName"]!.text;
      workExperiences[i].designation = controllersList[i]["designation"]!.text;
      workExperiences[i].companyAddress =
          controllersList[i]["companyAddress"]!.text;
      workExperiences[i].description = controllersList[i]["description"]!.text;
    }

    await ref
        .read(leadMangementcontroller.notifier)
        .updateLeadInfo(
          context: context,
          leadId: leadId,
          updatedData: LeadInfoModel(workExperience: workExperiences).toJson(),
        );
  }

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
                  setState(() {
                    haveWorkExperience = val;
                  });
                },
              ),
            ],
          ),
          if (haveWorkExperience) ...[
            height20,
            Text(
              "Work Experience Details",
              style: myTextstyle(fontWeight: FontWeight.bold),
            ),
            height20,
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: workExperiences.length,
              itemBuilder: (context, index) {
                return _buildWorkExperienceCard(index);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: _addNewExperience,
                  label: Text(
                    "Add Another Experience",
                    style: myTextstyle(color: ColorConsts.primaryColor),
                  ),
                  icon: Icon(Icons.add, color: ColorConsts.primaryColor),
                ),
              ],
            ),
            height20,
            PreviousAndNextButtons(
              onSavePressed: () async => _saveOrNext(context),
              onPrevPressed: () async {
                // handle prev if needed
              },
              onNextPressed: () async => _saveOrNext(context),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkExperienceCard(int index) {
    final exp = workExperiences[index];
    final ctrls = controllersList[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CommonTextField(
                  controller: ctrls["companyName"]!,
                  text: "Company Name",
                  onChanged: (val) => exp.companyName = val,
                ),
                width10,
                CommonTextField(
                  controller: ctrls["designation"]!,
                  text: "Designation",
                  onChanged: (val) => exp.designation = val,
                ),
              ],
            ),
            Row(
              children: [
                CommonDropdown(
                  label: "Job Type",
                  items: ["Full Time", "Part Time", "Internship"],
                  value: exp.jobType,
                  onChanged: (val) => setState(() => exp.jobType = val),
                ),
                width10,
                CommonDropdown(
                  label: "Location",
                  items: ["Remote", "Onsite", "Hybrid"],
                  value: exp.location,
                  onChanged: (val) => setState(() => exp.location = val),
                ),
              ],
            ),
            Row(
              children: [
                CommonDatePicker(
                  label: "Date of Joining",
                  onDateSelected:
                      (date) =>
                          exp.dateOfJoining = DateTimeHelper.formatDateForLead(
                            date ?? DateTime.now(),
                          ),
                ),
                width10,
                CommonDatePicker(
                  label: "Date of Leaving",
                  onDateSelected:
                      (date) =>
                          exp.dateOfRelieving =
                              DateTimeHelper.formatDateForLead(
                                date ?? DateTime.now(),
                              ),
                ),
              ],
            ),
            Row(
              children: [
                CommonTextField(
                  controller: ctrls["companyAddress"]!,
                  text: "Company Address",
                  onChanged: (val) => exp.companyAddress = val,
                ),
              ],
            ),
            Row(
              children: [
                CommonTextField(
                  controller: ctrls["description"]!,
                  text: "Description",
                  onChanged: (val) => exp.description = val,
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    workExperiences.removeAt(index);
                    controllersList.removeAt(index);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
