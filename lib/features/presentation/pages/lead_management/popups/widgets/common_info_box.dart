import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
  bool isCounsellorLoading = false;
  String? counsellorError;
  List<UserProfileModel> counsellors = const [];
  String? selectedCounsellorId;

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
    isCounsellorLoading = true;

    Future.microtask(_initialiseData);
  }

  Future<void> _initialiseData() async {
    _hydrateLeadDetails();
    await _loadCounsellors();
  }

  void _hydrateLeadDetails() {
    final leadState = ref.read(leadMangementcontroller);
    final leadListDetails = leadState.selectedLeadLocally;

    final initialStatus = leadListDetails?.status;
    final initialFollowUp = parseCustomDate(leadListDetails?.followUp);
    final initialRemarks = leadListDetails?.remark ?? "";
    final initialCounsellorId = _normaliseCounsellorId(leadListDetails?.assignedTo);

    remarksController.text = initialRemarks;

    if (!mounted) return;

    setState(() {
      selectedStatus = initialStatus;
      selectedFollowUpDate = initialFollowUp;
      selectedCounsellorId = initialCounsellorId;
    });
  }

  Future<void> _loadCounsellors({bool forceRefresh = false}) async {
    if (!mounted) return;

    setState(() {
      isCounsellorLoading = true;
      counsellorError = null;
    });

    final controller = ref.read(leadMangementcontroller.notifier);
    final assignedProfile =
        ref.read(leadMangementcontroller).selectedLeadLocally?.assignedProfile;

    List<UserProfileModel> mergedCounsellors = counsellors;
    String? errorMessage;
    String? updatedSelectedId = _normaliseCounsellorId(selectedCounsellorId);

    try {
      final fetched = await controller.fetchCounsellors(
        context: context,
        forceRefresh: forceRefresh,
      );

      mergedCounsellors = _mergeCounsellors(
        fetched,
        assignedProfile,
      );

      final fallbackId = _normaliseCounsellorId(assignedProfile?.id);

      if (updatedSelectedId == null) {
        updatedSelectedId = fallbackId;
      } else if (!mergedCounsellors
          .any((profile) => profile.id == updatedSelectedId)) {
        updatedSelectedId = fallbackId ?? updatedSelectedId;
      }
    } catch (e, st) {
      debugPrint('Failed to load counsellors: $e\n$st');
      errorMessage = 'Failed to load counsellors';
    }

    if (!mounted) return;

    setState(() {
      counsellors = mergedCounsellors;
      selectedCounsellorId = updatedSelectedId;
      counsellorError = errorMessage;
      isCounsellorLoading = false;
    });
  }

  List<UserProfileModel> _mergeCounsellors(
    List<UserProfileModel> fetched,
    UserProfileModel? assignedProfile,
  ) {
    final uniqueProfiles = <String, UserProfileModel>{};

    for (final profile in fetched) {
      final id = _normaliseCounsellorId(profile.id);
      if (id == null) continue;
      uniqueProfiles[id] = profile;
    }

    final assignedId = _normaliseCounsellorId(assignedProfile?.id);
    if (assignedProfile != null && assignedId != null) {
      uniqueProfiles.putIfAbsent(assignedId, () => assignedProfile);
    }

    final results = uniqueProfiles.values.toList()
      ..sort(
        (a, b) => _counsellorTitle(a)
            .toLowerCase()
            .compareTo(_counsellorTitle(b).toLowerCase()),
      );

    return results;
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
        assignedTo: _normaliseCounsellorId(selectedCounsellorId),
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
            LeadCounsellorSection(
              isLoading: isCounsellorLoading,
              errorText: counsellorError,
              counsellors: counsellors,
              selectedId: selectedCounsellorId,
              onChanged: (value) {
                setState(() {
                  selectedCounsellorId = _normaliseCounsellorId(value);
                });
              },
              onRefresh: () => _loadCounsellors(forceRefresh: true),
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

class LeadCounsellorSection extends StatelessWidget {
  final bool isLoading;
  final String? errorText;
  final List<UserProfileModel> counsellors;
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  final VoidCallback onRefresh;

  const LeadCounsellorSection({
    super.key,
    required this.isLoading,
    required this.errorText,
    required this.counsellors,
    required this.selectedId,
    required this.onChanged,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _CounsellorLoadingRow();
    }

    final hasError = errorText != null && errorText!.isNotEmpty;
    final hasCounsellors = counsellors.isNotEmpty;

    final dropdownRow = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: LeadCounsellorDropdown(
            counsellors: counsellors,
            selectedId: _normaliseCounsellorId(selectedId),
            onChanged: onChanged,
          ),
        ),
        width10,
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh counsellors',
          ),
        ),
      ],
    );

    if (hasError && !hasCounsellors) {
      return _CounsellorMessageRow(
        icon: Icons.error_outline,
        message: errorText!,
        onRefresh: onRefresh,
      );
    }

    if (!hasCounsellors) {
      return _CounsellorMessageRow(
        icon: Icons.info_outline,
        message: 'No counsellors available',
        onRefresh: onRefresh,
      );
    }

    if (hasError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CounsellorMessageRow(
            icon: Icons.error_outline,
            message: errorText!,
            onRefresh: onRefresh,
          ),
          height10,
          dropdownRow,
        ],
      );
    }

    return dropdownRow;
  }
}

