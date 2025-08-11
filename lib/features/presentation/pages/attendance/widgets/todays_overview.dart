

import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

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
