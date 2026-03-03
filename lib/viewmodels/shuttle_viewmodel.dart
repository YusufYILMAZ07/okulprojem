import 'package:flutter/foundation.dart';

import '../data/models/shuttle_campus.dart';
import '../data/repositories/shuttle_repository.dart';

/// ViewModel for the Ring Saatleri page.
class ShuttleViewModel extends ChangeNotifier {
  List<ShuttleCampus> _campuses = [];
  bool _isLoading = false;
  bool _isWeekend = false;
  int _selectedCampusIndex = 0;

  // ── Getters ───────────────────────────────────────────────────────
  List<ShuttleCampus> get campuses => _campuses;
  bool get isLoading => _isLoading;
  bool get isWeekend => _isWeekend;
  int get selectedCampusIndex => _selectedCampusIndex;
  bool get hasData => _campuses.isNotEmpty;

  ShuttleCampus? get selectedCampus =>
      _campuses.isNotEmpty ? _campuses[_selectedCampusIndex] : null;

  List<String> get currentTimes {
    final campus = selectedCampus;
    if (campus == null) return [];
    return _isWeekend ? campus.weekendTimes : campus.weekdayTimes;
  }

  /// The next departure time string, or null if past all departures.
  String? get nextDeparture =>
      selectedCampus?.nextDeparture(isWeekend: _isWeekend);

  // ── Load ──────────────────────────────────────────────────────────
  Future<void> loadSchedule() async {
    _isLoading = true;
    notifyListeners();

    _campuses = await ShuttleRepository.load();
    _isLoading = false;

    // Auto-detect if today is weekend.
    final weekday = DateTime.now().weekday;
    _isWeekend = weekday == DateTime.saturday || weekday == DateTime.sunday;

    notifyListeners();
  }

  // ── Actions ───────────────────────────────────────────────────────
  void selectCampus(int index) {
    if (index >= 0 && index < _campuses.length) {
      _selectedCampusIndex = index;
      notifyListeners();
    }
  }

  void toggleWeekend(bool value) {
    _isWeekend = value;
    notifyListeners();
  }
}
