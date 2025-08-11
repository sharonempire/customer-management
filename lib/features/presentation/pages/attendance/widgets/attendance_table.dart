import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class AttendanceTableWidget extends StatelessWidget {
  const AttendanceTableWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.work_outline, size: 26),
              width10,
              Text(
                "Today's Attendance",
                style: myTextstyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(1.5),
              },
              border: TableBorder(
                horizontalInside: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                bottom: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  children: [
                    _tableHeaderCell("Name"),
                    _tableHeaderCell("Role"),
                    _tableHeaderCell("Check-In Time"),
                    _tableHeaderCell("Status"),
                    _tableHeaderCell("Action"),
                  ],
                ),
                TableRow(
                  children: [
                    _tableCell("John Doe"),
                    _tableCell("Counsellor"),
                    _tableCell("09:15AM"),
                    _statusCell("Present", Colors.green),
                    _actionCell("View History"),
                  ],
                ),
                TableRow(
                  children: [
                    _tableCell("John Doe"),
                    _tableCell("Counsellor"),
                    _tableCell("09:15AM"),
                    _statusCell("Present", Colors.green),
                    _actionCell("View History"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _tableHeaderCell(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
    ),
  );
}

Widget _tableCell(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(text, style: TextStyle(color: Colors.black87)),
  );
}

Widget _statusCell(String status, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.w600),
    ),
  );
}

Widget _actionCell(String label) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: TextButton(
      onPressed: () {
        // Handle action
      },
      child: Text(label),
    ),
  );
}
