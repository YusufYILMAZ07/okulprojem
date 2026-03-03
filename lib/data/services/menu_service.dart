import 'package:html/parser.dart' as html_parser;

import '../../core/constants/app_strings.dart';
import '../../core/network/web_scraper.dart';
import '../models/daily_menu.dart';

/// Service that scrapes the daily cafeteria menu from
/// Altınbaş University's website.
class MenuService {
  MenuService._();

  /// Fetch today's (or this week's) menu from the website.
  ///
  /// Returns parsed menus + optional error message.
  static Future<({List<DailyMenu> menus, String? error})> fetchMenus() async {
    try {
      final htmlBody = await WebScraper.fetchHtml(AppStrings.menuUrl);
      final document = html_parser.parse(htmlBody);

      final menus = <DailyMenu>[];

      // ── Strategy 1: Table-based menu ──────────────────────────
      final tables = document.querySelectorAll('table');
      for (final table in tables) {
        final rows = table.querySelectorAll('tr');
        for (final row in rows) {
          final cells = row.querySelectorAll('td');
          if (cells.length < 2) continue;

          // First cell might be date or day name.
          final dateText = cells[0].text.trim();
          final date = _tryParseDate(dateText);
          if (date == null) continue;

          final items = <FoodItem>[];
          for (var i = 1; i < cells.length; i++) {
            final name = cells[i].text.trim();
            if (name.isNotEmpty) {
              items.add(FoodItem(
                name: name,
                category: _guessCategory(name, i),
              ));
            }
          }
          if (items.isNotEmpty) {
            menus.add(DailyMenu(date: date, items: items));
          }
        }
      }

      // ── Strategy 2: Card/div based ────────────────────────────
      if (menus.isEmpty) {
        final cards = document.querySelectorAll(
          '.menu-card, .menu-item, [class*="menu"], [class*="yemek"]',
        );
        for (final card in cards) {
          final text = card.text.trim();
          if (text.length < 5) continue;
          final lines = text
              .split(RegExp(r'[\n\r]+'))
              .map((l) => l.trim())
              .where((l) => l.isNotEmpty)
              .toList();
          if (lines.length < 2) continue;

          final date = _tryParseDate(lines.first);
          if (date == null) continue;

          final items = <FoodItem>[];
          for (var i = 1; i < lines.length; i++) {
            items.add(FoodItem(
              name: lines[i],
              category: _guessCategory(lines[i], i),
            ));
          }
          if (items.isNotEmpty) {
            menus.add(DailyMenu(date: date, items: items));
          }
        }
      }

      if (menus.isEmpty) {
        return (
          menus: <DailyMenu>[],
          error: 'Menü verisi çekilemedi. Site yapısı değişmiş olabilir.',
        );
      }

      menus.sort((a, b) => a.date.compareTo(b.date));
      return (menus: menus, error: null);
    } on WebScraperException catch (e) {
      return (menus: <DailyMenu>[], error: e.message);
    } catch (e) {
      return (
        menus: <DailyMenu>[],
        error: 'Menü ayrıştırma hatası: $e',
      );
    }
  }

  /// Attempt to parse a date from various formats.
  static DateTime? _tryParseDate(String text) {
    // Try ISO format first.
    final iso = DateTime.tryParse(text);
    if (iso != null) return iso;

    // Try dd.MM.yyyy or dd/MM/yyyy.
    final match = RegExp(r'(\d{1,2})[./](\d{1,2})[./](\d{4})').firstMatch(text);
    if (match != null) {
      return DateTime.tryParse(
        '${match.group(3)}-${match.group(2)!.padLeft(2, '0')}-'
        '${match.group(1)!.padLeft(2, '0')}',
      );
    }

    return null;
  }

  /// Guess category from index position or keywords.
  static FoodCategory _guessCategory(String name, int index) {
    final lower = name.toLowerCase();
    if (lower.contains('çorba') || lower.contains('soup')) {
      return FoodCategory.soup;
    }
    if (lower.contains('tatlı') ||
        lower.contains('dessert') ||
        lower.contains('meyve') ||
        lower.contains('komposto')) {
      return FoodCategory.dessert;
    }
    if (lower.contains('pilav') ||
        lower.contains('makarna') ||
        lower.contains('salata') ||
        lower.contains('piyaz')) {
      return FoodCategory.side;
    }
    // Positional fallback: 1=soup, 2=main, 3=side, 4=dessert
    switch (index) {
      case 1:
        return FoodCategory.soup;
      case 2:
        return FoodCategory.main;
      case 3:
        return FoodCategory.side;
      case 4:
        return FoodCategory.dessert;
      default:
        return FoodCategory.other;
    }
  }
}
