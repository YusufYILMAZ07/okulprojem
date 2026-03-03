import 'package:flutter/foundation.dart';

import '../data/models/daily_menu.dart';
import '../data/repositories/menu_repository.dart';

/// ViewModel for the Yemek Menüsü page.
class MenuViewModel extends ChangeNotifier {
  List<DailyMenu> _menus = [];
  bool _isLoading = false;
  String? _errorMessage;

  // ── Getters ───────────────────────────────────────────────────────
  List<DailyMenu> get menus => _menus;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasData => _menus.isNotEmpty;

  /// Today's menu (if available).
  DailyMenu? get todayMenu {
    final now = DateTime.now();
    try {
      return _menus.firstWhere(
        (m) =>
            m.date.year == now.year &&
            m.date.month == now.month &&
            m.date.day == now.day,
      );
    } catch (_) {
      return _menus.isNotEmpty ? _menus.first : null;
    }
  }

  // ── Load ──────────────────────────────────────────────────────────
  Future<void> loadMenus({bool forceLocal = false}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await MenuRepository.load(forceLocal: forceLocal);
      _menus = result.menus;
      _errorMessage = result.error;
    } catch (e) {
      _errorMessage = 'Menü yüklenemedi: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}
