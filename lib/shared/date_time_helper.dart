import 'dart:developer';

import 'package:intl/intl.dart';

class DateTimeHelper {
  /// Converts friendly date strings (e.g. "September 12, 2025") to an ISO8601 day boundary in UTC.
  static String toIsoDate(String date, {bool isStart = true}) {
    final parsedDate = parseDate(date);
    if (parsedDate == null) {
      log('Date parse error: could not parse "$date"');
      return DateTime.now().toUtc().toIso8601String(); // fallback
    }

    final normalized =
        isStart
            ? DateTime(
              parsedDate.year,
              parsedDate.month,
              parsedDate.day,
              0,
              0,
              0,
            )
            : DateTime(
              parsedDate.year,
              parsedDate.month,
              parsedDate.day,
              23,
              59,
              59,
            );
    return normalized.toUtc().toIso8601String();
  }

  static String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, y').format(date);
  }

  static String formatDateForLead(DateTime date) {
    return DateFormat('MMMM d, y').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static DateTime? parseDate(String? dateString) {
    if (dateString == null || dateString.trim().isEmpty) return null;
    final value = dateString.trim();

    try {
      return DateTime.parse(value);
    } catch (_) {}

    const patterns = [
      'MMMM d, y',
      'MMMM d, yyyy',
      'MMM d, y',
      'y-MM-dd',
      'yyyy-MM-dd',
      'dd-MM-yyyy',
      'dd/MM/yyyy',
    ];

    for (final pattern in patterns) {
      try {
        return DateFormat(pattern).parse(value);
      } catch (_) {}
    }

    return null;
  }
}
