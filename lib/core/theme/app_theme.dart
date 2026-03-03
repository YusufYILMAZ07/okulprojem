import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// Altınbaş University — Material 3 theme.
/// Koyu kırmızı/bordo primary, lacivert accent palette.
class AppTheme {
  AppTheme._();

  // ── Color Scheme ───────────────────────────────────────────────────
  static final ColorScheme _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.crimson,
    onPrimary: Colors.white,
    primaryContainer: AppColors.crimsonLight,
    onPrimaryContainer: Colors.white,
    secondary: AppColors.navy,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.navyLight.withValues(alpha: 0.20),
    onSecondaryContainer: AppColors.navyDark,
    tertiary: AppColors.info,
    onTertiary: Colors.white,
    surface: AppColors.surface,
    onSurface: AppColors.navyDark,
    surfaceContainerHighest: AppColors.surfaceVariant,
    error: AppColors.error,
    onError: Colors.white,
    outline: AppColors.crimsonLight.withValues(alpha: 0.18),
  );

  // ── ThemeData ──────────────────────────────────────────────────────
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      textTheme: GoogleFonts.nunitoSansTextTheme(),
    );

    return base.copyWith(
      // AppBar — koyu kırmızı
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.crimson,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.nunitoSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Card — elevated white with rounded corners
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        surfaceTintColor: Colors.transparent,
        color: AppColors.cardWhite,
      ),

      // Bottom Navigation — white bg, crimson selected
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.crimson,
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),

      // NavigationBar (Material 3 variant)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.crimson.withValues(alpha: 0.12),
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.nunitoSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.crimson,
            );
          }
          return GoogleFonts.nunitoSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.crimson, size: 24);
          }
          return IconThemeData(color: Colors.grey.shade500, size: 24);
        }),
      ),

      // Chips
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        selectedColor: AppColors.crimson.withValues(alpha: 0.15),
        labelStyle:
            GoogleFonts.nunitoSans(fontSize: 13, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),

      // ElevatedButton — lacivert (navy)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle:
              GoogleFonts.nunitoSans(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.crimson,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.crimson, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.surface,
    );
  }
}
