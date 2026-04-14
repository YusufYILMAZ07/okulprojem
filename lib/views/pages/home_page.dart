import 'package:flutter/material.dart';
import 'dart:async';

import '../../core/constants/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color _accent = Color(0xFF8B0000);
  static const List<String> _campuses = [
    'Mahmutbey',
    'Gayrettepe',
    'Bakırköy',
  ];

  final Map<String, List<String>> _ringTimesByCampus = const {
    'Mahmutbey': ['08:00', '10:30', '12:30', '15:00', '17:15'],
    'Gayrettepe': ['08:20', '11:00', '13:00', '15:40', '18:00'],
    'Bakırköy': ['07:50', '10:00', '12:10', '14:30', '16:45'],
  };

  final Map<String, String> _routeByCampus = const {
    'Mahmutbey': 'Mahmutbey -> Gayrettepe',
    'Gayrettepe': 'Gayrettepe -> Bakırköy',
    'Bakırköy': 'Bakırköy -> Mahmutbey',
  };

  final Map<String, List<_MenuItem>> _menuByCampus = const {
    'Mahmutbey': [
      _MenuItem('Çorba', 'Mercimek', Icons.soup_kitchen),
      _MenuItem('Ana Yemek', 'Tavuk Sote', Icons.lunch_dining),
      _MenuItem('Pilav', 'Bulgur Pilavı', Icons.rice_bowl),
      _MenuItem('Tatlı', 'Sütlaç', Icons.cake),
    ],
    'Gayrettepe': [
      _MenuItem('Çorba', 'Ezogelin', Icons.soup_kitchen),
      _MenuItem('Ana Yemek', 'Etli Nohut', Icons.lunch_dining),
      _MenuItem('Pilav', 'Şehriyeli Pirinç', Icons.rice_bowl),
      _MenuItem('Tatlı', 'Revani', Icons.cake),
    ],
    'Bakırköy': [
      _MenuItem('Çorba', 'Domates', Icons.soup_kitchen),
      _MenuItem('Ana Yemek', 'Fırın Makarna', Icons.lunch_dining),
      _MenuItem('Pilav', 'Sebzeli Bulgur', Icons.rice_bowl),
      _MenuItem('Tatlı', 'Kazandibi', Icons.cake),
    ],
  };

  final List<_AcademicEvent> _academicCalendar = [
    _AcademicEvent(DateTime(2026, 3, 10), 'Vize Başvurularının Son Günü'),
    _AcademicEvent(DateTime(2026, 3, 18), 'Ara Sınav Haftası Başlangıcı'),
    _AcademicEvent(DateTime(2026, 4, 2), 'Ara Tatil Başlangıcı'),
    _AcademicEvent(DateTime(2026, 4, 14), 'Derslerin Yeniden Başlaması'),
    _AcademicEvent(DateTime(2026, 5, 20), 'Final Sınav Programı İlanı'),
  ];

  String _selectedCampus = _campuses.first;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  String? getNextShuttle() {
    final now = DateTime.now();
    final times = _ringTimesByCampus[_selectedCampus] ?? const [];

    for (final time in times) {
      final parts = time.split(':');
      final departure = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      if (departure.isAfter(now)) {
        return time;
      }
    }
    return null;
  }

  _AcademicEvent? getUpcomingEvent() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    for (final event in _academicCalendar) {
      final eventDay =
          DateTime(event.date.year, event.date.month, event.date.day);
      if (!eventDay.isBefore(today)) {
        return event;
      }
    }
    return null;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final nextShuttle = getNextShuttle();
    final route = _routeByCampus[_selectedCampus] ?? '';
    final selectedMenu = _menuByCampus[_selectedCampus] ?? const [];
    final upcomingEvent = getUpcomingEvent();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Column(
              children: [
                _SearchBar(accent: _accent),
                const SizedBox(height: 12),
                _CampusSelector(
                  campuses: _campuses,
                  selectedCampus: _selectedCampus,
                  onCampusSelected: (campus) {
                    setState(() => _selectedCampus = campus);
                  },
                  accent: _accent,
                ),
                const SizedBox(height: 16),
                _RingCard(
                  nextShuttle: nextShuttle,
                  route: route,
                  accent: _accent,
                ),
                const SizedBox(height: 12),
                _AcademicCalendarCard(
                  upcomingEvent: upcomingEvent,
                  dateText: upcomingEvent == null
                      ? ''
                      : _formatDate(upcomingEvent.date),
                  accent: _accent,
                ),
                const SizedBox(height: 12),
                _MenuCard(
                  selectedCampus: _selectedCampus,
                  menuItems: selectedMenu,
                  accent: _accent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        readOnly: true,
        decoration: InputDecoration(
          hintText: 'Kampüste ara...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: accent),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _CampusSelector extends StatelessWidget {
  const _CampusSelector({
    required this.campuses,
    required this.selectedCampus,
    required this.onCampusSelected,
    required this.accent,
  });

  final List<String> campuses;
  final String selectedCampus;
  final ValueChanged<String> onCampusSelected;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      isSelected: campuses.map((c) => c == selectedCampus).toList(),
      onPressed: (index) => onCampusSelected(campuses[index]),
      borderRadius: BorderRadius.circular(12),
      constraints: const BoxConstraints(minHeight: 40, minWidth: 108),
      selectedBorderColor: accent,
      borderColor: Colors.grey.shade300,
      fillColor: accent,
      color: Colors.grey.shade700,
      selectedColor: Colors.white,
      children: campuses
          .map((campus) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  campus,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ))
          .toList(),
    );
  }
}

