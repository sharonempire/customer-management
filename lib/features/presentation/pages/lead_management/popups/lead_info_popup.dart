import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

import '../widgets/info_pregression_Icons.dart';

class LeadInfoPopup extends StatelessWidget {
  const LeadInfoPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CommonAppbar(title: "Lead Info"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorConsts.activeColor,
                      width: .5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  width: double.infinity,
                  child: Column(
                    children: [
                      height10,
                      InfoProgressionIcons(progressedIndex: 0),
                      height30,
                      LeadInfoSubtitles(progressionIndex: 0),
                      height30,
                      Padding(
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
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                padding: EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color.fromARGB(
                                    255,
                                    235,
                                    239,
                                    246,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CommonDropdown(
                                          label: 'Status',
                                          items: [
                                            "Lead Created",
                                            "Lead Converted",
                                            "Course sent",
                                          ],
                                          onChanged: (val) {},
                                        ),
                                        width20,
                                        CommonDatePicker(
                                          label: "Follow Up Date",
                                        ),
                                      ],
                                    ),
                                    height30,
                                    Row(
                                      children: [
                                        width20,
                                        Text(
                                          "Counsellor Remarks",
                                          style: myTextstyle(
                                            fontSize: 18,
                                            color: ColorConsts.textColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        CommonTextField(
                                          minLines: 5,
                                          text:
                                              "Enter any additional remarks, notes, or special considerations...",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
                                      Text(
                                        "Previous",
                                        style: myTextstyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Save",
                                    style: myTextstyle(fontSize: 16),
                                  ),
                                ),
                                width30,
                                PrimaryButton(onpressed: () {}, text: "Next"),
                                width10,
                              ],
                            ),
                            height20,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CommonTextField extends StatelessWidget {
  final String text;
  final int? minLines;
  const CommonTextField({super.key, required this.text, this.minLines});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          maxLines: minLines,
          decoration: InputDecoration(
            label: Text(
              text,
              style: myTextstyle(color: Colors.grey, fontSize: 18),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
        ),
      ),
    );
  }
}

class LeadInfoSubtitles extends StatelessWidget {
  final int progressionIndex;
  const LeadInfoSubtitles({super.key, required this.progressionIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        width30,
        width30,
        width10,
        Text(
          progressionIndex == 0
              ? "Step 1: Basic Info"
              : progressionIndex == 1
              ? "Step 2: Education"
              : progressionIndex == 2
              ? "Step 3: Work Experience"
              : progressionIndex == 3
              ? "Step 4: Budget Info"
              : progressionIndex == 4
              ? "Step 5: Preferences"
              : progressionIndex == 5
              ? "Step 6: English Proficiency"
              : "",
          style: myTextstyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class CommonDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? value;
  final void Function(String?) onChanged;

  const CommonDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            label: Text(
              label,
              style: myTextstyle(color: Colors.grey, fontSize: 18),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          items:
              items
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, style: myTextstyle(fontSize: 16)),
                    ),
                  )
                  .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class CommonDatePicker extends StatefulWidget {
  final String label;
  const CommonDatePicker({super.key, required this.label});

  @override
  State<CommonDatePicker> createState() => _CommonDatePickerState();
}

class _CommonDatePickerState extends State<CommonDatePicker> {
  DateTime? selectedDate;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          controller: _controller,
          readOnly: true, // prevent typing
          decoration: InputDecoration(
            label: Text(
              widget.label,
              style: myTextstyle(color: Colors.grey, fontSize: 18),
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                selectedDate = picked;
                _controller.text =
                    "${picked.day}/${picked.month}/${picked.year}";
              });
            }
          },
        ),
      ),
    );
  }
}
