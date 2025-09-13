import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/pages/lead_management/popups/lead_info_popup.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';

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
            CommonDropdown(
              label: "Source",
              items: ["Facebook", "Google Ads", "Referral"], // Example data
              value: null,
              onChanged: (value) {
                // API call or state update here
              },
            ),
            width10,
            CommonDropdown(
              label: "Status",
              items: ["New", "In Progress", "Closed"],
              value: null,
              onChanged: (value) {},
            ),
            width10,
            CommonDropdown(
              label: "Freelancer",
              items: ["John", "Sarah", "Alex"],
              value: null,
              onChanged: (value) {},
            ),
            width10,
            CommonDropdown(
              label: "Lead Type",
              items: ["Hot", "Warm", "Cold"],
              value: null,
              onChanged: (value) {},
            ),
            width10,
            CommonDropdown(
              label: "Period",
              items: ["Today", "This Week", "This Month"],
              value: null,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }
}
