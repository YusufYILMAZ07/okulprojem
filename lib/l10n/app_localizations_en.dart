// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'School Guide';

  @override
  String get menu => 'Food Menu';

  @override
  String get menuSubtitle => 'Daily menus & calories';

  @override
  String get shuttle => 'Shuttle Times';

  @override
  String get shuttleSubtitle => 'Service routes';

  @override
  String get lecturers => 'Lecturers';

  @override
  String get lecturersSubtitle => 'Office & Email';

  @override
  String get calendar => 'Academic Calendar';

  @override
  String get calendarSubtitle => 'Semester, exams, holidays';

  @override
  String get searchHint => 'Search lecturer name...';

  @override
  String get office => 'Office';

  @override
  String get email => 'Email';

  @override
  String get lecturerOffices => 'Lecturer Offices';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get loadExcel => 'Load from Excel';

  @override
  String get noData => 'No data found';

  @override
  String get error => 'Error';

  @override
  String get ok => 'OK';

  @override
  String menusLoaded(int count) {
    return '$count daily menus loaded';
  }

  @override
  String get calories => 'Calories';

  @override
  String get totalDailyCalories => 'Total daily';

  @override
  String get mealBreakdown => 'Per meal';

  @override
  String get weekday => 'Weekday';

  @override
  String get weekend => 'Weekend';

  @override
  String get upcomingEvents => 'Upcoming events';

  @override
  String get semesterStart => 'Semester start';

  @override
  String get semesterEnd => 'Semester end';

  @override
  String get examWeek => 'Exam week';

  @override
  String get holiday => 'Holiday';

  @override
  String get sendEmail => 'Send email';

  @override
  String get bakirkoy => 'Bakirkoy';

  @override
  String get gayrettepe => 'Gayrettepe';

  @override
  String get mahmutbeyMetro => 'Mahmutbey Metro';

  @override
  String get yenibosna => 'Yenibosna';

  @override
  String get emptyMenu =>
      'No menu loaded. Use \"Load from Excel\" to import monthly menu.';

  @override
  String get emptyCalendar => 'No academic events.';

  @override
  String get emptyShuttle => 'No shuttle data.';

  @override
  String get home => 'Home';

  @override
  String get quickInfo => 'Quick Info';

  @override
  String get nextShuttle => 'Next Shuttle';

  @override
  String get nextEvent => 'Next Event';

  @override
  String get todayMenu => 'Today\'s Menu';

  @override
  String get viewDetails => 'View details';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get seeMore => 'See More';

  @override
  String get allTimes => 'All Times';

  @override
  String get nextDeparture => 'Next Departure';

  @override
  String get fullCalendar => 'Full Calendar';

  @override
  String get campusSearchHint => 'Search campus...';
}
