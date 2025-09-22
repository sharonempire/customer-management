import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
                CommonDropdown(
                  label: 'Status',
                  items: statusOptions,
                  value: selectedStatus,
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
