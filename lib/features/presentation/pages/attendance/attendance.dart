import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/attendance/controller/attendance_controller.dart';
import 'package:management_software/features/presentation/pages/attendance/widgets/attendance_table.dart';
import 'package:management_software/features/presentation/pages/attendance/widgets/mark_attendance_box.dart';
import 'package:management_software/features/presentation/pages/attendance/widgets/todays_overview.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart'
    show CommonAppbar;
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(attendanceServiceProvider.notifier)
          .getTodayStatus(context: context);
      ref
          .read(attendanceServiceProvider.notifier)
          .getAllEmployeeAttendance(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final eachContainerWidth = getEachContainerWidth(screenWidth, 2);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CommonAppbar(title: "Attendance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Track attendance and manage workforce efficiently",
                style: myTextstyle(),
              ),
              height30,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MarkAttendanceBox(
                    eachContainerWidth: eachContainerWidth,
                    ref: ref,
                  ),
                  TodaysOverview(eachContainerWidth: eachContainerWidth),
                ],
              ),
              height20,
              AttendanceTableWidget(
            
              ),
            ],
          ),
        ),
      ),
    );
  }
}
