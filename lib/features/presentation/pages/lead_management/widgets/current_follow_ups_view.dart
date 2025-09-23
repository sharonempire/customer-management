import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/presentation/pages/lead_management/widgets/lead_list_table.dart';

class CurrentFollowUpsView extends ConsumerWidget {
  const CurrentFollowUpsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final followUps = ref.watch(currentFollowUpsProvider);

    if (followUps.isEmpty) {
      return const Center(
        child: Text('No follow-ups match the selected filters.'),
      );
    }

    return LeadListTable(leads: followUps);
  }
}
