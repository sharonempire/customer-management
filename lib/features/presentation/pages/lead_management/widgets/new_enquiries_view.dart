import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/presentation/pages/lead_management/widgets/lead_list_table.dart';

class NewEnquiriesView extends ConsumerWidget {
  const NewEnquiriesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadState = ref.watch(leadMangementcontroller);
    final leads = leadState.filteredLeadsList;

    if (leads.isEmpty) {
      return const Center(
        child: Text('No enquiries match the selected filters.'),
      );
    }

    return LeadListTable(leads: leads);
  }
}
