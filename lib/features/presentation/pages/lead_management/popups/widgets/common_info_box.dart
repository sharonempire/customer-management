import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:management_software/features/application/authentification/model/user_profile_model.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_info_model.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/lead_call_history_section.dart';
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
  String? selectedMentorId;
  bool _isLoadingMentors = false;

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

    _syncWithSelectedLead();

    Future.microtask(() async {
      await _ensureMentorsLoaded();
    });
  }

  @override
  void didUpdateWidget(covariant CommonInfoBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leadId != widget.leadId) {
      _syncWithSelectedLead(shouldSetState: true);
    }
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  void _syncWithSelectedLead({bool shouldSetState = false}) {
    final leadListDetails =
        ref.read(leadMangementcontroller).selectedLeadLocally;

    final newStatus = leadListDetails?.status;
    final newFollowUp = parseCustomDate(leadListDetails?.followUp);
    final newRemarks = leadListDetails?.remark ?? '';
    final assignedProfileId =
        leadListDetails?.assignedProfile?.id?.trim() ?? '';
    final assignedToId = leadListDetails?.assignedTo?.trim() ?? '';
    final newMentorId =
        assignedProfileId.isNotEmpty
            ? assignedProfileId
            : (assignedToId.isNotEmpty ? assignedToId : null);

    if (shouldSetState && mounted) {
      setState(() {
        selectedStatus = newStatus;
        selectedFollowUpDate = newFollowUp;
        selectedMentorId = newMentorId;
      });
      remarksController.text = newRemarks;
    } else {
      selectedStatus = newStatus;
      selectedFollowUpDate = newFollowUp;
      selectedMentorId = newMentorId;
      remarksController.text = newRemarks;
    }
  }

  Future<void> _ensureMentorsLoaded() async {
    if (_isLoadingMentors) return;

    final controller = ref.read(leadMangementcontroller.notifier);
    final hasMentors = ref.read(leadMangementcontroller).counsellors.isNotEmpty;
    if (hasMentors) {
      return;
    }

    setState(() => _isLoadingMentors = true);
    try {
      await controller.fetchCounsellors(context: context);
    } finally {
      if (mounted) {
        setState(() => _isLoadingMentors = false);
      }
    }
  }

  String? _resolveMentorLabel(LeadsListModel? lead) {
    if (lead == null) return null;
    final profile = lead.assignedProfile;

    final displayName = profile?.displayName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    final email = profile?.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }

    final assignedTo = lead.assignedTo?.trim();
    if (assignedTo != null && assignedTo.isNotEmpty) {
      return assignedTo;
    }

    return null;
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
        assignedTo:
            selectedMentorId?.trim().isNotEmpty == true
                ? selectedMentorId!.trim()
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
    final leadState = ref.watch(leadMangementcontroller);
    final callHistory =
        leadState.selectedLead?.callInfo ?? const <LeadCallLog>[];
    final hasCallHistory = callHistory.isNotEmpty;
    final assignedLead = leadState.selectedLeadLocally;
    final mentors = List<UserProfileModel>.from(leadState.counsellors)
      ..sort((a, b) {
        final nameA = (a.displayName ?? a.email ?? '').toLowerCase();
        final nameB = (b.displayName ?? b.email ?? '').toLowerCase();
        return nameA.compareTo(nameB);
      });

    final fallbackMentorLabel = _resolveMentorLabel(assignedLead);

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
                  items: mentors,
                  value: selectedMentorId,
                  initialDisplayText: fallbackMentorLabel,
                  isLoading: _isLoadingMentors,
                  onTap: _ensureMentorsLoaded,
                  onChanged: (val) {
                    setState(() {
                      selectedMentorId = val?.trim();
                    });
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
            if (hasCallHistory) ...[
              height20,
              const Divider(height: 32, thickness: 0.8),
              height20,
              LeadCallHistorySection(callLogs: callHistory),
            ],
          ],
        ),
      ),
    );
  }
}

class MentorDropDown extends StatelessWidget {
  final String label;
  final List<UserProfileModel> items;
  final String? value;
  final void Function(String?) onChanged;
  final bool rounded;
  final bool isLoading;
  final String? initialDisplayText;
  final String emptyLabel;
  final Future<void> Function()? onTap;

