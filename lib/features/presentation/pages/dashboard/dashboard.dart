import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/presentation/widgets/common_appbar.dart';
import 'package:management_software/features/presentation/widgets/h1_widget.dart';
import 'package:management_software/features/presentation/widgets/image_icon.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/consts/images.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final eachContainerWidth = getEachContainerWidth(screenWidth, 3);

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CommonAppbar(title: "Dashboard"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 130,
                    constraints: BoxConstraints(minWidth: double.infinity),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            H1Widget(
                              color: Colors.black,
                              title: 'Welcome back, John Doe  👋',
                            ),
                            height5,
                            Text(
                              "Here’s what’s happening with your leads and courses today",
                              style: TextStyle(color: Colors.grey),
                            ),
                            height5,
                            Text(
                              "Monday, July 28, 2025",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Last updated",
                              style: myTextstyle(color: Colors.grey),
                            ),
                            height5,
                            Text(
                              "2 min ago",
                              style: myTextstyle(
                                color: ColorConsts.activeColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  height20,
                  Container(
                    padding: EdgeInsets.all(20),
                    height: 200,
                    constraints: BoxConstraints(minWidth: double.infinity),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ImageIconContainer(image: ImageConsts.targetIcon),
                            width5,
                            H2Widget(
                              color: ColorConsts.secondaryColor,
                              title: "Today's Goals",
                            ),
                          ],
                        ),
                        height20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(3, (index) {
                            return Container(
                              padding: EdgeInsets.all(12),
                              width: eachContainerWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'New Leads',
                                        style: myTextstyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '12/25',
                                        style: myTextstyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  height10,
                                  LinearProgressionBar(
                                    eachContainerWidth: eachContainerWidth,
                                  ),
                                  height10,
                                  Text(
                                    '8 more to reach goal',
                                    style: myTextstyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  height20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(4, (index) {
                      return PerformanceBox(
                        index: index,
                        eachContainerWidth: eachContainerWidth,
                      );
                    }),
                  ),
                  height20,
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: List.generate(3, (index) {
                  //     return ShortcutBox(
                  //       index: index,
                  //       eachContainerWidth: eachContainerWidth * 1.37,
                  //     );
                  //   }),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShortcutBox extends StatelessWidget {
  const ShortcutBox({
    super.key,
    required this.eachContainerWidth,
    required this.index,
  });

  final double eachContainerWidth;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      width: eachContainerWidth / 1.3,
      height: eachContainerWidth * .5,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageIconContainer(image: ImageConsts.shortCutIcon, size: 24),

              width10,
              Text(
                'Quick Actions',
                style: myTextstyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Spacer(),
              Container(
                height: 20,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    '3 new',
                    style: myTextstyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
              height10,
            ],
          ),
          height20,
          Container(
            height: eachContainerWidth / 6.5,

            padding: EdgeInsets.all(20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 203, 222, 255),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                ImageIconContainer(
                  image: ImageConsts.phoneShortCutIcon,
                  size: 32,
                ),
                width5,
                Text("New Enquiries", style: myTextstyle(fontSize: 15)),
              ],
            ),
          ),
          height10,
          Container(
            padding: EdgeInsets.all(20),

            height: eachContainerWidth / 6.5,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 236, 236, 236),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                ImageIconContainer(
                  image: ImageConsts.phoneShortCutIcon,
                  size: 32,
                ),
                width5,
                Text("New Enquiries", style: myTextstyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PerformanceBox extends StatelessWidget {
  const PerformanceBox({
    super.key,
    required this.eachContainerWidth,
    required this.index,
  });

  final double eachContainerWidth;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18),
      width: eachContainerWidth / 1.3,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'New Leads',
                style: myTextstyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              Spacer(),
              ImageIconContainer(
                image:
                    index == 0
                        ? ImageConsts.phoneIcon
                        : index == 1
                        ? ImageConsts.freelancerIcon
                        : index == 2
                        ? ImageConsts.counsellorIcon
                        : ImageConsts.performanceIcon,
                size: 28,
              ),
            ],
          ),
          Text(
            "329",
            style: myTextstyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),
          height10,
          Row(
            children: [
              Text(
                'vs last month',
                style: myTextstyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
              Spacer(),
              trendingIcon(index - 1),
            ],
          ),
        ],
      ),
    );
  }
}

class LinearProgressionBar extends StatelessWidget {
  const LinearProgressionBar({super.key, required this.eachContainerWidth});

  final double eachContainerWidth;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: eachContainerWidth,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey,
          ),
        ),
        Container(
          width: eachContainerWidth * (20 / 25),
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorConsts.primaryColor,
          ),
        ),
      ],
    );
  }
}

Widget trendingIcon(int change) {
  if (change > 0) {
    return Row(
      children: [
        Icon(Icons.trending_up, color: Colors.green),
        width5,
        Text("$change%", style: myTextstyle(color: Colors.green)),
      ],
    );
  } else if (change < 0) {
    return Row(
      children: [
        Icon(Icons.trending_down, color: Colors.red),
        width5,
        Text("$change%", style: myTextstyle(color: Colors.red)),
      ],
    );
  } else {
    return Row(
      children: [
        Icon(Icons.trending_flat, color: Colors.grey),
        width5,
        Text("$change%", style: myTextstyle(color: Colors.grey)),
      ],
    );
  }
}
