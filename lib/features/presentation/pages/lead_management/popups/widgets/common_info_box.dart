import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_picker.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/lead_counsellor_section.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart' show PrimaryButton;
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

  final List<String> statusOptions = const [
    'Lead creation',
    'Lead Converted',
    'Course sent',
  ];

  DateTime? parseCustomDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      final dateFormat = DateFormat('MMMM d, yyyy');
      return dateFormat.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    remarksController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _hydrateLeadDetails();
      ref
          .read(leadMangementcontroller.notifier)
          .loadCounsellors(context: context);
    });
  }

  void _hydrateLeadDetails() {
    final leadState = ref.read(leadMangementcontroller);
    final leadListDetails = leadState.selectedLeadLocally;

    final initialStatus = leadListDetails?.status;
    final initialFollowUp = parseCustomDate(leadListDetails?.followUp);
    final initialRemarks = leadListDetails?.remark ?? '';

    remarksController.text = initialRemarks;

    setState(() {
      selectedStatus = initialStatus;
      selectedFollowUpDate = initialFollowUp;
    });

    if (leadState.selectedCounsellorId == null &&
        leadListDetails?.assignedTo != null) {
      ref
          .read(leadMangementcontroller.notifier)
          .selectCounsellor(leadListDetails?.assignedTo);
    }
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  Future<void> _saveDetails(BuildContext context) async {
    try {
      final leadId = widget.leadId;
      if (leadId.isEmpty) return;

      final leadState = ref.read(leadMangementcontroller);
      final updatedData = LeadsListModel(
        status: selectedStatus,
        remark:
            remarksController.text.trim().isNotEmpty ? remarksController.text.trim() : null,
        assignedTo: leadState.selectedCounsellorId,
        followUp: selectedFollowUpDate != null
            ? DateTimeHelper.formatDateForLead(selectedFollowUpDate!)
            : null,
      );

      await ref
          .read(leadMangementcontroller.notifier)
          .updateListDetails(
            context: context,
            leadId: leadId,
            updatedData: updatedData,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lead details updated successfully')),
        );
      }
    } catch (e, st) {
      debugPrint('Error updating lead details: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final leadState = ref.watch(leadMangementcontroller);
    final controller = ref.read(leadMangementcontroller.notifier);

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
                  label: 'Follow Up Date',
                  initialDate: selectedFollowUpDate != null
                      ? DateTimeHelper.formatDateForLead(selectedFollowUpDate!)
                      : null,
                  onDateSelected: (date) {
                    setState(() => selectedFollowUpDate = date);
                  },
                ),
              ],
            ),
            height10,
            LeadCounsellorSection(
              isLoading: leadState.isLoadingCounsellors,
              errorText: leadState.counsellorError,
              counsellors: leadState.counsellors,
              selectedId: leadState.selectedCounsellorId,
              onChanged: controller.selectCounsellor,
              onRefresh: () {
                controller.loadCounsellors(
                  context: context,
                  forceRefresh: true,
                );
              },
            ),
            height20,
            Row(
              children: [
                width20,
                Text(
                  'Counsellor Remarks',
                  style: myTextstyle(
                    fontSize: 18,
                    color: ColorConsts.textColor,
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonTextField(
                  controller: remarksController,
                  text:
                      'Enter any additional remarks, notes, or special considerations...',
                  maxLines: 5,
                ),
                const Spacer(),
                PrimaryButton(
                  onpressed: () async {
                    await _saveDetails(context);
                  },
                  text: 'Save',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
