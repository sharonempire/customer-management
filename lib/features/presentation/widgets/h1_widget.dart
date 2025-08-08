import 'package:flutter/widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';

class H1Widget extends StatelessWidget {
  final String title;
  final Color? color;
  const H1Widget({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: TextStyle(
      color: color ?? ColorConsts.primaryColor,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
    ),
  );
}

class H2Widget extends StatelessWidget {
  final String title;
  final Color? color;
  const H2Widget({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) => Text(
    title,
    style: TextStyle(
      color: color ?? ColorConsts.primaryColor,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
    ),
  );
}
