import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// A single row in the shuttle timeline.
/// Highlights the [isNext] departure and shows a connecting line.
class ShuttleTimelineTile extends StatelessWidget {
  final String time;
  final bool isNext;
  final bool isFirst;
  final bool isLast;
  final bool isPast;

  const ShuttleTimelineTile({
    super.key,
    required this.time,
    required this.isNext,
    this.isFirst = false,
    this.isLast = false,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // ── Timeline line + dot ─────────────────────────────────
          SizedBox(
            width: 48,
            child: Column(
              children: [
                // Top line
                Expanded(
                  child: Container(
                    width: isFirst ? 0 : 2,
                    color: isPast
                        ? Colors.grey.shade300
                        : AppColors.crimson.withValues(alpha: 0.3),
                  ),
                ),
                // Dot
                Container(
                  width: isNext ? 20 : 12,
                  height: isNext ? 20 : 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isNext
                        ? AppColors.crimson
                        : isPast
                            ? Colors.grey.shade300
                            : AppColors.crimsonLight,
                    boxShadow: isNext
                        ? [
                            BoxShadow(
                              color: AppColors.crimson.withValues(alpha: 0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ]
                        : null,
                  ),
                  child: isNext
                      ? const Icon(Icons.directions_bus,
                          size: 12, color: Colors.white)
                      : null,
                ),
                // Bottom line
                Expanded(
                  child: Container(
                    width: isLast ? 0 : 2,
                    color: AppColors.crimson.withValues(alpha: 0.3),
                  ),
                ),
              ],
            ),
          ),

          // ── Time card ──────────────────────────────────────────
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isNext
                    ? AppColors.crimson.withValues(alpha: 0.08)
                    : isPast
                        ? Colors.white.withValues(alpha: 0.6)
                        : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isNext
                    ? Border.all(color: AppColors.crimson, width: 1.5)
                    : null,
                boxShadow: isNext
                    ? [
                        BoxShadow(
                          color: AppColors.crimson.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                children: [
                  Text(
                    time,
                    style: TextStyle(
                      fontSize: isNext ? 18 : 15,
                      fontWeight: isNext ? FontWeight.w800 : FontWeight.w500,
                      color: isPast ? Colors.grey.shade400 : AppColors.navyDark,
                    ),
                  ),
                  if (isNext) ...[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.crimson,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Sıradaki',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
