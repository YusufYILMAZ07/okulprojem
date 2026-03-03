// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Okul Rehberi';

  @override
  String get menu => 'Yemek Menüsü';

  @override
  String get menuSubtitle => 'Günlük menüler ve kaloriler';

  @override
  String get shuttle => 'Servis Saatleri';

  @override
  String get shuttleSubtitle => 'Servis güzergahları';

  @override
  String get lecturers => 'Öğretim Görevlileri';

  @override
  String get lecturersSubtitle => 'Ofis & Mail';

  @override
  String get calendar => 'Akademik Takvim';

  @override
  String get calendarSubtitle => 'Dönem, sınavlar, tatiller';

  @override
  String get searchHint => 'Hoca adı ara...';

  @override
  String get office => 'Ofis';

  @override
  String get email => 'Mail';

  @override
  String get lecturerOffices => 'Hoca Ofisleri';

  @override
  String get selectLanguage => 'Dil Seç';

  @override
  String get turkish => 'Türkçe';

  @override
  String get english => 'English';

  @override
  String get loadExcel => 'Excel\'den Yükle';

  @override
  String get noData => 'Veri bulunamadı';

  @override
  String get error => 'Hata';

  @override
  String get ok => 'Tamam';

  @override
  String menusLoaded(int count) {
    return '$count günlük menü yüklendi';
  }

  @override
  String get calories => 'Kalori';

  @override
  String get totalDailyCalories => 'Günlük toplam';

  @override
  String get mealBreakdown => 'Öğün bazında';

  @override
  String get weekday => 'Hafta içi';

  @override
  String get weekend => 'Hafta sonu';

  @override
  String get upcomingEvents => 'Yaklaşan etkinlikler';

  @override
  String get semesterStart => 'Dönem başlangıcı';

  @override
  String get semesterEnd => 'Dönem bitişi';

  @override
  String get examWeek => 'Sınav haftası';

  @override
  String get holiday => 'Tatil';

  @override
  String get sendEmail => 'E-posta gönder';

  @override
  String get bakirkoy => 'Bakırköy';

  @override
  String get gayrettepe => 'Gayrettepe';

  @override
  String get mahmutbeyMetro => 'Mahmutbey Metro';

  @override
  String get yenibosna => 'Yenibosna';

  @override
  String get emptyMenu =>
      'Menü yüklenmedi. Aylık menü için \"Excel\'den Yükle\" kullanın.';

  @override
  String get emptyCalendar => 'Akademik etkinlik yok.';

  @override
  String get emptyShuttle => 'Servis verisi yok.';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get quickInfo => 'Hızlı Bilgiler';

  @override
  String get nextShuttle => 'Sıradaki Ring';

  @override
  String get nextEvent => 'Yaklaşan Etkinlik';

  @override
  String get todayMenu => 'Bugünün Menüsü';

  @override
  String get viewDetails => 'Detayları gör';

  @override
  String get welcomeBack => 'Hoş Geldin';

  @override
  String get seeMore => 'Daha Fazlası';

  @override
  String get allTimes => 'Tüm Saatler';

  @override
  String get nextDeparture => 'Sıradaki Hareket';

  @override
  String get fullCalendar => 'Tam Takvim';

  @override
  String get campusSearchHint => 'Kampüste ara...';
}
