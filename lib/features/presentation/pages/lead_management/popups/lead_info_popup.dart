import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/basic_info_box.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/education_info_collection.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

import '../widgets/info_pregression_Icons.dart';

class LeadInfoPopup extends StatefulWidget {
  const LeadInfoPopup({super.key});

  @override
  State<LeadInfoPopup> createState() => _LeadInfoPopupState();
}

class _LeadInfoPopupState extends State<LeadInfoPopup> {
  int progressedIndex = 2;
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
                      InfoProgressionIcons(progressedIndex: progressedIndex),
                      height30,
                      LeadInfoSubtitles(progressionIndex: progressedIndex),
                      height30,
                      if (progressedIndex == 0)
                        BasicInfoCollection()
                      else if (progressedIndex == 1)
                        EducationInfoCollection()
                      else if (progressedIndex == 2)
                        WorkExperienceInfo(),
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

class WorkExperienceInfo extends StatefulWidget {
  const WorkExperienceInfo({super.key});

  @override
  State<WorkExperienceInfo> createState() => _WorkExperienceInfoState();
}

class _WorkExperienceInfoState extends State<WorkExperienceInfo> {
  bool haveWorkExperience = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45),
      child: Column(
        children: [
          Row(
            children: [
              CommonSwitch(
                text: "Work experience",
                onChanged: (val) {
                  haveWorkExperience = val;
                  setState(() {});
                },
              ),
            ],
          ),
          height20,
        ],
      ),
    );
  }
}

class SubHeading extends StatelessWidget {
  final String text;
  const SubHeading({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22.0),
      child: Text(text, style: myTextstyle(fontSize: 20, color: Colors.black)),
    );
  }
}

class CommonSwitch extends StatefulWidget {
  final String text;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const CommonSwitch({
    super.key,
    required this.text,
    this.initialValue = false,
    required this.onChanged,
  });

  @override
  State<CommonSwitch> createState() => _CommonSwitchState();
}

class _CommonSwitchState extends State<CommonSwitch> {
  late bool value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.text,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Switch(
                value: value,
                activeColor: Colors.white,
                activeTrackColor: Colors.grey,
                onChanged: (val) {
                  setState(() => value = val);
                  widget.onChanged(val);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CommonInfoBox extends StatelessWidget {
  const CommonInfoBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 235, 239, 246),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CommonDropdown(
                  label: 'Status',
                  items: ["Lead Created", "Lead Converted", "Course sent"],
                  onChanged: (val) {},
                ),
                width20,
                CommonDatePicker(label: "Follow Up Date"),
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
    if (items.length <= 10) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: DropdownButtonFormField<String>(
            hint: Text(
              label,
              style: myTextstyle(color: Colors.grey, fontSize: 18),
            ),
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

    // ✅ If more than 10 items → searchable
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: InkWell(
          onTap: () async {
            final selected = await showSearch<String?>(
              context: context,
              delegate: _StringSearchDelegate(
                items: items,
                label: label,
                initialQuery: value ?? '',
              ),
            );
            if (selected != null) {
              onChanged(selected);
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: InputDecorator(
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
              suffixIcon: const Icon(Icons.search),
            ),
            isEmpty: value == null || value!.isEmpty,
            child: Text(
              value?.trim().isNotEmpty == true ? value! : label,
              style: myTextstyle(
                fontSize: 16,
                color:
                    (value == null || value!.isEmpty)
                        ? Colors.grey
                        : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Minimal SearchDelegate for picking a String from a list with filtering.
class _StringSearchDelegate extends SearchDelegate<String?> {
  final List<String> items;
  final String label;

  _StringSearchDelegate({
    required this.items,
    required this.label,
    String? initialQuery,
  }) : super(
         searchFieldLabel: 'Search $label...',
         textInputAction: TextInputAction.search,
       ) {
    query = initialQuery ?? '';
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
          tooltip: 'Clear',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
      tooltip: 'Back',
    );
  }

  @override
  Widget buildResults(BuildContext context) => _buildList(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final q = query.toLowerCase().trim();
    final filtered =
        (q.isEmpty)
            ? items
            : items.where((e) => e.toLowerCase().contains(q)).toList();

    // Optional: sort alphabetically when filtered
    filtered.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text('No results for "$query"'),
        ),
      );
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final item = filtered[i];
        return ListTile(title: Text(item), onTap: () => close(context, item));
      },
    );
  }
}
