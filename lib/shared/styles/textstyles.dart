import 'package:flutter/material.dart';
import 'package:management_software/shared/consts/color_consts.dart';

TextStyle myTextstyle({
  double? fontSize = 16,
  FontWeight? fontWeight = FontWeight.normal,
  Color color = ColorConsts.textColor,
}) {
  return TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);
}
