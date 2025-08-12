import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/presentation/pages/attendance/widgets/attendance_table.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart'
    show CommonAppbar;
import 'package:management_software/features/presentation/widgets/common_dropdowns.dart';
import 'package:management_software/features/presentation/widgets/primary_button.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
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
    Future.microtask(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CommonAppbar(title: "Lead Management"),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
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
                          onpressed: () {},
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
                          color:
                              ColorConsts
                                  .backgroundColorScaffold, // grey background
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
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Column(children: [LeadListingWidget()]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Column(children: [LeadListingWidget()]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeadListingWidget extends StatelessWidget {
  const LeadListingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2.5),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(2),
          5: FlexColumnWidth(2),
          6: FlexColumnWidth(2),
          7: FlexColumnWidth(2),
          8: FlexColumnWidth(2),
          9: FlexColumnWidth(2),
          10: FlexColumnWidth(1.5),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: Colors.grey.shade300, width: 1),
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        children: [
          TableRow(
            decoration: BoxDecoration(color: Colors.grey.shade100),
            children: [
              tableHeaderCell("ID"),
              tableHeaderCell("Lead Name"),
              tableHeaderCell("Freelancer Manager"),
              tableHeaderCell("Freelancer"),
              tableHeaderCell("Source"),
              tableHeaderCell("Phone"),
              tableHeaderCell("Status"),
              tableHeaderCell("Follow Up Date"),
              tableHeaderCell("Action"),
            ],
          ),
          TableRow(
            children: [
              tableCell("0001"),
              tableCell("John Doe"),
              tableCell("Sarah Smith"),
              tableCell("John honaai"),
              tableCell("Website"),
              tableCell("Counsellor"),
              tableCell("09:15AM"),
              statusCell("Present", Colors.green),
              actionCell("View History"),
            ],
          ),
          TableRow(
            children: [
              tableCell("0001"),
              tableCell("John Doe"),
              tableCell("Sarah Smith"),
              tableCell("John honaai"),
              tableCell("Website"),
              tableCell("Counsellor"),
              tableCell("09:15AM"),
              statusCell("Present", Colors.green),
              actionCell("View History"),
            ],
          ),
        ],
      ),
    );
  }
}

class LeadFiltersWidget extends StatelessWidget {
  const LeadFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Row(
          children: [
            width10,
            Expanded(
              child: _dropdownColumn(
                "Source",
                "Select Source",
                '',
                [],
                (value) {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _dropdownColumn(
                "Status",
                "Select Status",
                '',
                [],
                (value) {},
              ),
            ),
            width10,
            Expanded(
              child: _dropdownColumn(
                "Freelancer",
                "Select Status",
                '',
                [],
                (value) {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _dropdownColumn(
                "Lead Type",
                "Select Owner",
                '',
                [],
                (value) {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _dropdownColumn(
                "Period",
                "Select Priority",
                '',
                [],
                (value) {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _dropdownColumn(
  String label,
  String hint,
  String value,
  List<String> items,
  Function(String?) onChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: myTextstyle(color: Colors.grey, fontSize: 14)),
      SizedBox(height: 5),
      dropdownField(
        label: hint,
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    ],
  );
}

class SearchLeadsWidget extends StatelessWidget {
  const SearchLeadsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Row(
          children: [
            SizedBox(
              width: 350,
              height: 28,
              child: TextField(
                decoration: InputDecoration(
                  labelText: "Search Leads...",
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 12),
                  prefixIcon: Icon(Icons.search, color: Colors.grey, size: 18),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: 8,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey, width: 1.5),
                  ),
                ),
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
