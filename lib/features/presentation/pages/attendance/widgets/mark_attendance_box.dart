import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/application/attendance/controller/attendance_controller.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/date_time_helper.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class MarkAttendanceBox extends StatelessWidget {
  final WidgetRef ref;
  const MarkAttendanceBox({
    super.key,
    required this.eachContainerWidth,
    required this.ref,
  });

  final double eachContainerWidth;

  @override
  Widget build(BuildContext context) {
    final attendanceProvider = ref.watch(attendanceServiceProvider);
    final attendanceNotifier = ref.read(attendanceServiceProvider.notifier);
    return Container(
      height: 380,
      width: eachContainerWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(18),

      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.schedule, size: 26),
              width10,
              Text(
                'Mark attendance',
                style: myTextstyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          height10,
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(color: ColorConsts.lightGrey),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StreamBuilder<DateTime>(
                    stream: Stream.periodic(
                      const Duration(seconds: 1),
                      (_) => DateTime.now(),
                    ),
                    builder: (context, snapshot) {
                      final now = snapshot.data ?? DateTime.now();
                      return Text(
                        DateTimeHelper.formatTime(now),
                        style: myTextstyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: ColorConsts.primaryColor,
                        ),
                      );
                    },
                  ),
                  Text(
                    DateTimeHelper.formatDate(DateTime.now()),
                    style: myTextstyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          height20,
          AttendanceButton(
            status: attendanceProvider.userAttendance?.attendanceStatus ?? '',
            changeStatus: () {
              if (attendanceProvider.userAttendance?.attendanceStatus ==
                  'Present') {
                attendanceNotifier.checkOut(context: context);
              }
              if (attendanceProvider.userAttendance?.attendanceStatus ==
                  'Checked out') {
              } else {
                attendanceNotifier.checkIn(context: context);
              }
            },
          ),
          height10,
          Divider(color: ColorConsts.lightGrey, thickness: 3),
          height10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status: ',
                style: myTextstyle(color: Colors.grey, fontSize: 16),
              ),
              Container(
                height: 32,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Center(
                  child: Text(
                    attendanceProvider.userAttendance?.attendanceStatus ?? '',
                    style: myTextstyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceButton extends StatelessWidget {
  final String status;
  final Function() changeStatus;
  const AttendanceButton({
    super.key,
    required this.status,
    required this.changeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changeStatus,
      child: Container(
        width: double.infinity,
        height: 46,
        decoration: BoxDecoration(
          color:
              status == 'Present'
                  ? Colors.red
                  : status == 'Checked out'
                  ? Colors.grey
                  : Colors.green,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, color: Colors.white),
            width10,
            Text(
              status == 'Present'
                  ? 'Check out'
                  : status == 'Checked out'
                  ? 'Checked out'
                  : 'Check in',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
