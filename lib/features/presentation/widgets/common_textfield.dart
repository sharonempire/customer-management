import 'package:flutter/material.dart';

Widget textField(
  TextEditingController c,
  String label, {
  bool rounded = true,
  IconData? icon,
  bool? required,
  TextInputType keyboard = TextInputType.text,

  Function(String)? onSubmitted,
}) => Padding(
  padding: const EdgeInsets.symmetric(vertical: 4),
  child: TextFormField(
    controller: c,
    keyboardType: keyboard,

    style: const TextStyle(fontSize: 14),
    decoration: InputDecoration(
      prefixIcon: icon != null ? Icon(icon, size: 20) : null,
      labelText: label,
      labelStyle: const TextStyle(fontSize: 14),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      border: OutlineInputBorder(
        gapPadding: 0,
        borderRadius:
            rounded
                ? BorderRadius.all(Radius.circular(12))
                : BorderRadius.all(Radius.zero),
      ),
    ),
    onChanged: (value) {
      onSubmitted?.call(value);
    },
    validator:
        required == true
            ? (v) => v == null || v.trim().isEmpty ? 'Required' : null
            : null,
  ),
);
