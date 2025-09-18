import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/dropdown_datas/boards_list.dart';
import 'package:management_software/features/data/dropdown_datas/deciplines.dart';
import 'package:management_software/features/data/dropdown_datas/streams_list.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class EducationInfoCollection extends ConsumerStatefulWidget {
  const EducationInfoCollection({super.key});

  @override
  ConsumerState<EducationInfoCollection> createState() =>
      _EducationInfoCollectionState();
}

class _EducationInfoCollectionState
    extends ConsumerState<EducationInfoCollection> {
  List<EducationInfo> educationList = [];

  @override
  void initState() {
    super.initState();
    // start with one entry
    educationList.add(EducationInfo());
  }

  Future<void> _saveOrNext(BuildContext context) async {
    final leadId =
        ref.watch(leadMangementcontroller).selectedLeadLocally?.id?.toString() ??
            "";

    await ref.read(leadMangementcontroller.notifier).updateLeadInfo(
          context: context,
          leadId: leadId,
          updatedData: LeadInfoModel(education: educationList).toJson(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Education Details",
              style: myTextstyle(fontWeight: FontWeight.bold, fontSize: 18)),
          height20,
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: educationList.length,
            itemBuilder: (context, index) {
              return _buildEducationCard(index);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    educationList.add(EducationInfo());
                  });
                },
                label: Text("Add Another Education",
                    style: myTextstyle(color: ColorConsts.primaryColor)),
                icon: Icon(Icons.add, color: ColorConsts.primaryColor),
              ),
            ],
          ),
          height20,
          PreviousAndNextButtons(
            onSavePressed: () async => _saveOrNext(context),
            onPrevPressed: () async {
            },
            onNextPressed: () async => _saveOrNext(context),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationCard(int index) {
    final edu = educationList[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubHeading(text: "High School(+2)"),
            Row(
              children: [
                Expanded(
                  child: CommonDropdown(
                    label: "Board",
                    items: boardsList,
                    value: edu.board ?? "CBSE",
                    onChanged: (val) => setState(() => edu.board = val ?? ""),
                  ),
                ),
                width20,
                Expanded(
                  child: CommonDropdown(
                    label: "Stream",
                    items: streamsList,
                    value: edu.stream ??
                        "Science – PCM (Physics, Chemistry, Maths)",
                    onChanged: (val) => setState(() => edu.stream = val ?? ""),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    text: "Passout Year",
                    controller:
                        TextEditingController(text: edu.passoutYear ?? ""),
                    onChanged: (val) => edu.passoutYear = val,
                  ),
                ),
                width20,
                Expanded(
                  child: CommonTextField(
                    text: "Percentage",
                    controller:
                        TextEditingController(text: edu.percentage ?? ""),
                    onChanged: (val) => edu.percentage = val,
                  ),
                ),
              ],
            ),
            height10,
            SubHeading(text: "Degree Details"),
            Row(
              children: [
                Expanded(
                  child: CommonDropdown(
                    label: "Discipline",
                    items: disciplines.map((e) => e.name).toList(),
                    value: edu.discipline ?? disciplines.first.name,
                    onChanged: (val) {
                      edu.discipline = val ?? '';
                      edu.specialization =
                          disciplines.where((e) => e.name == edu.discipline).first.specializations.first;
                      setState(() {});
                    },
                  ),
                ),
                width20,
                Expanded(
                  child: CommonDropdown(
                    label: "Specialization",
                    items: disciplines
                        .where((e) => e.name == (edu.discipline ?? disciplines.first.name))
                        .first
                        .specializations,
                    value: edu.specialization ??
                        disciplines
                            .where((e) => e.name == (edu.discipline ?? disciplines.first.name))
                            .first
                            .specializations
                            .first,
                    onChanged: (val) => setState(() => edu.specialization = val ?? ""),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CommonDropdown(
                    label: "Type",
                    items: ["Regular", "Distance"],
                    value: edu.typeOfStudy ?? "Regular",
                    onChanged: (val) => setState(() => edu.typeOfStudy = val ?? ""),
                  ),
                ),
                width20,
                Expanded(
                  child: CommonDropdown(
                    label: "Duration",
                    items: ["1 Year", "2 Years", "3 Years", "4 Years", "5 Years", "6 Years"],
                    value: edu.duration ?? "3 Years",
                    onChanged: (val) => setState(() => edu.duration = val ?? ""),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CommonDatePicker(
                    label: "Join Date",
                    onDateSelected: (date) => edu.joinDate =
                        DateTimeHelper.formatDateForLead(date ?? DateTime.now()),
                  ),
                ),
                width20,
                Expanded(
                  child: CommonDatePicker(
                    label: "Passout Date",
                    onDateSelected: (date) => edu.passoutDate =
                        DateTimeHelper.formatDateForLead(date ?? DateTime.now()),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    educationList.removeAt(index);
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
