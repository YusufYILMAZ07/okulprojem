import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Beyaz arka planlı, yuvarlak köşeli, hafif gölgeli bilgi kartı.
///
/// Kart Başlığı: Bordo arka planlı, üst köşeleri yuvarlak, alt köşeleri düz.
/// Aksiyon Butonu: Açık gri arka planlı, hap şeklinde (StadiumBorder).
class SectionCard extends StatelessWidget {
  final String title;
  final IconData? titleIcon;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsets margin;

  const SectionCard({
    super.key,
    required this.title,
    this.titleIcon,
    required this.child,
    this.actionLabel,
    this.onAction,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Bordo başlık barı (üst köşeleri yuvarlak, alt düz) ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.crimson,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (titleIcon != null) ...[
                  Icon(titleIcon, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // ── İçerik ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),

          // ── Aksiyon butonu (hap şeklinde, açık gri) ────────────
          if (actionLabel != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Center(
                child: TextButton(
                  onPressed: onAction,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.navyDark,
                    backgroundColor: Colors.grey.shade100,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    actionLabel!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
