import 'package:intl/intl.dart';

/// Shared date formatting helpers.
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dayMonth = DateFormat('dd MMM');
  static final DateFormat _dayMonthYear = DateFormat('dd MMM yyyy');
  static final DateFormat _time = DateFormat('HH:mm');

  /// "03 Mar"
  static String shortDate(DateTime d) => _dayMonth.format(d);

  /// "03 Mar 2026"
  static String fullDate(DateTime d) => _dayMonthYear.format(d);

  /// "09:30"
  static String time(DateTime d) => _time.format(d);

  /// "9 dk" — minutes until [target] from now; returns null if past.
  static String? minutesUntil(String timeStr) {
    try {
      final parts = timeStr.split(':');
      final now = DateTime.now();
      final target = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      final diff = target.difference(now).inMinutes;
      if (diff <= 0) return null;
      return '$diff dk';
    } catch (_) {
      return null;
    }
  }

  /// Returns the Turkish month name for [month] (1‑based).
  static String turkishMonth(int month) {
    const months = [
      '',
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return months[month.clamp(1, 12)];
  }
}
