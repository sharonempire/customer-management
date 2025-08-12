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
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1), // ID
                  1: FlexColumnWidth(2), // Lead Name
                  2: FlexColumnWidth(2), // Freelancer Manager
                  3: FlexColumnWidth(2), // Freelancer
                  4: FlexColumnWidth(1.5), // Source
                  5: FlexColumnWidth(2), // Phone
                  6: FlexColumnWidth(1.5), // Status
                  7: FlexColumnWidth(2), // Follow-up Date
                  8: FlexColumnWidth(3), // Remark
                  9: FlexColumnWidth(2), // Assigned Staff
                  10: FlexColumnWidth(1.5), // Actions
                },
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                children: [
                  /// Header Row
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
                      tableHeaderCell("Follow-up Date"),
                      tableHeaderCell("Remark"),
                      tableHeaderCell("Assigned Staff"),
                      tableHeaderCell("Actions"),
                    ],
                  ),

                  /// Example Data Row
                  TableRow(
                    children: [
                      tableCell("1"),
                      tableCell("John Doe"),
                      tableCell("Alice Smith"),
                      tableCell("Mike Johnson"),
                      tableCell("LinkedIn"),
                      tableCell("+1 555-1234"),
                      statusCell("Active", Colors.green),
                      tableCell("2025-08-15"),
                      tableCell("Interested in package B"),
                      tableCell("Sarah Parker"),
                      actionCell("View"),
                    ],
                  ),

                  /// Another Example Row
                  TableRow(
                    children: [
                      tableCell("2"),
                      tableCell("Jane Roe"),
                      tableCell("Robert White"),
                      tableCell("Emma Brown"),
                      tableCell("Referral"),
                      tableCell("+1 555-5678"),
                      statusCell("Pending", Colors.orange),
                      tableCell("2025-08-18"),
                      tableCell("Waiting for documents"),
                      tableCell("James Lee"),
                      actionCell("View"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget tableHeaderCell(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
    ),
  );
}

Widget tableCell(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(text, style: TextStyle(color: Colors.black87)),
  );
}

Widget statusCell(String status, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      status,
      style: TextStyle(color: color, fontWeight: FontWeight.w600),
    ),
  );
}

Widget actionCell(String label) {
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
