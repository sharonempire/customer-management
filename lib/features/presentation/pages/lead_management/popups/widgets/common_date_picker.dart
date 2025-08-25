
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class CommonDatePicker extends StatefulWidget {
  final String label;
  const CommonDatePicker({super.key, required this.label});

  @override
  State<CommonDatePicker> createState() => _CommonDatePickerState();
}

class _CommonDatePickerState extends State<CommonDatePicker> {
  DateTime? selectedDate;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          controller: _controller,
          readOnly: true, // prevent typing
          decoration: InputDecoration(
            label: Text(
              widget.label,
              style: myTextstyle(color: Colors.grey, fontSize: 18),
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                selectedDate = picked;
                _controller.text =
                    "${picked.day}/${picked.month}/${picked.year}";
              });
            }
          },
        ),
      ),
    );
  }
}
