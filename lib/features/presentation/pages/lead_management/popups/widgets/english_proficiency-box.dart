import 'package:flutter/material.dart';

class EnglishProficiencyBox extends StatefulWidget {
  const EnglishProficiencyBox({super.key});

  @override
  State<EnglishProficiencyBox> createState() => _EnglishProficiencyBoxState();
}

class _EnglishProficiencyBoxState extends State<EnglishProficiencyBox> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: addTest,
            icon: const Icon(Icons.add),
            label: const Text("Add English Proficiency Test"),
          ),
          const SizedBox(height: 20),

          // Dynamic Test Cards
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
                      // Header with remove button
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

                      // Dropdown to select test
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

                      // Date Picker
                      ElevatedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              studentTests[index]["date"] = date;
                            });
                          }
                        },
                        child: Text(
                          test["date"] == null
                              ? "Select Date"
                              : "Date: ${test["date"].toString().split(' ')[0]}",
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Section Scores
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

                      // Optional Upload Button
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () {
                          // File upload later
                        },
                        child: const Text("Upload Score Report (Optional)"),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
