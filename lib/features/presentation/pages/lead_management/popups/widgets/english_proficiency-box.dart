import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/date_time_helper.dart';

class EnglishProficiencyBox extends ConsumerStatefulWidget {
  const EnglishProficiencyBox({super.key});

  @override
  ConsumerState<EnglishProficiencyBox> createState() =>
      _EnglishProficiencyBoxState();
}

class _EnglishProficiencyBoxState extends ConsumerState<EnglishProficiencyBox> {
  final List<String> tests = [
    "IELTS",
    "TOEFL",
    "PTE",
    "Duolingo",
    "Cambridge English",
    "TOEIC",
    "CELPIP",
  ];

  final Map<String, List<String>> testSections = {
    "IELTS": ["Listening", "Reading", "Writing", "Speaking"],
    "TOEFL": ["Reading", "Listening", "Speaking", "Writing"],
    "PTE": ["Reading", "Listening", "Speaking", "Writing"],
    "Duolingo": ["Overall Score"],
    "Cambridge English": [
      "Reading",
      "Listening",
      "Writing",
      "Speaking",
      "Use of English",
    ],
    "TOEIC": ["Listening", "Reading"],
    "CELPIP": ["Listening", "Reading", "Writing", "Speaking"],
  };

  // Each test entry: {testType, date, scores}
  List<Map<String, dynamic>> studentTests = [];

  void addTest() {
    setState(() {
      studentTests.add({"testType": null, "date": null, "scores": {}});
    });
  }

  void removeTest(int index) {
    setState(() {
      studentTests.removeAt(index);
    });
  }

  Future<void> _saveOrNext(BuildContext context) async {
    final leadId =
        ref
            .watch(leadMangementcontroller)
            .selectedLeadLocally
            ?.id
            ?.toString() ??
        "";

    // Convert studentTests into Map<String, List<String>> for model
    final Map<String, List<String>> testsMap = {};
    for (var test in studentTests) {
      final testName = test["testType"];
      if (testName != null) {
        final scores = <String>[];
        test["scores"].forEach((section, score) {
          if (score != null && score.toString().trim().isNotEmpty) {
            scores.add("$section: $score");
          }
        });
        if (scores.isNotEmpty) {
          testsMap[testName] = scores;
        }
      }
    }

    final proficiency = EnglishProficiency(tests: testsMap);

    await ref
        .read(leadMangementcontroller.notifier)
        .updateLeadInfo(
          context: context,
          leadId: leadId,
          updatedData: LeadInfoModel(englishProficiency: proficiency).toJson(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PrimaryButton(
                onpressed: addTest,
                text: "Add English Proficiency Test",
              ),
            ],
          ),
          height30,
          Column(
            children: List.generate(studentTests.length, (index) {
              final test = studentTests[index];
              final selectedTest = test["testType"];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "English Proficiency Test",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => removeTest(index),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedTest,
                        decoration: const InputDecoration(
                          labelText: "Select Test",
                          border: OutlineInputBorder(),
                        ),
                        items:
                            tests
                                .map(
                                  (t) => DropdownMenuItem(
                                    value: t,
                                    child: Text(t),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            studentTests[index]["testType"] = value;
                            studentTests[index]["scores"] = {};
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          CommonDatePicker(
                            label: "Test date",
                            onDateSelected: (date) {
                              setState(() {
                                studentTests[index]["date"] =
                                    DateTimeHelper.formatDateForLead(
                                      date ?? DateTime.now(),
                                    );
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      if (selectedTest != null)
                        Column(
                          children:
                              testSections[selectedTest]!
                                  .map(
                                    (section) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: "$section Score",
                                          border: const OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (val) {
                                          studentTests[index]["scores"][section] =
                                              val;
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                        ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("Upload Score Report (Optional)"),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          height20,
          PreviousAndNextButtons(
            onSavePressed: () async => _saveOrNext(context),
            onPrevPressed: () async {
              // handle previous navigation if needed
            },
            onNextPressed: () async => _saveOrNext(context),
          ),
        ],
      ),
    );
  }
}
