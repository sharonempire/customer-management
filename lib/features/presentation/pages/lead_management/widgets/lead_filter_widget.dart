
import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/common_dropdowns.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/styles/textstyles.dart';

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
