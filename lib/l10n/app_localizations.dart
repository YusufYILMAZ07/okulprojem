import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'School Guide'**
  String get appTitle;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Food Menu'**
  String get menu;

  /// No description provided for @menuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily menus & calories'**
  String get menuSubtitle;

  /// No description provided for @shuttle.
  ///
  /// In en, this message translates to:
  /// **'Shuttle Times'**
  String get shuttle;

  /// No description provided for @shuttleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Service routes'**
  String get shuttleSubtitle;

  /// No description provided for @lecturers.
  ///
  /// In en, this message translates to:
  /// **'Lecturers'**
  String get lecturers;

  /// No description provided for @lecturersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Office & Email'**
  String get lecturersSubtitle;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Academic Calendar'**
  String get calendar;

  /// No description provided for @calendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Semester, exams, holidays'**
  String get calendarSubtitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search lecturer name...'**
  String get searchHint;

  /// No description provided for @office.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get office;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @lecturerOffices.
  ///
  /// In en, this message translates to:
  /// **'Lecturer Offices'**
  String get lecturerOffices;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @loadExcel.
  ///
  /// In en, this message translates to:
  /// **'Load from Excel'**
  String get loadExcel;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noData;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @menusLoaded.
  ///
  /// In en, this message translates to:
  /// **'{count} daily menus loaded'**
  String menusLoaded(int count);

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @totalDailyCalories.
  ///
  /// In en, this message translates to:
  /// **'Total daily'**
  String get totalDailyCalories;

  /// No description provided for @mealBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Per meal'**
  String get mealBreakdown;

  /// No description provided for @weekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get weekday;

  /// No description provided for @weekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get weekend;

  /// No description provided for @upcomingEvents.
  ///
  /// In en, this message translates to:
  /// **'Upcoming events'**
  String get upcomingEvents;

  /// No description provided for @semesterStart.
  ///
  /// In en, this message translates to:
  /// **'Semester start'**
  String get semesterStart;

  /// No description provided for @semesterEnd.
  ///
  /// In en, this message translates to:
  /// **'Semester end'**
  String get semesterEnd;

  /// No description provided for @examWeek.
  ///
  /// In en, this message translates to:
  /// **'Exam week'**
  String get examWeek;

  /// No description provided for @holiday.
  ///
  /// In en, this message translates to:
  /// **'Holiday'**
  String get holiday;

  /// No description provided for @sendEmail.
  ///
  /// In en, this message translates to:
  /// **'Send email'**
  String get sendEmail;

  /// No description provided for @bakirkoy.
  ///
  /// In en, this message translates to:
  /// **'Bakirkoy'**
  String get bakirkoy;

  /// No description provided for @gayrettepe.
  ///
  /// In en, this message translates to:
  /// **'Gayrettepe'**
  String get gayrettepe;

  /// No description provided for @mahmutbeyMetro.
  ///
  /// In en, this message translates to:
  /// **'Mahmutbey Metro'**
  String get mahmutbeyMetro;

  /// No description provided for @yenibosna.
  ///
  /// In en, this message translates to:
  /// **'Yenibosna'**
  String get yenibosna;

  /// No description provided for @emptyMenu.
  ///
  /// In en, this message translates to:
  /// **'No menu loaded. Use \"Load from Excel\" to import monthly menu.'**
  String get emptyMenu;

  /// No description provided for @emptyCalendar.
  ///
  /// In en, this message translates to:
  /// **'No academic events.'**
  String get emptyCalendar;

  /// No description provided for @emptyShuttle.
  ///
  /// In en, this message translates to:
  /// **'No shuttle data.'**
  String get emptyShuttle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @quickInfo.
  ///
  /// In en, this message translates to:
  /// **'Quick Info'**
  String get quickInfo;

  /// No description provided for @nextShuttle.
  ///
  /// In en, this message translates to:
  /// **'Next Shuttle'**
  String get nextShuttle;

  /// No description provided for @nextEvent.
  ///
  /// In en, this message translates to:
  /// **'Next Event'**
  String get nextEvent;

  /// No description provided for @todayMenu.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Menu'**
  String get todayMenu;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @seeMore.
  ///
  /// In en, this message translates to:
  /// **'See More'**
  String get seeMore;

  /// No description provided for @allTimes.
  ///
  /// In en, this message translates to:
  /// **'All Times'**
  String get allTimes;

  /// No description provided for @nextDeparture.
  ///
  /// In en, this message translates to:
  /// **'Next Departure'**
  String get nextDeparture;

  /// No description provided for @fullCalendar.
  ///
  /// In en, this message translates to:
  /// **'Full Calendar'**
  String get fullCalendar;

  /// No description provided for @campusSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search campus...'**
  String get campusSearchHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
