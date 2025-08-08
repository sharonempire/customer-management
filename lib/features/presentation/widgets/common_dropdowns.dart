import 'package:flutter/material.dart';

Widget dropdownField({
  required String label,
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) => DropdownButtonFormField<String>(
  decoration: InputDecoration(
    labelText: label,
    border: const OutlineInputBorder(),
  ),
  value: value,
  items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
  onChanged: onChanged,
);
