import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class MarkAttendanceBox extends StatelessWidget {
  const MarkAttendanceBox({super.key, required this.eachContainerWidth});

  final double eachContainerWidth;

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    "22:41",
                    style: myTextstyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: ColorConsts.primaryColor,
                    ),
                  ),
                  Text(
                    'Tuesday, July 29, 2025',
                    style: myTextstyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          height20,
          AttendanceButton(checkedIn: true),
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
                child: Center(child: Text('Not Checked In')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceButton extends StatelessWidget {
  final bool checkedIn;
  const AttendanceButton({super.key, required this.checkedIn});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 46,
      decoration: BoxDecoration(
        color: checkedIn ? Colors.red : ColorConsts.activeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, color: Colors.white),
          width10,
          Text(
            checkedIn ? "Check out" : "Check in",
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
