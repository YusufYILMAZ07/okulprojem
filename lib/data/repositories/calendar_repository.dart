import 'dart:convert';

import 'package:flutter/services.dart';

import '../../core/constants/app_strings.dart';
import '../models/calendar_event.dart';

/// Repository for academic calendar events (static JSON).
class CalendarRepository {
  CalendarRepository._();

  static Future<List<CalendarEvent>> load() async {
    try {
      final str = await rootBundle.loadString(AppStrings.academicCalendarAsset);
      final map = json.decode(str) as Map<String, dynamic>;
      final list = map['events'] as List<dynamic>;
      return list
          .map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.date.compareTo(b.date));
    } catch (_) {
      return [];
    }
  }
}
