import 'package:intl/intl.dart';

class DateTimeHelper {
  static String formatDate(DateTime date) {
    return DateFormat('EEEE, MMMM d, y').format(date);
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
