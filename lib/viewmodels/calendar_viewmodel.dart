import 'package:flutter/foundation.dart';

import '../data/models/calendar_event.dart';
import '../data/repositories/calendar_repository.dart';

/// ViewModel for the Akademik Takvim page.
class CalendarViewModel extends ChangeNotifier {
  List<CalendarEvent> _events = [];
  bool _isLoading = false;

  // ── Getters ───────────────────────────────────────────────────────
  List<CalendarEvent> get events => _events;
  bool get isLoading => _isLoading;
  bool get hasData => _events.isNotEmpty;

  /// Events grouped by month key ("Ocak 2026", "Şubat 2026", ...).
  Map<String, List<CalendarEvent>> get groupedByMonth {
    final map = <String, List<CalendarEvent>>{};
    for (final e in _events) {
      map.putIfAbsent(e.monthKey, () => []).add(e);
    }
    return map;
  }

  /// Upcoming events (not past).
  List<CalendarEvent> get upcoming => _events.where((e) => !e.isPast).toList();

  // ── Load ──────────────────────────────────────────────────────────
  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();

    _events = await CalendarRepository.load();
    _isLoading = false;
    notifyListeners();
  }
}
