/// Hard-coded strings / URLs that are not localized.
class AppStrings {
  AppStrings._();

  static const String appName = 'Altınbaş Kampüs';

  // ── Web scraping endpoints ─────────────────────────────────────────
  static const String academicStaffUrl =
      'https://www.altinbas.edu.tr/tr/akademik-kadro';

  static const String menuUrl = 'https://www.altinbas.edu.tr/tr/yemek-menusu';

  // ── Asset paths ────────────────────────────────────────────────────
  static const String academicCalendarAsset =
      'assets/data/academic_calendar.json';
  static const String lecturersAsset = 'assets/data/lecturers.json';
  static const String menuAsset = 'assets/data/monthly_menu.json';
  static const String shuttleAsset = 'assets/data/shuttle_schedule.json';
}
