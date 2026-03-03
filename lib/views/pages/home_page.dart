import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/menu_viewmodel.dart';
import '../../viewmodels/shuttle_viewmodel.dart';
import '../widgets/section_card.dart';
import '../widgets/shimmer_loading.dart';

/// Ana Sayfa — Açık erişimli, öğrenci girişi yok.
///
/// Mobil dikey (portrait) düzen, SafeArea + SingleChildScrollView:
/// 1. "Kampüste ara..." genel arama çubuğu
/// 2. GÜNLÜK YEMEK MENÜSÜ kartı (4 farklı ikonlu yemek, "Daha Fazlası")
/// 3. RİNG SAATLERİ (SHUTTLE) kartı (büyük saat + güzergah, "Tüm Saatler")
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── A. Global Arama Çubuğu ──────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
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
                  hintText: l10n.campusSearchHint,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── B. Günlük Yemek Menüsü Kartı ───────────────────────
            const _DailyMenuCard(),

            const SizedBox(height: 16),

            // ── C. Ring Saatleri (Shuttle) Kartı ────────────────────
            const _ShuttleCard(),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// B. GÜNLÜK YEMEK MENÜSÜ KARTI
// ─────────────────────────────────────────────────────────────────────────────

class _DailyMenuCard extends StatelessWidget {
  const _DailyMenuCard();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MenuViewModel>();
    final l10n = AppLocalizations.of(context);
    final todayMenu = vm.todayMenu;

    if (vm.isLoading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SizedBox(
          height: 180,
          child: const ShimmerLoading(itemCount: 1),
        ),
      );
    }

    // En fazla 4 yemek öğesi
    final items = todayMenu?.items ?? [];
    final displayItems = items.take(4).toList();

    // Bugünün tarihi
    final now = DateTime.now();
    final dateStr = _formatTurkishDate(now);

    // Veri yoksa varsayılan örnek yemekler göster
    final bool useDefaults = displayItems.isEmpty;
    final List<_FoodItemData> foodItems = useDefaults
        ? const [
            _FoodItemData('Mercimek\nÇorbası', Icons.soup_kitchen),
            _FoodItemData('Tavuk\nSote', Icons.restaurant),
            _FoodItemData('Pilav', Icons.eco),
            _FoodItemData('Sütlaç', Icons.cake),
          ]
        : displayItems
            .map((item) => _FoodItemData(
                  item.name,
                  _categoryIcon(item.category.name),
                ))
            .toList();

    return SectionCard(
      title: 'GÜNLÜK YEMEK MENÜSÜ',
      titleIcon: Icons.restaurant_menu,
      actionLabel: l10n.seeMore,
      margin: EdgeInsets.zero,
      onAction: () {
        // Yemek sekmesine geçiş
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: foodItems
                .map((f) => _CircularFoodIcon(name: f.name, icon: f.icon))
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// Her kategori için ayrı ikon.
IconData _categoryIcon(String category) {
  switch (category) {
    case 'soup':
      return Icons.soup_kitchen; // Çorba
    case 'main':
      return Icons.restaurant; // Ana yemek
    case 'side':
      return Icons.eco; // Pilav / Salata
    case 'dessert':
      return Icons.cake; // Tatlı
    default:
      return Icons.lunch_dining;
  }
}

/// Yemek verisi.
class _FoodItemData {
  final String name;
  final IconData icon;
  const _FoodItemData(this.name, this.icon);
}

/// Dairesel ikon + yemek ismi bileşeni.
/// İkonların etrafında ince çizgili dairesel çerçeve.
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
              color: Colors.white,
              border: Border.all(
                color: AppColors.crimson.withValues(alpha: 0.3),
                width: 1.5,
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
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// C. RİNG SAATLERİ (SHUTTLE) KARTI
// ─────────────────────────────────────────────────────────────────────────────

class _ShuttleCard extends StatelessWidget {
  const _ShuttleCard();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShuttleViewModel>();
    final l10n = AppLocalizations.of(context);

    final nextDep = vm.nextDeparture ?? '12:30';
    // Güzergah bilgisi
    String route = '(Mahmutbey -> Gayrettepe)';
    if (vm.campuses.isNotEmpty) {
      final campus = vm.campuses[vm.selectedCampusIndex];
      route = '(${campus.displayName})';
    }

    return SectionCard(
      title: 'RİNG SAATLERİ (SHUTTLE)',
      titleIcon: Icons.directions_bus,
      actionLabel: l10n.allTimes,
      margin: EdgeInsets.zero,
      onAction: () {
        // Servis sekmesine geçiş
      },
      child: Column(
        children: [
          // "Sıradaki Hareket" etiketi
          Text(
            l10n.nextDeparture,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          // Büyük kalın saat
          Text(
            nextDep,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: AppColors.navyDark,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
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
