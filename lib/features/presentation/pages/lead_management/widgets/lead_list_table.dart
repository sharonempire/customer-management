import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_details.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class LeadListTable extends ConsumerWidget {
  const LeadListTable({
    super.key,
    required this.leads,
    this.rowBackgroundColor,
    this.followUpTextBuilder,
    this.remarkTextBuilder,
    this.followUpHeaderLabel = 'Follow-up Date',
    this.remarkHeaderLabel = 'Remark',
  });

  final List<LeadsListModel> leads;
  final Color? rowBackgroundColor;
  final String Function(LeadsListModel lead)? followUpTextBuilder;
  final String Function(LeadsListModel lead)? remarkTextBuilder;
  final String followUpHeaderLabel;
  final String remarkHeaderLabel;

  Future<void> _showLeadDetails(
    BuildContext context,
    WidgetRef ref,
    LeadsListModel lead,
  ) async {
    await ref
        .read(leadMangementcontroller.notifier)
        .setLeadLocally(lead, context);

    showDialog(
      context: context,
      builder: (_) => const LeaadDetailsPopup(),
    );
  }

  String _formatFollowUp(LeadsListModel lead) {
    final followUp = lead.followUp;
    if (followUp == null || followUp.isEmpty) {
      return '';
    }

    final parsed = DateTimeHelper.parseDate(followUp);
    if (parsed != null) {
      return DateTimeHelper.formatDateForLead(parsed);
    }

    return followUp;
  }

  TableRow _buildRow(BuildContext context, LeadsListModel lead, WidgetRef ref) {
    final assignedStaff =
        (lead.assignedProfile?.displayName?.isNotEmpty ?? false)
            ? lead.assignedProfile!.displayName!
            : lead.assignedProfile?.email ?? lead.assignedTo ?? '';
    final followUpText =
        followUpTextBuilder?.call(lead) ?? _formatFollowUp(lead);
    final remarkText = remarkTextBuilder?.call(lead) ?? (lead.remark ?? '');

    return TableRow(
      decoration:
          rowBackgroundColor != null
              ? BoxDecoration(color: rowBackgroundColor)
              : null,
      children: [
        _clickableCell(
          context,
          ref,
          lead,
          lead.slNo?.toString().padLeft(4, '0') ?? '',
        ),
        _clickableCell(context, ref, lead, lead.name ?? ''),
        _clickableCell(context, ref, lead, lead.freelancerManager ?? ''),
        _clickableCell(context, ref, lead, lead.freelancer ?? ''),
        _clickableCell(context, ref, lead, lead.source ?? ''),
        _clickableCell(context, ref, lead, lead.phone?.toString() ?? ''),
        _clickableCell(context, ref, lead, lead.status ?? ''),
        _clickableCell(context, ref, lead, followUpText),
        _clickableCell(context, ref, lead, remarkText),
        _clickableCell(context, ref, lead, assignedStaff),
        _actionCell(
          context,
          label: 'Edit',
          onTap: () async {
            await ref
                .read(leadMangementcontroller.notifier)
                .setLeadLocally(lead, context);
            context.go(
              '${RouterConsts().enquiries.route}/${RouterConsts().leadInfo.route}',
            );
          },
        ),
      ],
    );
  }

  Widget _clickableCell(
    BuildContext context,
    WidgetRef ref,
    LeadsListModel lead,
    String text,
  ) {
    return InkWell(
      onTap: () => _showLeadDetails(context, ref, lead),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text, style: myTextstyle(fontSize: 13)),
      ),
    );
  }

  Widget _actionCell(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            textStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  TableRow _headerRow() {
    final headers = [
      'Sl no',
      'Lead Name',
      'Freelancer Manager',
      'Freelancer',
      'Source',
      'Phone',
      'Status',
      followUpHeaderLabel,
      remarkHeaderLabel,
      'Assigned Staff',
      'Action',
    ];

    return TableRow(
      decoration: BoxDecoration(color: Colors.grey.shade100),
      children: [
        for (final header in headers)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              header,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (leads.isEmpty) {
      return const Center(
        child: Text('No leads available for the selected filters.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(1.5),
          5: FlexColumnWidth(2),
          6: FlexColumnWidth(1.5),
          7: FlexColumnWidth(2),
          8: FlexColumnWidth(3),
          9: FlexColumnWidth(2),
          10: FlexColumnWidth(2),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        children: [
          _headerRow(),
          for (final lead in leads) _buildRow(context, lead, ref),
        ],
      ),
    );
  }
}