class LeadCounsellorDropdown extends StatelessWidget {
  final List<UserProfileModel> counsellors;
  final String? selectedId;
  final ValueChanged<String?> onChanged;

  const LeadCounsellorDropdown({
    super.key,
    required this.counsellors,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dropdownItems = <DropdownMenuItem<String?>>[
      const DropdownMenuItem<String?>(
        value: null,
        child: _CounsellorMenuTile(
          title: 'Unassigned',
          subtitle: 'No counsellor assigned',
        ),
      ),
      ...counsellors.map(
        (profile) => DropdownMenuItem<String?>(
          value: _normaliseCounsellorId(profile.id),
          child: _CounsellorMenuTile(
            title: _counsellorTitle(profile),
            subtitle: _counsellorSubtitle(profile),
          ),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: DropdownButtonFormField<String?>(
        value: _normaliseCounsellorId(selectedId),
        isExpanded: true,
        items: dropdownItems,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: 'Assigned Counsellor',
          labelStyle: myTextstyle(color: Colors.grey, fontSize: 16),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
        selectedItemBuilder: (context) => [
          const _SelectedCounsellorLabel(
            title: 'Unassigned',
            subtitle: 'No counsellor assigned',
          ),
          ...counsellors.map(
            (profile) => _SelectedCounsellorLabel(
              title: _counsellorTitle(profile),
              subtitle: _counsellorSubtitle(profile),
            ),
          ),
        ],
      ),
    );
  }
}

class _CounsellorMenuTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _CounsellorMenuTile({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: myTextstyle(fontSize: 16, color: Colors.black),
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            style: myTextstyle(fontSize: 14, color: Colors.grey.shade600),
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }
}

class _SelectedCounsellorLabel extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SelectedCounsellorLabel({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: myTextstyle(fontSize: 16, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle.isNotEmpty)
            Text(
              subtitle,
              style: myTextstyle(fontSize: 13, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }
}

class _CounsellorMessageRow extends StatelessWidget {
  final IconData icon;
  final String message;
  final VoidCallback onRefresh;

  const _CounsellorMessageRow({
    required this.icon,
    required this.message,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600),
          width10,
          Expanded(
            child: Text(
              message,
              style: myTextstyle(color: Colors.grey.shade700, fontSize: 16),
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh counsellors',
          ),
        ],
      ),
    );
  }
}

class _CounsellorLoadingRow extends StatelessWidget {
  const _CounsellorLoadingRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          width10,
          Expanded(
            child: Text(
              'Loading counsellors…',
              style: myTextstyle(color: Colors.grey.shade700, fontSize: 16),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

String? _normaliseCounsellorId(String? id) {
  final trimmed = id?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

String _counsellorTitle(UserProfileModel profile) {
  final displayName = profile.displayName?.trim();
  if (displayName != null && displayName.isNotEmpty) {
    return displayName;
  }

  final email = profile.email?.trim();
  if (email != null && email.isNotEmpty) {
    return email;
  }

  final id = profile.id?.trim();
  if (id != null && id.isNotEmpty) {
    return id;
  }

  return 'Unknown Counsellor';
}

String _counsellorSubtitle(UserProfileModel profile) {
  final metadata = <String>[];

  final designation = profile.designation?.trim();
  if (designation != null && designation.isNotEmpty) {
    metadata.add(designation);
  }

  final attendance = profile.attendanceStatus?.trim();
  if (attendance != null && attendance.isNotEmpty) {
    metadata.add('Attendance: $attendance');
  } else {
    metadata.add('Attendance: Not marked');
  }

  if (metadata.isNotEmpty) {
    return metadata.join(' • ');
  }

  final email = profile.email?.trim();
  if (email != null && email.isNotEmpty) {
    return email;
  }

  return '';
}
