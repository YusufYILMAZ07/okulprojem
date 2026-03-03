/// Campus shuttle schedule model.
class ShuttleCampus {
  final String id;
  final String displayName;
  final List<String> weekdayTimes;
  final List<String> weekendTimes;

  const ShuttleCampus({
    required this.id,
    required this.displayName,
    required this.weekdayTimes,
    required this.weekendTimes,
  });

  factory ShuttleCampus.fromJson(Map<String, dynamic> json) {
    return ShuttleCampus(
      id: json['id'] as String,
      displayName: _displayNameFromId(json['id'] as String),
      weekdayTimes: (json['weekday'] as List<dynamic>).cast<String>(),
      weekendTimes: (json['weekend'] as List<dynamic>).cast<String>(),
    );
  }

  /// Whether this campus has any weekend service.
  bool get hasWeekendService => weekendTimes.isNotEmpty;

  /// Returns the next departure time from now, or null if none remain today.
  String? nextDeparture({required bool isWeekend}) {
    final times = isWeekend ? weekendTimes : weekdayTimes;
    final now = DateTime.now();
    for (final t in times) {
      try {
        final parts = t.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);
        final departure = DateTime(now.year, now.month, now.day, hour, minute);
        if (departure.isAfter(now)) return t;
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  static String _displayNameFromId(String id) {
    switch (id) {
      case 'bakirkoy':
        return 'Bakırköy';
      case 'gayrettepe':
        return 'Gayrettepe';
      case 'mahmutbey_metro':
        return 'Mahmutbey Metro';
      case 'yenibosna':
        return 'Yenibosna';
      default:
        return id;
    }
  }
}
