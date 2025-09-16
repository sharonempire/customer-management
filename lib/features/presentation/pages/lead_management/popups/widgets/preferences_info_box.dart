import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class PreferencesSection extends StatefulWidget {
  const PreferencesSection({super.key});

  @override
  State<PreferencesSection> createState() => _PreferencesSectionState();
}

class _PreferencesSectionState extends State<PreferencesSection> {
  final interestedUniversityController = TextEditingController();
  // Multi-select countries
  List<String> selectedCountries = [];

  // Industry selection
  final List<String> industries = [
    "IT & Software",
    "Business",
    "Engineering",
    "Healthcare",
    "Arts & Design",
    "Finance",
    "Education",
    "Hospitality",
  ];
  List<String> selectedIndustries = [];

  // Dropdown + textfields
  String? selectedCourse;
  String? selectedState;

  // Mock data
  final List<String> countriesList = [
    // 🌍 Popular outside Europe
    "United States",
    "Canada",
    "Australia",
    "New Zealand",
    "United Kingdom",
    "Singapore",
    "Japan",
    "South Korea",
    "United Arab Emirates",

    // 🇪🇺 Europe (complete list)
    "Albania",
    "Andorra",
    "Armenia",
    "Austria",
    "Azerbaijan",
    "Belarus",
    "Belgium",
    "Bosnia and Herzegovina",
    "Bulgaria",
    "Croatia",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Estonia",
    "Finland",
    "France",
    "Georgia",
    "Germany",
    "Greece",
    "Hungary",
    "Iceland",
    "Ireland",
    "Italy",
    "Kazakhstan (European part)",
    "Kosovo",
    "Latvia",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Malta",
    "Moldova",
    "Monaco",
    "Montenegro",
    "Netherlands",
    "North Macedonia",
    "Norway",
    "Poland",
    "Portugal",
    "Romania",
    "Russia (European part)",
    "San Marino",
    "Serbia",
    "Slovakia",
    "Slovenia",
    "Spain",
    "Sweden",
    "Switzerland",
    "Turkey (European part)",
    "Ukraine",
    "Vatican City",
  ];
  final List<String> coursesList = [
    "Computer Science",
    "Business Administration",
    "Engineering",
    "Medicine",
    "Design",
    "Finance",
    "Education",
  ];

  final List<String> statesList = [
    "California",
    "Ontario",
    "Bavaria",
    "Queensland",
    "London",
  ]; // 🚨 this should come from DB

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CommonDropdown(
                label: "Country",
                items: countriesList,
                onChanged: (value) {},
              ),
            ],
          ),
          const SizedBox(height: 25),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Interested Industry",
              style: myTextstyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              width20,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    industries.map((industry) {
                      final isSelected = selectedIndustries.contains(industry);
                      return FilterChip(
                        label: Text(industry),
                        selected: isSelected,
                        selectedColor: ColorConsts.primaryColor.withOpacity(
                          0.2,
                        ),
                        checkmarkColor: ColorConsts.primaryColor,
                        labelStyle: myTextstyle(
                          fontSize: 14,
                          color:
                              isSelected
                                  ? ColorConsts.primaryColor
                                  : Colors.black,
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedIndustries.add(industry);
                            } else {
                              selectedIndustries.remove(industry);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Interested Course
          Row(
            children: [
              CommonDropdown(
                label: "Interested Course",
                items: coursesList,
                value: selectedCourse,
                onChanged: (val) {
                  setState(() {
                    selectedCourse = val;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Interested Universities
          Row(
            children: [
              CommonTextField(
                controller: interestedUniversityController,
                text: "Interested Universities",
                minLines: 1,
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Preferred State / Province
          Row(
            children: [
              CommonDropdown(
                label: "Preferred State/Province",
                items: statesList,
                value: selectedState,
                onChanged: (val) {
                  setState(() {
                    selectedState = val;
                  });
                },
              ),
            ],
          ),
          height20,
          PreviousAndNextButtons(
            onSavePressed: () {},
            onPrevPressed: () {},
            onNextPressed: () {},
          ),
        ],
      ),
    );
  }
}
