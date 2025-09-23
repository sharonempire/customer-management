import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_software/shared/styles/textstyles.dart';

class CommonDateRangePicker extends StatelessWidget {
  final String label;
  final DateTimeRange? value;
  final void Function(DateTimeRange?) onChanged;
  final bool rounded;
  final VoidCallback? onClear;

  const CommonDateRangePicker({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
    this.rounded = true,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ), // ✅ Same as Dropdown
        child: InkWell(
          onTap: () async {
            final picked = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              initialDateRange: value,
            );
            if (picked != null) {
              onChanged(picked);
            }
          },
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: myTextstyle(color: Colors.grey, fontSize: 16),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(rounded ? 10 : 0),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(rounded ? 10 : 0),
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(rounded ? 10 : 0),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
              suffixIcon: value != null && onClear != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          padding: EdgeInsets.zero,
                          splashRadius: 18,
                          tooltip: 'Clear selection',
                          onPressed: onClear,
                        ),
                        const Icon(Icons.date_range, size: 20),
                      ],
                    )
                  : const Icon(Icons.date_range, size: 20),
            ),
            child: Text(
              value != null
                  ? "${DateFormat('MMM dd, yyyy').format(value!.start)} - ${DateFormat('MMM dd, yyyy').format(value!.end)}"
                  : label,
              style: myTextstyle(
                fontSize: 16,
                color: value == null ? Colors.grey : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
