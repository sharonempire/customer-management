import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/attendance/controller/attendance_controller.dart';
import 'package:management_software/features/presentation/pages/attendance/widgets/attendance_table.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class AttendanceHistory extends ConsumerWidget {
  const AttendanceHistory({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceList = ref.watch(attendanceServiceProvider).employeeHistory;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.work_outline,
                    size: 26,
                    color: Colors.black87,
                  ),
                  width10,
                  Text(
                    "${attendanceList![0].profile?.displayName ?? ''}'s Attendance",
                    style: myTextstyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Table
              LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.grey.shade100,
                        ),
                        columnSpacing: 30, // spacing between columns
                        horizontalMargin: 12,
                        columns: const [
                          DataColumn(label: Text("Date")),
                          DataColumn(label: Text("Check-In")),
                          DataColumn(label: Text("Check-Out")),
                          DataColumn(label: Text("Status")),
                        ],
                        rows:
                            attendanceList.map((attendance) {
                              final date = attendance.date;
                              final checkIn = attendance.checkInAt ?? "-";
                              final checkOut = attendance.checkOutAt ?? "-";
                              final status =
                                  attendance.attendanceStatus ?? "N/A";

                              return DataRow(
                                cells: [
                                  DataCell(Text(date ?? '')),
                                  DataCell(Text(checkIn)),
                                  DataCell(Text(checkOut)),
                                  DataCell(statusCell(status)),
                                ],
                              );
                            }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
