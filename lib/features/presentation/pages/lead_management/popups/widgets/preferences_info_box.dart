import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/dropdown_datas/countries_list.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class PreferencesSection extends ConsumerStatefulWidget {
  const PreferencesSection({super.key});

  @override
  ConsumerState<PreferencesSection> createState() => _PreferencesSectionState();
}

class _PreferencesSectionState extends ConsumerState<PreferencesSection> {
  final interestedUniversityController = TextEditingController();

  List<String> selectedCountries = [];
  List<String> selectedIndustries = [];
  String? selectedCourse;
  String? selectedState;
  String? selectedCountry;

  final List<String> countriesList = countriesLisData;

  @override
  void initState() {
    super.initState();
    _prefillData();
  }

  /// Prefill data from the selected lead
  void _prefillData() {
    final lead = ref.read(leadMangementcontroller).selectedLead;
    if (lead?.preferences != null) {
      final prefs = lead!.preferences!;
      selectedCountry = prefs.country;
      selectedCourse = prefs.interestedCourse;
      selectedState = prefs.preferredState;
      interestedUniversityController.text = prefs.interestedUniversity ?? "";

      if (prefs.interestedIndustry != null) {
        selectedIndustries = prefs.interestedIndustry!.split(", ");
      }

      setState(() {}); // ✅ Only called after data assignment
    }
  }

  /// Build Preferences object for API update
  Preferences _getPreferences() {
    return Preferences(
      country: selectedCountry,
      interestedIndustry:
          selectedIndustries.isNotEmpty ? selectedIndustries.join(", ") : null,
      interestedCourse: selectedCourse,
      interestedUniversity:
          interestedUniversityController.text.isNotEmpty
              ? interestedUniversityController.text
              : null,
      preferredState: selectedState,
    );
  }

  /// Save / Next button logic
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
          updatedData: LeadInfoModel(preferences: _getPreferences()).toJson(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Country Dropdown
          Row(
            children: [
              CommonDropdown(
                label: "Country",
                items: countriesList,
                value: selectedCountry,
                onChanged: (value) {
                  selectedCountry = value;
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Interested Industry Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Interested Industry",
              style: myTextstyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                industries.map((industry) {
                  final isSelected = selectedIndustries.contains(industry);
                  return FilterChip(
                    label: Text(industry),
                    selected: isSelected,
                    selectedColor: ColorConsts.primaryColor.withOpacity(0.2),
                    checkmarkColor: ColorConsts.primaryColor,
                    labelStyle: myTextstyle(
                      fontSize: 14,
                      color:
                          isSelected ? ColorConsts.primaryColor : Colors.black,
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
          const SizedBox(height: 25),

          // Interested Course
          Row(
            children: [
              CommonDropdown(
                label: "Interested Course",
                items: coursesList,
                value: selectedCourse,
                onChanged: (val) {
                  selectedCourse = val;
                  setState(() {});
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

          // Preferred State
          Row(
            children: [
              CommonDropdown(
                label: "Preferred State/Province",
                items: statesList,
                value: selectedState,
                onChanged: (val) {
                  selectedState = val;
                  setState(() {});
                },
              ),
            ],
          ),
          height20,

          // Save / Prev / Next Buttons
          PreviousAndNextButtons(
            onSavePressed: () async => await _saveOrNext(context),
            onPrevPressed: () async {},
            onNextPressed: () async => await _saveOrNext(context),
          ),
        ],
      ),
    );
  }
}
