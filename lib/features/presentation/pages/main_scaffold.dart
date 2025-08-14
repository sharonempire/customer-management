import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/image_icon.dart';
import 'package:management_software/shared/consts/images.dart';
import '../widgets/animated_navigation_rail.dart';

class MainScaffold extends StatelessWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRect(
        child: Material(
          child: Stack(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        width: 79,
                        child: Center(
                          child: ImageIconContainer(
                            size: 45,
                            image: ImageConsts.logo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 2.5),
                  Expanded(child: child),
                ],
              ),

              const Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: AnimatedNavRail(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
