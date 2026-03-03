import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import 'home_page.dart';
import 'academic_staff_page.dart';
import 'menu_page.dart';
import 'shuttle_page.dart';
import 'calendar_page.dart';

/// Main application shell — bordo AppBar, 5-tab BottomNavigationBar.
///
/// Açık erişimli tasarım: Profil fotoğrafı, giriş butonu veya isim YOK.
/// AppBar: Sol → "Altınbaş Üniversitesi", Sağ → Arama ikonu.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    MenuPage(),
    ShuttlePage(),
    CalendarPage(),
    AcademicStaffPage(),
  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      // ── Bordo AppBar ───────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: AppColors.crimson,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Altınbaş Üniversitesi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: arama ekranı
            },
          ),
        ],
      ),

      // ── Page content ───────────────────────────────────────────────
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // ── Bottom Navigation ──────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.crimson,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700),
        elevation: 12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home_rounded),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu_outlined),
            activeIcon: const Icon(Icons.restaurant_menu),
            label: 'Yemek',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_bus_outlined),
            activeIcon: const Icon(Icons.directions_bus_filled),
            label: 'Ring',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month_outlined),
            activeIcon: const Icon(Icons.calendar_month),
            label: l10n.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline),
            activeIcon: const Icon(Icons.people),
            label: l10n.lecturers,
          ),
        ],
      ),
    );
  }
}
