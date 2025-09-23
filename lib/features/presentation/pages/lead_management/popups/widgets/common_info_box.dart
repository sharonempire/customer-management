import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:management_software/features/application/attendance/controller/attendance_controller.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart'
    show PrimaryButton;
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class CommonInfoBox extends ConsumerStatefulWidget {
  final String leadId;

  const CommonInfoBox({super.key, required this.leadId});

  @override
  ConsumerState<CommonInfoBox> createState() => _CommonInfoBoxState();
}

class _CommonInfoBoxState extends ConsumerState<CommonInfoBox> {
  late TextEditingController remarksController;
  String? selectedStatus;
  DateTime? selectedFollowUpDate;

  final List<String> statusOptions = [
    "Lead creation",
    "Lead Converted",
    "Course sent",
  ];

  DateTime? parseCustomDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      // Format for "September 19, 2025"
      final dateFormat = DateFormat("MMMM d, yyyy");
      return dateFormat.parse(dateString);
    } catch (e) {
      print("Date parsing error: $e");
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    remarksController = TextEditingController();

    Future.microtask(() async {
      final leadListDetails =
          ref.watch(leadMangementcontroller).selectedLeadLocally;
      if (leadListDetails != null) {
        selectedStatus = leadListDetails.status;
        selectedFollowUpDate = parseCustomDate(leadListDetails.followUp);
        remarksController.text = leadListDetails.remark ?? "";
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  Future<void> _saveDetails(BuildContext context, WidgetRef ref) async {
    try {
      final leadId = widget.leadId;
      if (leadId.isEmpty) return;
      final updatedData = LeadsListModel(
        status: selectedStatus,
        remark:
            remarksController.text.trim().isNotEmpty
                ? remarksController.text.trim()
                : null,
        followUp:
            selectedFollowUpDate != null
                ? DateTimeHelper.formatDateForLead(selectedFollowUpDate!)
                : null,
      );

      // Call update API
      await ref
          .read(leadMangementcontroller.notifier)
          .updateListDetails(
            context: context,
            leadId: leadId,
            updatedData: updatedData,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Lead details updated successfully")),
        );
      }
    } catch (e, st) {
      debugPrint("Error updating lead details: $e\n$st");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Failed to update: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromARGB(255, 235, 239, 246),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status + FollowUp Row
            Row(
              children: [
                CommonDropdown(
                  label: 'Status',
                  items: statusOptions,
                  value: selectedStatus,
                  onChanged: (val) {
                    setState(() => selectedStatus = val);
                  },
                ),
                width20,
                CommonDatePicker(
                  label: "Follow Up Date",
                  initialDate:
                      selectedFollowUpDate != null
                          ? DateTimeHelper.formatDateForLead(
                            selectedFollowUpDate!,
                          )
                          : null,
                  onDateSelected: (date) {
                    setState(() => selectedFollowUpDate = date);
                  },
                ),
              ],
            ),
            height10,
            Row(
              children: [
                MentorDropDown(
                  label: 'Mentor change',
                  items:
                      ref
                          .read(attendanceServiceProvider)
                          .allEmployeesAttendance!
                          .where((attendance) {
                            return attendance.attendanceStatus == "Present";
                          })
                          .toList()
                          .map((e) => e.profile ?? UserProfileModel())
                          .toList(),
                  value:
                      ref
                          .watch(leadMangementcontroller)
                          .selectedLeadLocally
                          ?.assignedProfile
                          ?.id
                          .toString(),
                  onChanged: (val) {
                    setState(() => selectedStatus = val);
                  },
                ),
              ],
            ),
            height20,
            // Remarks Title
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
            // Remarks Field + Save Button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextField(
                  controller: remarksController,
                  text:
                      "Enter any additional remarks, notes, or special considerations...",
                  maxLines: 5,
                ),
                const Spacer(),
                Consumer(
                  builder: (context, ref, _) {
                    return PrimaryButton(
                      onpressed: () async {
                        await _saveDetails(context, ref);
                      },
                      text: "Save",
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MentorDropDown extends StatelessWidget {
  final String label;
  final List<UserProfileModel> items;

  /// selected mentor id
  final String? value;

  /// returns the selected mentor id
  final void Function(String?) onChanged;
  final bool rounded;

  const MentorDropDown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    required this.onChanged,
    this.rounded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: InkWell(
          onTap: () async {
            // show search using display name, but return the id
            final selected = await showSearch<UserProfileModel?>(
              context: context,
              delegate: _MentorSearchDelegate(
                items: items,
                label: label,
                initialQuery: _initialDisplayName(),
              ),
            );
            if (selected != null) {
              onChanged(selected.id); // <-- pass back the mentor's id
            }
          },
          borderRadius: BorderRadius.circular(rounded ? 10 : 0),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: myTextstyle(color: Colors.grey, fontSize: 16),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(rounded ? 10 : 0),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(rounded ? 10 : 0),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(rounded ? 10 : 0),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              suffixIcon: const Icon(Icons.search),
            ),
            isEmpty: value == null || value!.isEmpty,
            child: Text(
              _selectedDisplayName() ?? label,
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

  String? _initialDisplayName() {
    final match = items.firstWhere(
      (e) => e.id == value,
      orElse: () => UserProfileModel(),
    );

    return match.id?.toString() ?? "";
  }

  String? _selectedDisplayName() {
    try {
      return items.firstWhere((e) => e.id == value).displayName;
    } catch (_) {
      return null;
    }
  }
}

/// Custom SearchDelegate for mentors
class _MentorSearchDelegate extends SearchDelegate<UserProfileModel?> {
  final List<UserProfileModel> items;
  final String label;

  _MentorSearchDelegate({
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
  List<Widget>? buildActions(BuildContext context) => [
    if (query.isNotEmpty)
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
        tooltip: 'Clear',
      ),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null),
    tooltip: 'Back',
  );

  @override
  Widget buildResults(BuildContext context) => _buildList(context);
  @override
  Widget buildSuggestions(BuildContext context) => _buildList(context);

  Widget _buildList(BuildContext context) {
    final q = query.toLowerCase().trim();
    final filtered =
        q.isEmpty
              ? items
              : items
                  .where((e) => e.displayName!.toLowerCase().contains(q))
                  .toList()
          ..sort(
            (a, b) => a.displayName!.toLowerCase().compareTo(
              b.displayName!.toLowerCase(),
            ),
          );

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
        return ListTile(
          title: Text(item.displayName ?? ''),
          onTap: () => close(context, item),
        );
      },
    );
  }
}
