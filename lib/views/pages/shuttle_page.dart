import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/shuttle_viewmodel.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/shuttle_timeline_tile.dart';

/// Ring Saatleri sayfası — shuttle departure timeline with crimson accents.
class ShuttlePage extends StatefulWidget {
  const ShuttlePage({super.key});

  @override
  State<ShuttlePage> createState() => _ShuttlePageState();
}

class _ShuttlePageState extends State<ShuttlePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    final vm = context.read<ShuttleViewModel>();
    if (!vm.hasData) {
      vm.loadSchedule().then((_) => _initTab());
    } else {
      _initTab();
    }
  }

  void _initTab() {
    final vm = context.read<ShuttleViewModel>();
    if (vm.campuses.isNotEmpty && mounted) {
      _tabController?.dispose();
      setState(() {
        _tabController = TabController(
          length: vm.campuses.length,
          vsync: this,
          initialIndex: vm.selectedCampusIndex,
        );
        _tabController!.addListener(() {
          if (!_tabController!.indexIsChanging) {
            vm.selectCampus(_tabController!.index);
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShuttleViewModel>();
    final l10n = AppLocalizations.of(context);

    if (_tabController == null && vm.campuses.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _initTab());
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ── Page title + toggle + tabs ─────────────────────────
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Title row
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                  child: Row(
                    children: [
                      Text(
                        l10n.shuttle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.navyDark,
                        ),
                      ),
                    ],
                  ),
                ),

                // Weekday / Weekend toggle
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ToggleChip(
                        label: l10n.weekday,
                        selected: !vm.isWeekend,
                        onTap: () => vm.toggleWeekend(false),
                      ),
                      const SizedBox(width: 8),
                      _ToggleChip(
                        label: l10n.weekend,
                        selected: vm.isWeekend,
                        onTap: () => vm.toggleWeekend(true),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Campus tabs
                if (vm.campuses.isNotEmpty && _tabController != null)
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    indicatorColor: AppColors.crimson,
                    indicatorWeight: 3,
                    labelColor: AppColors.crimson,
                    unselectedLabelColor: Colors.grey.shade500,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                    tabs: vm.campuses
                        .map((c) => Tab(text: c.displayName))
                        .toList(),
                  ),
              ],
            ),
          ),

          // ── Schedule list ──────────────────────────────────────
          Expanded(
            child: vm.isLoading
                ? const ShimmerLoading(itemCount: 8)
                : vm.campuses.isEmpty
                    ? Center(child: Text(l10n.noData))
                    : _tabController == null
                        ? const SizedBox.shrink()
                        : TabBarView(
                            controller: _tabController!,
                            children: vm.campuses.map((campus) {
                              final times = vm.isWeekend
                                  ? campus.weekendTimes
                                  : campus.weekdayTimes;

                              if (times.isEmpty) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.directions_bus_filled,
                                          size: 56,
                                          color: Colors.grey.shade300),
                                      const SizedBox(height: 12),
                                      Text(
                                        l10n.noData,
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              final nextDep =
                                  campus.nextDeparture(isWeekend: vm.isWeekend);

                              return ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 8),
                                itemCount: times.length,
                                itemBuilder: (_, i) {
                                  final time = times[i];
                                  final isNext = time == nextDep;
                                  final isPast = _isPast(time);
                                  return ShuttleTimelineTile(
                                    time: time,
                                    isNext: isNext,
                                    isFirst: i == 0,
                                    isLast: i == times.length - 1,
                                    isPast: isPast && !isNext,
                                  );
                                },
                              );
                            }).toList(),
                          ),
          ),
        ],
      ),
    );
  }

  bool _isPast(String timeStr) {
    try {
      final parts = timeStr.split(':');
      final now = DateTime.now();
      final target = DateTime(now.year, now.month, now.day, int.parse(parts[0]),
          int.parse(parts[1]));
      return target.isBefore(now);
    } catch (_) {
      return false;
    }
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.crimson
              : AppColors.crimson.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: selected ? Colors.white : AppColors.crimson,
          ),
        ),
      ),
    );
  }
}
