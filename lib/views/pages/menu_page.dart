import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/menu_viewmodel.dart';
import '../widgets/menu_card.dart';
import '../widgets/shimmer_loading.dart';

/// Yemek Menüsü sayfası — daily menu with crimson header cards.
class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<MenuViewModel>();
    if (!vm.hasData) vm.loadMenus();
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MenuViewModel>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ── Page header ────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
              children: [
                Text(
                  l10n.menu,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.navyDark,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => vm.loadMenus(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.crimson.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh, size: 16, color: AppColors.crimson),
                        SizedBox(width: 4),
                        Text(
                          'Yenile',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.crimson,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Content ────────────────────────────────────────────
          Expanded(
            child: vm.isLoading
                ? const ShimmerLoading(itemCount: 5)
                : vm.menus.isEmpty
                    ? _emptyState(l10n)
                    : RefreshIndicator(
                        onRefresh: () => vm.loadMenus(),
                        color: AppColors.crimson,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 0, bottom: 100),
                          itemCount: vm.menus.length,
                          itemBuilder: (context, index) {
                            final menu = vm.menus[index];
                            return _DayMenuSection(
                              dateStr: _formatDate(menu.date),
                              totalCalories: menu.totalCalories,
                              items: menu.items,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            l10n.emptyMenu,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

/// A grouped section for one day's menu.
class _DayMenuSection extends StatelessWidget {
  final String dateStr;
  final int totalCalories;
  final List items;

  const _DayMenuSection({
    required this.dateStr,
    required this.totalCalories,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.crimson,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      dateStr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (totalCalories > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.crimson.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$totalCalories kcal',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColors.crimsonDark,
                    ),
                  ),
                ),
            ],
          ),
        ),
        // Food items
        ...List.generate(
          items.length,
          (i) => MenuCard(item: items[i], index: i),
        ),
      ],
    );
  }
}
