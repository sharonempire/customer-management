import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/data/lead_management/models/lead_list_model.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_details.dart';
import 'package:management_software/features/presentation/pages/lead_management/widgets/lead_filter_widget.dart';
import 'package:management_software/features/presentation/pages/lead_management/widgets/search_lead_widget.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart'
    show CommonAppbar;
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class LeadManagement extends ConsumerStatefulWidget {
  const LeadManagement({super.key});

  @override
  ConsumerState<LeadManagement> createState() => _LeadManagementState();
}

class _LeadManagementState extends ConsumerState<LeadManagement> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref
          .read(leadMangementcontroller.notifier)
          .fetchAllLeads(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final provider = ref.watch(leadMangementcontroller);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CommonAppbar(title: "Lead Management"),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Track and manage student enquiries and follow-ups",
                        style: myTextstyle(),
                      ),
                      const Spacer(),
                      PrimaryButton(
                        onpressed: () {
                          ref.read(leadMangementcontroller.notifier).setFromNewLead(true);
                          context.go(
                            '${RouterConsts().enquiries.route}/${RouterConsts().leadInfo.route}',
                          );
                        },
                        icon: Icons.add,
                        text: "New Lead",
                      ),
                    ],
                  ),
                  height30,
                  SearchLeadsWidget(),
                  height20,
                  LeadFiltersWidget(),
                  height20,
                  Center(
                    child: Container(
                      height: 50,
                      width: screenWidth / 2.5,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: ColorConsts.backgroundColorScaffold,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TabBar(
                        tabs: const [
                          Tab(text: "Current Follow ups"),
                          Tab(text: "New Enquiries"),
                        ],
                        indicator: BoxDecoration(
                          color: ColorConsts.primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.grey,
                        indicatorSize: TabBarIndicatorSize.tab,
                        labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  height20,
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      children: [
                        Column(
                          children: [
                            LeadListingWidget(leadList: provider.leadsList),
                          ],
                        ),
                        Column(
                          children: [
                            LeadListingWidget(leadList: provider.leadsList),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LeadListingWidget extends StatelessWidget {
  final List<LeadsListModel> leadList;
  const LeadListingWidget({super.key, required this.leadList});

  void _showLeadDetails(BuildContext context, LeadsListModel lead) {
    showDialog(
      context: context,
      builder: (context) => LeaadDetailsPopup(context: context),
    );
  }

  TableRow _clickableRow(BuildContext context, LeadsListModel lead) {
    return TableRow(
      children: [
        _clickableCell(context, lead, lead.slNo.toString().padLeft(4, '0')),
        _clickableCell(context, lead, lead.name ?? ""),
        _clickableCell(context, lead, lead.freelancerManager ?? ''),
        _clickableCell(context, lead, lead.freelancer ?? ''),
        _clickableCell(context, lead, lead.source ?? ''),
        _clickableCell(context, lead, lead.phone.toString()),
        _clickableCell(context, lead, lead.status ?? ''),
        _clickableCell(context, lead, lead.followUp ?? ''),
        _clickableCell(context, lead, lead.remark ?? ''),
        _clickableCell(context, lead, lead.assignedTo ?? ''),
        actionCell(
          "Edit",
          onTap: () {
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
        child: Text(text, style: myTextstyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          // Header Row
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            children: [
              tableHeaderCell("Sl no"),
              tableHeaderCell("Lead Name"),
              tableHeaderCell("Freelancer Manager"),
              tableHeaderCell("Freelancer"),
              tableHeaderCell("Source"),
              tableHeaderCell("Phone"),
              tableHeaderCell("Status"),
              tableHeaderCell("Follow-up Date"),
              tableHeaderCell("Remark"),
              tableHeaderCell("Assigned Staff"),
              tableHeaderCell("Action"),
            ],
          ),
          for (var lead in leadList) _clickableRow(context, lead),
        ],
      ),
    );
  }
}

Widget tableHeaderCell(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        fontSize: 16,
      ),
    ),
  );
}

Widget tableCell(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      text,
      style: const TextStyle(color: Colors.black87, fontSize: 14),
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget statusCell(String status) {
  Color color;
  switch (status) {
    case "Present":
      color = Colors.green;
      break;
    case "Checked out":
      color = Colors.orange;
      break;
    case "Absent":
      color = Colors.red;
      break;
    default:
      color = Colors.grey;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
    ),
  );
}

Widget actionCell(String label, {required VoidCallback onTap}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: IconButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: Colors.blue,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        icon: Text(label),
      ),
    ),
  );
}
