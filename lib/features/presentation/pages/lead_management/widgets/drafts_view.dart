import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/widgets/lead_list_table.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/date_time_helper.dart';

class DraftsView extends ConsumerWidget {
  const DraftsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drafts = ref.watch(draftLeadsProvider);

    if (drafts.isEmpty) {
      return const Center(child: Text('No drafts match the selected filters.'));
    }

    final metaById = <int, DraftLead>{};
    for (final draft in drafts) {
      final id = draft.lead.id;
      if (id != null) {
        metaById[id] = draft;
      }
    }

    String followUpText(LeadsListModel lead) {
      final draft = metaById[lead.id];
      if (draft == null) return '';
      return DateTimeHelper.formatDateForLead(draft.latestCallDate);
    }

    String remarkText(LeadsListModel lead) {
      final draft = metaById[lead.id];
      if (draft == null) {
        return lead.remark ?? '';
      }

      final summaryParts = <String>[];
      summaryParts.add(
        '${draft.totalCalls} call${draft.totalCalls == 1 ? '' : 's'}',
      );

      final status = draft.latestCall.status?.trim();
      if (status != null && status.isNotEmpty) {
        summaryParts.add(status);
      }

      final duration = draft.latestCall.totalDurationSeconds;
      if (duration != null && duration > 0) {
        summaryParts.add('${duration}s');
      }

      final summary = summaryParts.join(' • ');
      final existingRemark = lead.remark?.trim() ?? '';

      if (summary.isEmpty) {
        return existingRemark;
      }
      if (existingRemark.isEmpty) {
        return summary;
      }
      return '$summary\n$existingRemark';
    }

    return LeadListTable(
      leads: drafts.map((entry) => entry.lead).toList(),
      rowBackgroundColor: ColorConsts.greyContainer,
      followUpHeaderLabel: 'Last Call',
      remarkHeaderLabel: 'Call Summary',
      followUpTextBuilder: followUpText,
      remarkTextBuilder: remarkText,
    );
  }
}
