import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import 'models/daily_menu.dart';

/// Loads monthly menu from bundled JSON or from Excel/CSV picked by user.
/// Excel format: col0 = date (YYYY-MM-DD or date), col1.. = food name; optional last col = calories per row or per-item column.
/// JSON format: [{ "date": "YYYY-MM-DD", "items": [{ "name": "...", "calories": 123 }] }]
class MenuRepository {
  static const _assetPath = 'assets/data/monthly_menu.json';

  /// Load from asset. If file missing or invalid, returns empty list.
  static Future<List<DailyMenu>> loadFromAsset() async {
    try {
      final str = await rootBundle.loadString(_assetPath);
      final list = json.decode(str) as List<dynamic>;
      return list.map((e) {
        final m = e as Map<String, dynamic>;
        final date = DateTime.parse(m['date'] as String);
        final items = (m['items'] as List<dynamic>).map((i) {
          final im = i as Map<String, dynamic>;
          return FoodItem(
            name: im['name'] as String,
            calories: im['calories'] as int?,
          );
        }).toList();
        return DailyMenu(date: date, items: items);
      }).toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (_) {
      return [];
    }
  }

  /// Pick file (xlsx/xls/csv) and parse. Returns null if user cancels or parse fails.
  static Future<List<DailyMenu>?> loadFromFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
    );
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.single;
    final bytes = file.bytes;
    if (bytes == null || bytes.isEmpty) return null;
    if (file.extension?.toLowerCase() == 'csv') {
      return _parseCsv(bytes);
    }
    return _parseExcel(bytes);
  }

  static List<DailyMenu>? _parseExcel(List<int> bytes) {
    try {
      final excel = Excel.decodeBytes(Uint8List.fromList(bytes));
      final menus = <DailyMenu>[];
      for (final table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;
        for (var rowIndex = 1; rowIndex < sheet.maxRows; rowIndex++) {
          final row = sheet.rows[rowIndex];
          if (row.isEmpty) continue;
          final dateCell = row[0];
          if (dateCell == null) continue;
          DateTime? date;
          try {
            if (dateCell.value is DateTime) {
              date = dateCell.value as DateTime;
            } else if (dateCell.value is String) {
              date = DateTime.tryParse((dateCell.value as String).trim());
            }
          } catch (_) {
            continue;
          }
          if (date == null) continue;
          final items = <FoodItem>[];
          for (var colIndex = 1; colIndex < row.length; colIndex++) {
            final cell = row[colIndex];
            if (cell == null || cell.value == null) continue;
            final name = cell.value.toString().trim();
            if (name.isEmpty) continue;
            items.add(FoodItem(name: name));
          }
          if (items.isNotEmpty) menus.add(DailyMenu(date: date, items: items));
        }
      }
      menus.sort((a, b) => a.date.compareTo(b.date));
      return menus;
    } catch (_) {
      return null;
    }
  }

  static List<DailyMenu>? _parseCsv(List<int> bytes) {
    try {
      final str = utf8.decode(bytes);
      final lines = str.split(RegExp(r'\r?\n'));
      if (lines.isEmpty) return null;
      final menus = <DailyMenu>[];
      for (var i = 1; i < lines.length; i++) {
        final line = lines[i];
        if (line.trim().isEmpty) continue;
        final parts = _parseCsvLine(line);
        if (parts.isEmpty) continue;
        final date = DateTime.tryParse(parts[0].trim());
        if (date == null) continue;
        final items = parts
            .skip(1)
            .where((s) => s.trim().isNotEmpty)
            .map((s) => FoodItem(name: s.trim()))
            .toList();
        if (items.isNotEmpty) menus.add(DailyMenu(date: date, items: items));
      }
      menus.sort((a, b) => a.date.compareTo(b.date));
      return menus;
    } catch (_) {
      return null;
    }
  }

  static List<String> _parseCsvLine(String line) {
    final result = <String>[];
    var current = StringBuffer();
    var inQuotes = false;
    for (var i = 0; i < line.length; i++) {
      final c = line[i];
      if (c == '"') {
        inQuotes = !inQuotes;
      } else if ((c == ',' && !inQuotes) || c == ';') {
        result.add(current.toString());
        current = StringBuffer();
      } else {
        current.write(c);
      }
    }
    result.add(current.toString());
    return result;
  }

  /// Sample data when no asset/file available.
  static List<DailyMenu> getSampleMenus() {
    final now = DateTime.now();
    return [
      DailyMenu(
        date: now,
        items: [
          FoodItem(name: 'Mercimek Çorbası', calories: 180),
          FoodItem(name: 'Döner', calories: 350),
          FoodItem(name: 'Pirinç Pilavı', calories: 200),
          FoodItem(name: 'Tatlı', calories: 250),
        ],
      ),
    ];
  }
}
