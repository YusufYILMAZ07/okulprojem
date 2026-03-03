import 'package:flutter/material.dart';

/// Altınbaş University corporate color palette.
/// Koyu kırmızı / bordo (dark red/burgundy) primary
/// with lacivert (navy) accents for buttons/actions.
class AppColors {
  AppColors._();

  // ── Primary: Koyu Kırmızı / Bordo ──────────────────────────────────
  static const Color crimson = Color(0xFF8B0000);
  static const Color crimsonLight = Color(0xFFA52020);
  static const Color crimsonDark = Color(0xFF6E0000);

  // ── Accent: Lacivert (Navy) — buttons, action text ─────────────────
  static const Color navy = Color(0xFF1B2A4A);
  static const Color navyLight = Color(0xFF2C4170);
  static const Color navyDark = Color(0xFF0F1D36);

  // ── Surface & Background ────────────────────────────────────────────
  static const Color surface = Color(0xFFF5F6F8);
  static const Color surfaceVariant = Color(0xFFEEEFF3);
  static const Color background = Color(0xFFFFFFFF);
  static const Color cardWhite = Color(0xFFFFFFFF);

  // ── Semantic ────────────────────────────────────────────────────────
  static const Color success = Color(0xFF2E7D4F);
  static const Color error = Color(0xFFC62828);
  static const Color warning = Color(0xFFE67E22);
  static const Color info = Color(0xFF1565C0);

  // ── Event type colors ───────────────────────────────────────────────
  static const Color semester = Color(0xFF1565C0);
  static const Color exam = Color(0xFFC62828);
  static const Color holiday = Color(0xFF2E7D4F);

  // ── Shimmer ─────────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ── Staff card circuit pattern tints ────────────────────────────────
  static const Color circuitBg = Color(0xFFA52020);
  static const Color circuitLine = Color(0x33FFFFFF);
}
