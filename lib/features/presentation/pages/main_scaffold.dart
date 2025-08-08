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
          child: Row(
            children: [
              const AnimatedNavRail(),
              VerticalDivider(),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}