class _RingCard extends StatelessWidget {
  const _RingCard({
    required this.nextShuttle,
    required this.route,
    required this.accent,
  });

  final String? nextShuttle;
  final String route;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
              text: 'RİNG SAATLERİ',
              icon: Icons.directions_bus,
              accent: accent),
          const SizedBox(height: 12),
          Text(
            nextShuttle ?? 'Bugün için seferler tamamlandı',
            style: TextStyle(
              color: nextShuttle == null
                  ? Colors.grey.shade700
                  : AppColors.navyDark,
              fontSize: nextShuttle == null ? 16 : 40,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            route,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AcademicCalendarCard extends StatelessWidget {
  const _AcademicCalendarCard({
    required this.upcomingEvent,
    required this.dateText,
    required this.accent,
  });

  final _AcademicEvent? upcomingEvent;
  final String dateText;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardTitle(
                  text: 'AKADEMİK TAKVİM',
                  icon: Icons.calendar_month,
                  accent: accent,
                ),
                const SizedBox(height: 10),
                Text(
                  upcomingEvent?.name ?? 'Yaklaşan etkinlik bulunmuyor',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateText,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: accent, size: 28),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.selectedCampus,
    required this.menuItems,
    required this.accent,
  });

  final String selectedCampus;
  final List<_MenuItem> menuItems;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(
              text: 'GÜNÜN MENÜSÜ',
              icon: Icons.restaurant_menu,
              accent: accent),
          const SizedBox(height: 2),
          Text(
            selectedCampus,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: menuItems
                .map(
                  (item) => _CircularMenuIcon(item: item, accent: accent),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CircularMenuIcon extends StatelessWidget {
  const _CircularMenuIcon({required this.item, required this.accent});

  final _MenuItem item;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border:
                  Border.all(color: accent.withValues(alpha: 0.35), width: 1.4),
            ),
            child: Icon(item.icon, color: accent, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            item.type,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            item.name,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  const _BaseCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  const _CardTitle({
    required this.text,
    required this.icon,
    required this.accent,
  });

  final String text;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: accent),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: accent,
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final String type;
  final String name;
  final IconData icon;

  const _MenuItem(this.type, this.name, this.icon);
}

class _AcademicEvent {
  final DateTime date;
  final String name;

  const _AcademicEvent(this.date, this.name);
}
