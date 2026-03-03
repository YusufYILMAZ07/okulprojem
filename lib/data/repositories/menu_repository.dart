import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/app_strings.dart';
import '../models/daily_menu.dart';
import '../services/menu_service.dart';

/// Repository that provides daily cafeteria menus.
///
/// Data sources (in priority order):
///  1. Web scraping (live)
///  2. Bundled JSON asset (offline fallback)
///  3. Hardcoded sample data (last resort)
class MenuRepository {
  MenuRepository._();

  /// Load menus: try web first, then asset, finally sample.
  static Future<({List<DailyMenu> menus, String? error})> load({
    bool forceLocal = false,
  }) async {
    if (!forceLocal) {
      final result = await MenuService.fetchMenus();
      if (result.menus.isNotEmpty) return result;
    }

    final local = await _loadFromAsset();
    if (local.isNotEmpty) return (menus: local, error: null);

    return (menus: _sampleMenus(), error: null);
  }

  static Future<List<DailyMenu>> _loadFromAsset() async {
    try {
      final str = await rootBundle.loadString(AppStrings.menuAsset);
      final list = json.decode(str) as List<dynamic>;
      return list
          .map((e) => DailyMenu.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (_) {
      return [];
    }
  }

  static List<DailyMenu> _sampleMenus() {
    final now = DateTime.now();
    return [
      DailyMenu(
        date: now,
        items: [
          const FoodItem(
            name: 'Mercimek Çorbası',
            calories: 180,
            category: FoodCategory.soup,
          ),
          const FoodItem(
            name: 'Tavuk Sote',
            calories: 320,
            category: FoodCategory.main,
          ),
          const FoodItem(
            name: 'Bulgur Pilavı',
            calories: 200,
            category: FoodCategory.side,
          ),
          const FoodItem(
            name: 'Sütlaç',
            calories: 250,
            category: FoodCategory.dessert,
          ),
        ],
      ),
    ];
  }
}
