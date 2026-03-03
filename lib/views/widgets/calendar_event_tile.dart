import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/calendar_event.dart';

/// A single calendar event row with a colored badge/chip for event type.
class CalendarEventTile extends StatelessWidget {
  final CalendarEvent event;
  final bool isTurkish;

  const CalendarEventTile({
    super.key,
    required this.event,
    required this.isTurkish,
  });

  @override
  Widget build(BuildContext context) {
    final isPast = event.isPast;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // ── Date box ──────────────────────────────────────────
            Container(
              width: 52,
              height: 56,
              decoration: BoxDecoration(
                color: isPast
                    ? Colors.grey.shade100
                    : _typeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${event.date.day}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isPast ? Colors.grey.shade400 : _typeColor,
                    ),
                  ),
                  Text(
                    _monthAbbr,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isPast ? Colors.grey.shade400 : _typeColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // ── Title + badge ─────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title(isTurkish: isTurkish),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isPast ? Colors.grey.shade400 : AppColors.navyDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildBadge(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _typeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_typeIcon, size: 13, color: _typeColor),
          const SizedBox(width: 4),
          Text(
            _typeLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _typeColor,
            ),
          ),
        ],
      ),
    );
  }

  String get _monthAbbr {
    const abbrs = [
      '',
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return abbrs[event.date.month.clamp(1, 12)];
  }

  Color get _typeColor {
    switch (event.type) {
      case 'semester_start':
      case 'semester_end':
        return AppColors.semester;
      case 'exam_week':
        return AppColors.exam;
      case 'holiday':
        return AppColors.holiday;
      default:
        return AppColors.warning;
    }
  }

  IconData get _typeIcon {
    switch (event.type) {
      case 'semester_start':
        return Icons.play_circle_outline;
      case 'semester_end':
        return Icons.stop_circle_outlined;
      case 'exam_week':
        return Icons.quiz_outlined;
      case 'holiday':
        return Icons.celebration_outlined;
      default:
        return Icons.event;
    }
  }

  String get _typeLabel {
    switch (event.type) {
      case 'semester_start':
        return 'Dönem Başlangıcı';
      case 'semester_end':
        return 'Dönem Sonu';
      case 'exam_week':
        return 'Sınav Haftası';
      case 'holiday':
        return 'Tatil';
      default:
        return 'Etkinlik';
    }
  }
}
