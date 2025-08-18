import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class LeaadDetailsPopup extends StatelessWidget {
  final BuildContext context;
  const LeaadDetailsPopup({super.key, required this.context});

  @override
  Widget build(BuildContext context) {
    final containerWidth = (MediaQuery.of(context).size.width * .8) * .35;
    List<Widget> items = [
      BasicInformationBox(containerWidth: containerWidth),
      ContactInformationBox(containerWidth: containerWidth),
      AssignmentDetailsBox(containerWidth: containerWidth),
      TimelineAndFollowup(containerWidth: containerWidth),
    ];
    return SizedBox(
      height: MediaQuery.of(context).size.height * .8,
      width: MediaQuery.of(context).size.width * .8,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lead Details",
              style: myTextstyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            height5,
            Text(
              "Complete information for John Smith",
              style: myTextstyle(color: Colors.grey),
            ),
            height20,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [items.first, items[3]]),
                Column(children: [items[2], items[1]]),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}

class TimelineAndFollowup extends StatelessWidget {
  const TimelineAndFollowup({super.key, required this.containerWidth});

  final double containerWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        width: containerWidth,
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.chat_outlined, color: ColorConsts.primaryColor),
                width5,
                Text(
                  "Timeline & Follow-up",
                  style: myTextstyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            height5,
            InfoItemsWidget(title: 'Lead Crated', value: 'Jan 20, 2024'),
            height5,
            InfoItemsWidget(title: "Course Sent", value: "Mar 22, 2024"),
          ],
        ),
      ),
    );
  }
}

class ContactInformationBox extends StatelessWidget {
  const ContactInformationBox({super.key, required this.containerWidth});

  final double containerWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColorConsts.activeColor, width: 1),
        ),
        width: containerWidth,
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.phone_outlined, color: ColorConsts.primaryColor),
                width5,
                Text(
                  "Contact information",
                  style: myTextstyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            height5,
            InfoItemsWidget(title: 'Phone', value: '+91 812911245'),
            height5,
            InfoItemsWidget(title: "Email", value: "minnalmurali@gmail.com"),
            height5,
            InfoItemsWidget(
              title: "Address",
              value: "123, Main Street, New York, USA",
            ),
          ],
        ),
      ),
    );
  }
}

class AssignmentDetailsBox extends StatelessWidget {
  const AssignmentDetailsBox({super.key, required this.containerWidth});

  final double containerWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColorConsts.activeColor, width: 1),
        ),
        width: containerWidth,
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.chat_outlined, color: ColorConsts.primaryColor),
                width5,
                Text(
                  "Assignment Details",
                  style: myTextstyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            height5,
            InfoItemsWidget(
              title: 'Freelancer Manager',
              value: 'Sarah Johnson',
            ),
            height5,
            InfoItemsWidget(title: "Assigned Freelancer", value: "Mike Chen"),
            height5,
            InfoItemsWidget(title: "Assigned Staff", value: "Alex Wilson"),
          ],
        ),
      ),
    );
  }
}

class BasicInformationBox extends StatelessWidget {
  const BasicInformationBox({super.key, required this.containerWidth});

  final double containerWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey, width: 1),
        ),
        width: containerWidth,
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, color: ColorConsts.primaryColor),
                width5,
                Text(
                  "Basic information",
                  style: myTextstyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            height5,
            InfoItemsWidget(title: 'Lead ID', value: '0001'),
            height5,
            InfoItemsWidget(title: 'FULL Name', value: 'John Smith'),
            height5,
            InfoItemsWidget(title: "Status", value: "Lead created"),
            height5,
            InfoItemsWidget(title: "Source", value: "Website"),
          ],
        ),
      ),
    );
  }
}

class InfoItemsWidget extends StatelessWidget {
  final String title;
  final String value;

  const InfoItemsWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "$title:",
          style: myTextstyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Spacer(),
        Text(
          value,
          style: myTextstyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
