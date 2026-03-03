import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/calendar_viewmodel.dart';
import '../widgets/calendar_event_tile.dart';
import '../widgets/shimmer_loading.dart';

/// Akademik Takvim sayfası — events grouped by month with crimson accents.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
    final vm = context.read<CalendarViewModel>();
    if (!vm.hasData) vm.loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalendarViewModel>();
    final l10n = AppLocalizations.of(context);
    final isTurkish = context.watch<LocaleProvider>().isTurkish;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          // ── Page title ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.calendar,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.navyDark,
                ),
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────────
          Expanded(
            child: vm.isLoading
                ? const ShimmerLoading(itemCount: 6)
                : vm.events.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calendar_today,
                                size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              l10n.emptyCalendar,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _buildGroupedList(vm, isTurkish),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedList(CalendarViewModel vm, bool isTurkish) {
    final grouped = vm.groupedByMonth;
    final months = grouped.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 0, bottom: 100),
      itemCount: months.length,
      itemBuilder: (context, monthIndex) {
        final month = months[monthIndex];
        final events = grouped[month]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.crimson,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    month,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.navyDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.crimson.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${events.length}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.crimson.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Events
            ...events.map((e) => CalendarEventTile(
                  event: e,
                  isTurkish: isTurkish,
                )),
          ],
        );
      },
    );
  }
}
