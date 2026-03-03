import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/menu_viewmodel.dart';
import '../../viewmodels/shuttle_viewmodel.dart';
import '../widgets/section_card.dart';
import '../widgets/shimmer_loading.dart';

/// Ana Sayfa — açık erişimli, öğrenci girişi yok.
///
/// Mobil dikey (portrait) düzen:
/// 1. "Kampüste ara..." genel arama çubuğu
/// 2. GÜNLÜK YEMEK MENÜSÜ kartı (4 farklı ikonlu yemek bileşeni)
/// 3. RİNG SAATLERİ - SHUTTLE kartı (büyük saat + güzergah)
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuViewModel>().loadMenus(forceLocal: true);
      context.read<ShuttleViewModel>().loadSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            // ── Genel Arama Çubuğu ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: l10n.campusSearchHint,
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── Kart 1: GÜNLÜK YEMEK MENÜSÜ ────────────────────────
            _DailyMenuCard(),

            const SizedBox(height: 8),

            // ── Kart 2: RİNG SAATLERİ - SHUTTLE ─────────────────────
            _ShuttleCard(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GÜNLÜK YEMEK MENÜSÜ
// ─────────────────────────────────────────────────────────────────────────────

class _DailyMenuCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MenuViewModel>();
    final l10n = AppLocalizations.of(context);
    final todayMenu = vm.todayMenu;

    if (vm.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SizedBox(height: 180, child: const ShimmerLoading(itemCount: 1)),
      );
    }

    // En fazla 4 yemek kalemi göster
    final items = todayMenu?.items ?? [];
    final displayItems = items.take(4).toList();

    // Bugünün tarihi
    final now = DateTime.now();
    final dateStr = _formatTurkishDate(now);

    return SectionCard(
      title: 'GÜNLÜK YEMEK MENÜSÜ',
      titleIcon: Icons.restaurant_menu,
      actionLabel: l10n.seeMore,
      onAction: () {
        // Yemek sekmesine geçiş (index 1) — bottom nav ile
      },
      child: Column(
        children: [
          // Tarih
          Text(
            dateStr,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),

          // 4 farklı ikonlu yemek bileşeni
          if (displayItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                l10n.emptyMenu,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: displayItems.map((item) {
                return _CircularFoodIcon(
                  name: item.name,
                  icon: _foodIcon(item.category.name),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  /// Her kategori için FARKLI ikon döndür.
  IconData _foodIcon(String category) {
    switch (category) {
      case 'soup':
        return Icons.soup_kitchen; // Çorba → kase
      case 'main':
        return Icons.restaurant; // Ana yemek → et/tavuk
      case 'side':
        return Icons.rice_bowl; // Pilav → tahıl
      case 'dessert':
        return Icons.cake; // Tatlı → pasta
      default:
        return Icons.lunch_dining;
    }
  }
}

/// Dairesel yemek ikonu ve isim etiketi.
class _CircularFoodIcon extends StatelessWidget {
  final String name;
  final IconData icon;

  const _CircularFoodIcon({required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.crimson.withValues(alpha: 0.08),
              border: Border.all(
                color: AppColors.crimson.withValues(alpha: 0.20),
                width: 2,
              ),
            ),
            child: Icon(icon, color: AppColors.crimson, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.navyDark,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// RİNG SAATLERİ - SHUTTLE
// ─────────────────────────────────────────────────────────────────────────────

class _ShuttleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShuttleViewModel>();
    final l10n = AppLocalizations.of(context);

    final nextDep = vm.nextDeparture ?? '--:--';
    // Güzergah bilgisi
    String route = 'Mahmutbey → Gayrettepe';
    if (vm.campuses.isNotEmpty) {
      final campus = vm.campuses[vm.selectedCampusIndex];
      route = campus.displayName;
    }

    return SectionCard(
      title: 'RİNG SAATLERİ - SHUTTLE',
      titleIcon: Icons.directions_bus,
      actionLabel: l10n.allTimes,
      onAction: () {
        // Servis sekmesine geçiş (index 2)
      },
      child: Column(
        children: [
          // Büyük ve kalın sıradaki hareket saati
          Text(
            nextDep,
            style: const TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w900,
              color: AppColors.navyDark,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 6),
          // Güzergah bilgisi
          Text(
            route,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Yardımcılar
// ─────────────────────────────────────────────────────────────────────────────

String _formatTurkishDate(DateTime d) {
  const months = [
    '',
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
  const days = [
    '',
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];
  return '${d.day} ${months[d.month]}, ${days[d.weekday]}';
}
