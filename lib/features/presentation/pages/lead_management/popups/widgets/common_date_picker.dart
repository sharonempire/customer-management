import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class CommonDatePicker extends StatefulWidget {
  final String label;
  final String? initialDate; // e.g. "September 18, 2025" or ISO string
  final ValueChanged<DateTime?>? onDateSelected;
  final bool useExpanded;

  const CommonDatePicker({
    Key? key,
    required this.label,
    this.initialDate,
    this.onDateSelected,
    this.useExpanded = true,
  }) : super(key: key);

  @override
  State<CommonDatePicker> createState() => _CommonDatePickerState();
}

class _CommonDatePickerState extends State<CommonDatePicker> {
  late final TextEditingController _controller;
  DateTime? _selectedDate;

  // Accepts "September 18, 2025"
  final DateFormat _apiFormat = DateFormat("MMMM d, yyyy");
  // Display as "dd/MM/yyyy"
  final DateFormat _displayFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    if (widget.initialDate != null && widget.initialDate!.trim().isNotEmpty) {
      final raw = widget.initialDate!.trim();
      DateTime? parsed;

      // Try the API format first, then fallback to DateTime.tryParse
      try {
        parsed = _apiFormat.parseLoose(raw);
      } catch (_) {
        // ignore
      }

      parsed ??= DateTime.tryParse(raw);

      if (parsed != null) {
        _selectedDate = parsed;
        _controller.text = _displayFormat.format(parsed);
      }
    }
  }

  @override
  void didUpdateWidget(covariant CommonDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If parent gives a new initialDate, update controller safely
    if (widget.initialDate != oldWidget.initialDate) {
      if (widget.initialDate != null && widget.initialDate!.trim().isNotEmpty) {
        final raw = widget.initialDate!.trim();
        DateTime? parsed;
        try {
          parsed = _apiFormat.parseLoose(raw);
        } catch (_) {}
        parsed ??= DateTime.tryParse(raw);
        if (parsed != null) {
          _selectedDate = parsed;
          _controller.text = _displayFormat.format(parsed);
        }
      } else {
        // cleared by parent
        _selectedDate = null;
        _controller.clear();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final initial = _selectedDate ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.text = _displayFormat.format(picked);
      });
      widget.onDateSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final input = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        controller: _controller,
        readOnly: true,
        onTap: () => _pickDate(context),
        decoration: InputDecoration(
          // If there is a selected date, show it as the label (as you requested).
          // Otherwise show the normal label text.
          label: Text(
            _selectedDate != null
                ? _displayFormat.format(_selectedDate!)
                : widget.label,
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
      ),
    );

    // Backwards-compatible: caller can disable wrapping if they already used Expanded.
    return widget.useExpanded ? Expanded(child: input) : input;
  }
}
