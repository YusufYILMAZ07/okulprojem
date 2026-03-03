/// Academic calendar event (semester start, exam, holiday, etc.).
class CalendarEvent {
  final String type;
  final DateTime date;
  final DateTime? endDate; // For ranged events (e.g., exam weeks).
  final String titleTr;
  final String titleEn;

  const CalendarEvent({
    required this.type,
    required this.date,
    this.endDate,
    required this.titleTr,
    required this.titleEn,
  });

  String title({required bool isTurkish}) => isTurkish ? titleTr : titleEn;

  /// Group key: "Ocak 2026"
  String get monthKey {
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
    return '${months[date.month]} ${date.year}';
  }

  bool get isPast => date.isBefore(DateTime.now());

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      type: json['type'] as String,
      date: DateTime.parse(json['date'] as String),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'] as String)
          : null,
      titleTr: json['titleTr'] as String,
      titleEn: json['titleEn'] as String,
    );
  }
}
