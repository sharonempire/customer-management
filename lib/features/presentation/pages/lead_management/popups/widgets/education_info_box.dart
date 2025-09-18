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
  List<DegreeInfo> degreeList = [];
  EducationLevel tenthInfo = EducationLevel();
  EducationLevel plusTwoInfo = EducationLevel();

  @override
  void initState() {
    super.initState();
    // Start with one degree card
    degreeList.add(DegreeInfo());
  }

  Future<void> _saveOrNext(BuildContext context) async {
    final leadId =
        ref
            .watch(leadMangementcontroller)
            .selectedLeadLocally
            ?.id
            ?.toString() ??
        "";

    await ref
        .read(leadMangementcontroller.notifier)
        .updateLeadInfo(
          context: context,
          leadId: leadId,
          updatedData:
              LeadInfoModel(
                education: EducationData(
                  tenth: tenthInfo,
                  plusTwo: plusTwoInfo,
                  degrees: degreeList,
                ),
              ).toJson(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Education Details",
            style: myTextstyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          height20,

          // 10th Details
          _buildSchoolCard("10th Details", tenthInfo, showStream: false),
          height20,

          // +2 Details
          _buildSchoolCard("+2 Details", plusTwoInfo, showStream: true),
          height20,

          // Degree Details
          Text(
            "Degree Details",
            style: myTextstyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          height10,
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: degreeList.length,
            itemBuilder: (context, index) {
              return _buildDegreeCard(index);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {
                  setState(() => degreeList.add(DegreeInfo()));
                },
                label: Text(
                  "Add Another Degree",
                  style: myTextstyle(color: ColorConsts.primaryColor),
                ),
                icon: Icon(Icons.add, color: ColorConsts.primaryColor),
              ),
            ],
          ),
          height20,

          // Save & Next Buttons
          PreviousAndNextButtons(
            onSavePressed: () async => _saveOrNext(context),
            onPrevPressed: () async {},
            onNextPressed: () async => _saveOrNext(context),
          ),
        ],
      ),
    );
  }

  // ------------------ SCHOOL CARD (10th & +2) ------------------
  Widget _buildSchoolCard(
    String title,
    EducationLevel info, {
    bool showStream = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubHeading(text: title),
            Row(
              children: [
                Expanded(
                  child: CommonDropdown(
                    label: "Board",
                    items: boardsList,
                    value: info.board ?? "CBSE",
                    onChanged: (val) => setState(() => info.board = val ?? ""),
                  ),
                ),
                if (showStream) ...[
                  width20,
                  Expanded(
                    child: CommonDropdown(
                      label: "Stream",
                      items: streamsList,
                      value: info.stream ?? streamsList.first,
                      onChanged:
                          (val) => setState(() => info.stream = val ?? ""),
                    ),
                  ),
                ],
              ],
            ),
            height10,
            Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    text: "Passout Year",
                    controller: TextEditingController(
                      text: info.passoutYear ?? "",
                    ),
                    onChanged: (val) => info.passoutYear = val,
                  ),
                ),
                width20,
                Expanded(
                  child: CommonTextField(
                    text: "Percentage",
                    controller: TextEditingController(
                      text: info.percentage ?? "",
                    ),
                    onChanged: (val) => info.percentage = val,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ DEGREE CARD ------------------
  Widget _buildDegreeCard(int index) {
    final edu = degreeList[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SubHeading(text: "Degree ${index + 1}"),
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
                          disciplines
                              .firstWhere((e) => e.name == edu.discipline)
                              .specializations
                              .first;
                      setState(() {});
                    },
                  ),
                ),
                width20,
                Expanded(
                  child: CommonDropdown(
                    label: "Specialization",
                    items:
                        disciplines
                            .firstWhere(
                              (e) =>
                                  e.name ==
                                  (edu.discipline ?? disciplines.first.name),
                            )
                            .specializations,
                    value:
                        edu.specialization ??
                        disciplines
                            .firstWhere(
                              (e) =>
                                  e.name ==
                                  (edu.discipline ?? disciplines.first.name),
                            )
                            .specializations
                            .first,
                    onChanged:
                        (val) => setState(() => edu.specialization = val ?? ""),
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
                    onChanged:
                        (val) => setState(() => edu.typeOfStudy = val ?? ""),
                  ),
                ),
                width20,
                Expanded(
                  child: CommonDropdown(
                    label: "Duration",
                    items: [
                      "1 Year",
                      "2 Years",
                      "3 Years",
                      "4 Years",
                      "5 Years",
                      "6 Years",
                    ],
                    value: edu.duration ?? "3 Years",
                    onChanged:
                        (val) => setState(() => edu.duration = val ?? ""),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: CommonDatePicker(
                    label: "Join Date",
                    onDateSelected:
                        (date) =>
                            edu.joinDate = DateTimeHelper.formatDateForLead(
                              date ?? DateTime.now(),
                            ),
                  ),
                ),
                width20,
                Expanded(
                  child: CommonDatePicker(
                    label: "Passout Date",
                    onDateSelected:
                        (date) =>
                            edu.passoutDate = DateTimeHelper.formatDateForLead(
                              date ?? DateTime.now(),
                            ),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() => degreeList.removeAt(index));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
