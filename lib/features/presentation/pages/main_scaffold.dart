import 'package:flutter/material.dart';
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
                  SizedBox(width: 72),
                  VerticalDivider(),
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
