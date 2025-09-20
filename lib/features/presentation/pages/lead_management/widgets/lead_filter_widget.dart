import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/lead_management/controller/lead_management_controller.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/widgets/common_date_range_picker.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/date_time_helper.dart';

class LeadFiltersWidget extends ConsumerWidget {
  const LeadFiltersWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leadState = ref.watch(leadMangementcontroller);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Source, Status, Freelancer
          Row(
            children: [
              Expanded(
                child: _buildDropdownWithClear(
                  label: "Source",
                  value:
                      leadState.filterSource.isEmpty
                          ? null
                          : leadState.filterSource,
                  items: ["Facebook", "Google Ads", "Referral"],
                  onChanged:
                      (value) => ref
                          .read(leadMangementcontroller.notifier)
                          .changeSource(value ?? ''),
                  onClear:
                      () => ref
                          .read(leadMangementcontroller.notifier)
                          .changeSource(''),
                ),
              ),
              width10,
              Expanded(
                child: _buildDropdownWithClear(
                  label: "Status",
                  value:
                      leadState.filterStatus.isEmpty
                          ? null
                          : leadState.filterStatus,
                  items: ["Lead creation", "Course sent", "bad lead"],
                  onChanged:
                      (value) => ref
                          .read(leadMangementcontroller.notifier)
                          .changeStatus(value ?? ''),
                  onClear:
                      () => ref
                          .read(leadMangementcontroller.notifier)
                          .changeStatus(''),
                ),
              ),
              width10,
              Expanded(
                child: _buildDropdownWithClear(
                  label: "Freelancer",
                  value:
                      leadState.filterFreelancer.isEmpty
                          ? null
                          : leadState.filterFreelancer,
                  items: ["John", "Sarah", "Alex"],
                  onChanged:
                      (value) => ref
                          .read(leadMangementcontroller.notifier)
                          .changeFreelancer(value ?? ''),
                  onClear:
                      () => ref
                          .read(leadMangementcontroller.notifier)
                          .changeFreelancer(''),
                ),
              ),
            ],
          ),
          height10,

          // Row 2: Lead Type, Period, Date Range
          Row(
            children: [
              Expanded(
                child: _buildDropdownWithClear(
                  label: "Lead Type",
                  value:
                      leadState.filterLeadType.isEmpty
                          ? null
                          : leadState.filterLeadType,
                  items: ["Hot", "Warm", "Cold"],
                  onChanged:
                      (value) => ref
                          .read(leadMangementcontroller.notifier)
                          .changeLeadType(value ?? ''),
                  onClear:
                      () => ref
                          .read(leadMangementcontroller.notifier)
                          .changeLeadType(''),
                ),
              ),
              width10,
              Expanded(
                child: _buildDropdownWithClear(
                  label: "Period",
                  value: null,
                  items: [
                    "Today",
                    "Yesterday",
                    "This Week",
                    "Last Week",
                    "This Month",
                  ],
                  onChanged: (value) {
                    if (value == "Today") {
                      ref
                          .read(leadMangementcontroller.notifier)
                          .fetchTodaysLeads(context: context);
                    } else if (value == "This Week") {
                      ref
                          .read(leadMangementcontroller.notifier)
                          .fetchThisWeekLeads(context: context);
                    } else if (value == "This Month") {
                      ref
                          .read(leadMangementcontroller.notifier)
                          .fetchLastMonthLeads(context: context);
                    } else if (value == "Last Week") {
                      ref
                          .read(leadMangementcontroller.notifier)
                          .fetchLastWeekLeads(context: context);
                    } else if (value == "Yesterday") {
                      ref
                          .read(leadMangementcontroller.notifier)
                          .fetchLeadsByDate(
                            context: context,
                            date: DateTimeHelper.formatDateForLead(
                              DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day - 1,
                              ),
                            ),
                          );
                    }
                  },
                  onClear: () {},
                ),
              ),
              width10,
              CommonDateRangePicker(
                label: "Selected Date Range",
                value: selectedDateTimeRange,
                onChanged: (range) {
                  selectedDateTimeRange = range;
                  ref
                      .read(leadMangementcontroller.notifier)
                      .fetchLeadsByRange(
                        context: context,
                        start: DateTimeHelper.formatDateForLead(
                          range?.start ?? DateTime.now(),
                        ),
                        end: DateTimeHelper.formatDateForLead(
                          range?.end ?? DateTime.now(),
                        ),
                      );
                },
              ),
            ],
          ),
          height10,

          // Clear All Button
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton.icon(
                onPressed:
                    () =>
                        ref
                            .read(leadMangementcontroller.notifier)
                            .clearFilters(),
                icon: const Icon(Icons.clear),
                label: const Text("Clear All Filters"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownWithClear({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required VoidCallback onClear,
  }) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: label),
            value: value,
            items:
                items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: onChanged,
          ),
        ),
        IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: onClear),
      ],
    );
  }
}

DateTimeRange? selectedDateTimeRange;
