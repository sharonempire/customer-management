import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_range_picker.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';

class LeadFiltersWidget extends StatefulWidget {
  const LeadFiltersWidget({super.key});

  @override
  State<LeadFiltersWidget> createState() => _LeadFiltersWidgetState();
}

class _LeadFiltersWidgetState extends State<LeadFiltersWidget> {
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
        child: Consumer(
          builder: (context, ref, _) {
            return Column(
              children: [
                Row(
                  children: [
                    CommonDropdown(
                      label: "Source",
                      items: [
                        "Facebook",
                        "Google Ads",
                        "Referral",
                      ], // Example data
                      value: null,
                      onChanged: (value) {
                        ref
                            .read(leadMangementcontroller.notifier)
                            .changeSource(value ?? '');
                      },
                    ),
                    width10,
                    CommonDropdown(
                      label: "Status",
                      items: ["Lead creation", "Course sent", "bad lead"],
                      value: null,
                      onChanged: (value) {
                        ref
                            .read(leadMangementcontroller.notifier)
                            .changeStatus(value ?? '');
                      },
                    ),
                    width10,
                    CommonDropdown(
                      label: "Freelancer",
                      items: ["John", "Sarah", "Alex"],
                      value: null,
                      onChanged: (value) {
                        ref
                            .read(leadMangementcontroller.notifier)
                            .changeFreelancer(value ?? '');
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    CommonDropdown(
                      label: "Lead Type",
                      items: ["Hot", "Warm", "Cold"],
                      value: null,
                      onChanged: (value) {
                        ref
                            .read(leadMangementcontroller.notifier)
                            .changeLeadType(value ?? '');
                      },
                    ),
                    width10,
                    CommonDropdown(
                      label: "Period",
                      items: ["Today", "This Week", "This Month"],
                      value: null,
                      onChanged: (value) {
                        if (value == "Today") {
                          ref
                              .read(leadMangementcontroller.notifier)
                              .fetchTodaysLeads(context: context);
                        } else if (value == "This Week") {
                          ref
                              .read(leadMangementcontroller.notifier)
                              .fetchLastWeekLeads(context: context);
                        } else if (value == "This Month") {
                          ref
                              .read(leadMangementcontroller.notifier)
                              .fetchLastMonthLeads(context: context);
                        }
                      },
                    ),
                    width10,
                    CommonDateRangePicker(
                      label: "Selected Date Range",
                      value: selectedDateRange,
                      onChanged: (p0) {
                        selectedDateRange =
                            p0 ??
                            DateTimeRange(
                              start: DateTime.now(),
                              end: DateTime.now().add(const Duration(days: 7)),
                            );
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

DateTimeRange? selectedDateRange;
