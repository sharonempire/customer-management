import 'package:flutter/material.dart';
import 'package:management_software/shared/consts/color_consts.dart';
import 'package:management_software/shared/styles/textstyles.dart';

Widget dropdownField({
  required String label,
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) => SizedBox(
  height: 30,
  child: DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: myTextstyle(fontSize: 14, color: Colors.grey),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: ColorConsts.lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: ColorConsts.lightGrey),
      ),
    ),
    value: value,
    items:
        items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    onChanged: onChanged,
  ),
);
