import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:management_software/features/application/attendance/controller/attendance_controller.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/routes/router_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class AttendanceTableWidget extends ConsumerWidget {
  const AttendanceTableWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendanceList =
        ref.watch(attendanceServiceProvider).allEmployeesAttendance ?? [];
    log(attendanceList.toString());

    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              const Icon(Icons.work_outline, size: 26, color: Colors.black87),
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
          const SizedBox(height: 16),

          // Table
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: constraints.maxWidth, // full screen width
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(
                      Colors.grey.shade100,
                    ),
                    columnSpacing: 30, // spacing between columns
                    horizontalMargin: 12,
                    columns: const [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Role")),
                      DataColumn(label: Text("Check-In")),
                      DataColumn(label: Text("Check-Out")),
                      DataColumn(label: Text("Status")),
                      DataColumn(label: Text("Action")),
                    ],
                    rows:
                        attendanceList.map((attendance) {
                          final name =
                              attendance.profile?.displayName ?? "Unknown";
                          final role = attendance.profile?.designation ?? "N/A";
                          final checkIn = attendance.checkInAt ?? "-";
                          final checkOut = attendance.checkOutAt ?? "-";
                          final status = attendance.attendanceStatus ?? "N/A";

                          return DataRow(
                            cells: [
                              DataCell(Text(name)),
                              DataCell(Text(role)),
                              DataCell(Text(checkIn)),
                              DataCell(Text(checkOut)),
                              DataCell(statusCell(status)),
                              DataCell(
                                TextButton(
                                  onPressed: () async {
                                    await ref
                                        .read(
                                          attendanceServiceProvider.notifier,
                                        )
                                        .getAttendanceHistory(
                                          context: context,
                                          userId: attendance.employeeId ?? '',
                                        );
                                    context.push(
                                      '${RouterConsts().attendance.route}/${RouterConsts().attendanceHistory.route}',
                                    );
                                  },
                                  child: const Text("View"),
                                ),
                              ),
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
    );
  }
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

  return Text(
    status,
    style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
  );
}