  const MentorDropDown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    required this.onChanged,
    this.rounded = true,
    this.isLoading = false,
    this.initialDisplayText,
    this.emptyLabel = 'No mentors available',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayText = _displayText().trim();
    final hasValue = value != null && value!.trim().isNotEmpty;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: InkWell(
          onTap:
              isLoading
                  ? null
                  : () async {
                    if (onTap != null) {
                      await onTap!();
                    }
                    if (items.isEmpty) {
                      return;
                    }
                    final selected = await showSearch<UserProfileModel?>(
                      context: context,
                      delegate: _MentorSearchDelegate(
                        items: items,
                        label: label,
                        initialQuery:
                            displayText.isNotEmpty ? displayText : null,
                      ),
                    );
                    if (selected != null) {
                      final selectedId = selected.id?.trim();
                      onChanged(
                        selectedId != null && selectedId.isNotEmpty
                            ? selectedId
                            : null,
                      );
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
              suffixIcon:
                  isLoading
                      ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                      : const Icon(Icons.search),
            ),
            isEmpty: !hasValue && displayText.isEmpty,
            child: _buildContent(displayText, hasValue),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(String displayText, bool hasValue) {
    if (isLoading) {
      return Text(
        'Loading $label...',
        style: myTextstyle(fontSize: 16, color: Colors.grey.shade600),
        overflow: TextOverflow.ellipsis,
      );
    }

    if (items.isEmpty && displayText.isEmpty) {
      return Text(
        emptyLabel,
        style: myTextstyle(fontSize: 16, color: Colors.grey),
      );
    }

    final resolvedText = displayText.isNotEmpty ? displayText : label;

    return Text(
      resolvedText,
      style: myTextstyle(
        fontSize: 16,
        color: hasValue ? Colors.black : Colors.grey,
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  String _displayText() {
    final selectedProfile = _selectedProfile();
    if (selectedProfile != null) {
      return _displayNameFor(selectedProfile);
    }
    return initialDisplayText ?? '';
  }

  UserProfileModel? _selectedProfile() {
    if (value == null || value!.trim().isEmpty) {
      return null;
    }

    try {
      return items.firstWhere((element) => element.id?.trim() == value?.trim());
    } catch (_) {
      return null;
    }
  }

  static String _displayNameFor(UserProfileModel profile) {
    final name = profile.displayName?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }

    final email = profile.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }

    final phone = profile.phone?.toString();
    if (phone != null && phone.isNotEmpty) {
      return phone;
    }

    return profile.id ?? '';
  }

  static String? _secondaryLabel(UserProfileModel profile) {
    final designation = profile.designation?.trim();
    if (designation != null && designation.isNotEmpty) {
      return designation;
    }

    final status = profile.attendanceStatus?.trim();
    if (status != null && status.isNotEmpty) {
      return 'Status: $status';
    }

    return null;
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
        (q.isEmpty
              ? List<UserProfileModel>.from(items)
              : items.where((profile) {
                final name =
                    MentorDropDown._displayNameFor(profile).toLowerCase();
                final email = profile.email?.toLowerCase().trim() ?? '';
                final secondary =
                    MentorDropDown._secondaryLabel(profile)?.toLowerCase() ??
                    '';
                return name.contains(q) ||
                    email.contains(q) ||
                    secondary.contains(q);
              }).toList())
          ..sort(
            (a, b) => MentorDropDown._displayNameFor(a).toLowerCase().compareTo(
              MentorDropDown._displayNameFor(b).toLowerCase(),
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
        final title = MentorDropDown._displayNameFor(item);
        final subtitleParts = <String>[];

        final attendance = item.attendanceStatus?.trim();
        if (attendance != null && attendance.isNotEmpty) {
          subtitleParts.add(attendance);
        }

        final secondary = MentorDropDown._secondaryLabel(item);
        if (secondary != null && secondary.isNotEmpty) {
          subtitleParts.add(secondary);
        }

        return ListTile(
          title: Text(title),
          subtitle:
              subtitleParts.isEmpty ? null : Text(subtitleParts.join(' • ')),
          onTap: () => close(context, item),
        );
      },
    );
  }
}
