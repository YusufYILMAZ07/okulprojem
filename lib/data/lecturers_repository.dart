import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/utils/turkish_utils.dart';
import 'models/lecturer.dart';

/// Loads lecturers from bundled JSON (UTF-8). Email derived from name via Turkish normalization.
class LecturersRepository {
  static const _assetPath = 'assets/data/lecturers.json';

  static Future<List<Lecturer>> load() async {
    try {
      final str = await rootBundle.loadString(_assetPath);
      final list = json.decode(str) as List<dynamic>;
      return list.map((e) {
        final map = e as Map<String, dynamic>;
        final name = map['name'] as String;
        final office = map['office'] as String;
        return Lecturer(
          name: name,
          office: office,
          email: _emailFromName(name),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Builds altinbas.edu.tr email from full name (Turkish chars normalized for ASCII).
  static String _emailFromName(String fullName) {
    final clean = turkishToAsciiLowerCase(fullName);
    final parts = clean.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return 'unknown@altinbas.edu.tr';
    if (parts.length < 2) return '${parts.first}@altinbas.edu.tr';
    return '${parts.first}.${parts.last}@altinbas.edu.tr';
  }
}
