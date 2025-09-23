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
  const LeadListTable({super.key, required this.leads});

  final List<LeadsListModel> leads;

  void _showLeadDetails(BuildContext context, LeadsListModel lead) {
    showDialog(
      context: context,
      builder: (context) => LeaadDetailsPopup(context: context),
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

  TableRow _buildRow(
    BuildContext context,
    LeadsListModel lead,
    WidgetRef ref,
  ) {
    final assignedStaff =
        (lead.assignedProfile?.displayName?.isNotEmpty ?? false)
            ? lead.assignedProfile!.displayName!
            : lead.assignedProfile?.email ?? lead.assignedTo ?? '';

    return TableRow(
      children: [
        _clickableCell(context, lead, lead.slNo?.toString().padLeft(4, '0') ?? ''),
        _clickableCell(context, lead, lead.name ?? ''),
        _clickableCell(context, lead, lead.freelancerManager ?? ''),
        _clickableCell(context, lead, lead.freelancer ?? ''),
        _clickableCell(context, lead, lead.source ?? ''),
        _clickableCell(context, lead, lead.phone?.toString() ?? ''),
        _clickableCell(context, lead, lead.status ?? ''),
        _clickableCell(context, lead, _formatFollowUp(lead)),
        _clickableCell(context, lead, lead.remark ?? ''),
        _clickableCell(context, lead, assignedStaff),
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
    LeadsListModel lead,
    String text,
  ) {
    return InkWell(
      onTap: () => _showLeadDetails(context, lead),
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
            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          ),
          child: Text(label),
        ),
      ),
    );
  }

  TableRow _headerRow() {
    const headers = [
      'Sl no',
      'Lead Name',
      'Freelancer Manager',
      'Freelancer',
      'Source',
      'Phone',
      'Status',
      'Follow-up Date',
      'Remark',
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
