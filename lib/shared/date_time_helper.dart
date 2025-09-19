import 'dart:developer';

import 'package:intl/intl.dart';

class DateTimeHelper {

  /// Converts "September 12, 2025" to "2025-09-12T00:00:00Z"
  static String toIsoDate(String date, {bool isStart = true}) {
    try {
      final parsedDate = DateFormat("MMMM d, yyyy").parse(date);
      final dateTime = isStart
          ? DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 0, 0, 0)
          : DateTime(parsedDate.year, parsedDate.month, parsedDate.day, 23, 59, 59);
      return dateTime.toUtc().toIso8601String();
    } catch (e) {
      log("Date parse error: $e");
      return DateTime.now().toUtc().toIso8601String(); // fallback
    }
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
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }
}
