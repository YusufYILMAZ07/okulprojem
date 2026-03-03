import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/app_strings.dart';
import '../models/shuttle_campus.dart';

/// Repository for campus shuttle schedules (static JSON).
class ShuttleRepository {
  ShuttleRepository._();

  static Future<List<ShuttleCampus>> load() async {
    try {
      final str = await rootBundle.loadString(AppStrings.shuttleAsset);
      final map = json.decode(str) as Map<String, dynamic>;
      final list = map['campuses'] as List<dynamic>;
      return list
          .map((e) => ShuttleCampus.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
