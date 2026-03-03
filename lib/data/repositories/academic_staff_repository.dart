import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/app_strings.dart';
import '../../core/utils/turkish_utils.dart';
import '../models/academic_staff.dart';
import '../services/academic_staff_service.dart';

/// Repository that provides academic staff data.
///
/// Data sources (in priority order):
///  1. Web scraping (live site)
///  2. Bundled JSON asset (offline fallback)
class AcademicStaffRepository {
  AcademicStaffRepository._();

  /// Fetch staff from website first, fallback to local asset.
  static Future<({List<AcademicStaff> staff, String? error})> load({
    bool forceLocal = false,
  }) async {
    if (!forceLocal) {
      final result = await AcademicStaffService.fetchStaff();
      if (result.staff.isNotEmpty) return result;
    }

    // Fallback: bundled JSON.
    final local = await _loadFromAsset();
    return (staff: local, error: null);
  }

  /// Parse the bundled lecturers.json into [AcademicStaff] models.
  static Future<List<AcademicStaff>> _loadFromAsset() async {
    try {
      final str = await rootBundle.loadString(AppStrings.lecturersAsset);
      final list = json.decode(str) as List<dynamic>;
      return list.map((e) {
        final map = e as Map<String, dynamic>;
        final name = map['name'] as String;
        final office = map['office'] as String;
        return AcademicStaff(
          name: name,
          title: _extractTitle(name),
          email: _emailFromName(name),
          office: office,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  static String _extractTitle(String fullName) {
    final patterns = [
      'Prof. Dr.',
      'Doç. Dr.',
      'Dr. Öğr. Üyesi',
      'Öğr. Gör. Dr.',
      'Öğr. Gör.',
      'Arş. Gör. Dr.',
      'Arş. Gör.',
    ];
    for (final p in patterns) {
      if (fullName.startsWith(p)) return p;
    }
    return '';
  }

  static String _emailFromName(String fullName) {
    // Remove title prefix.
    var clean = fullName;
    final title = _extractTitle(fullName);
    if (title.isNotEmpty) {
      clean = fullName.replaceFirst(title, '').trim();
    }
    clean = turkishToAsciiLowerCase(clean);
    final parts =
        clean.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return 'unknown@altinbas.edu.tr';
    if (parts.length < 2) return '${parts.first}@altinbas.edu.tr';
    return '${parts.first}.${parts.last}@altinbas.edu.tr';
  }
}
