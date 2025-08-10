import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart'
    show CommonAppbar;
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
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
    Future.microtask(() {});
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
                  MarkAttendanceBox(eachContainerWidth: eachContainerWidth),
                  TodaysOverview(eachContainerWidth: eachContainerWidth),
                ],
              ),
              height20,
              Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TodaysOverview extends StatelessWidget {
  const TodaysOverview({super.key, required this.eachContainerWidth});

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
              Icon(Icons.person_outline, size: 26),
              width10,
              Text(
                "Today's Overview",
                style: myTextstyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          height10,
          Row(
            children: [
              Container(
                height: 80,
                width: eachContainerWidth / 2.2,
                decoration: BoxDecoration(
                  color: ColorConsts.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "4",
                        style: myTextstyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: ColorConsts.activeColor,
                        ),
                      ),
                      Text('Present', style: myTextstyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              width20,
              Container(
                height: 80,
                width: eachContainerWidth / 2.5,
                decoration: BoxDecoration(
                  color: ColorConsts.lightGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "4",
                        style: myTextstyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: ColorConsts.secondaryColor,
                        ),
                      ),
                      Text(
                        'Absent',
                        style: myTextstyle(color: ColorConsts.secondaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          height10,
          Divider(color: ColorConsts.lightGrey, thickness: 3),
          height10,
          OverViewItems(title: 'On Time:', value: '3/4'),
          height5,
          OverViewItems(title: 'Late:', value: '1/4'),
          height5,
          OverViewItems(title: 'Attendance Rate:', value: '80%'),
        ],
      ),
    );
  }
}

class OverViewItems extends StatelessWidget {
  final String title;
  final String value;
  const OverViewItems({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: myTextstyle(color: Colors.grey, fontSize: 16)),
        Spacer(),
        Text(value, style: myTextstyle(color: Colors.grey, fontSize: 16)),
      ],
    );
  }
}

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
