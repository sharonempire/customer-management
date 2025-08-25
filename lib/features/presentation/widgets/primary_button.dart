import 'package:flutter/material.dart';
import 'package:management_software/features/presentation/widgets/space_widgets.dart';
import 'package:management_software/shared/consts/color_consts.dart';

class PrimaryButton extends StatelessWidget {
  final Function() onpressed;
  final String text;
  final IconData? icon;
  const PrimaryButton({
    super.key,
    required this.onpressed,
    required this.text,
   this.icon,
  });

  @override
  Widget build(BuildContext context) => ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      backgroundColor: ColorConsts.primaryColor,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onPressed: () => onpressed.call(),
    child: Row(
      children: [
        icon != null ? Icon(icon) : SizedBox.shrink(),
        width5,
        Text(text),
      ],
    ),
  );
}
