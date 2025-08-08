import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:management_software/features/presentation/widgets/h1_widget.dart';
import 'package:management_software/features/presentation/widgets/image_icon.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/consts/images.dart';
import 'package:management_software/shared/providers/theme_providers.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({super.key});

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  double getEachContainerWidth(double screenWidth) {
    const double gap = 4.0;
    final double totalGap = 2 * gap;
    final double availableWidth = screenWidth - totalGap - 220;
    return availableWidth / 3;
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final eachContainerWidth = getEachContainerWidth(screenWidth);

    return Scaffold(
      body: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: H1Widget(title: "Dashboard"),
            centerTitle: false,
            actions: [
              IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  size: 14,
                ),
                tooltip: 'Toggle theme',
                onPressed: () {
                  ref.read(themeModeProvider.notifier).state =
                      themeMode == ThemeMode.dark
                          ? ThemeMode.light
                          : ThemeMode.dark;
                },
              ),
              width20,
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.notifications_outlined),
              ),
              width10,
              CircleAvatar(radius: 18),
              width5,
              Text("John Doe"),
              width30,
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
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
                            style: myTextstyle(color: ColorConsts.activeColor),
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
                                style: myTextstyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Spacer(),
                              ImageIconContainer(
                                image: ImageConsts.targetIcon,
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
                          Text(
                            'vs last month',
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
        ),
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
