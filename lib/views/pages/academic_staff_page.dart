import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../viewmodels/academic_staff_viewmodel.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/staff_card.dart';

/// Akademik Kadro & Ofisler — Screen 3 in the design.
///
/// Features:
/// - Welcome greeting (shared header already provides global bar)
/// - Pembe/soluk kırmızı tonlu "AKADEMİK KADRO & OFİSLER" arama çubuğu
/// - Profile cards for each academic staff member
class AcademicStaffPage extends StatefulWidget {
  const AcademicStaffPage({super.key});

  @override
  State<AcademicStaffPage> createState() => _AcademicStaffPageState();
}

class _AcademicStaffPageState extends State<AcademicStaffPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = context.read<AcademicStaffViewModel>();
    if (!vm.hasData) vm.loadStaff();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AcademicStaffViewModel>();
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          const SizedBox(height: 8),

          // ── Welcome line ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${l10n.welcomeBack} 👋',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ),

          // ── Search bar — pembe/soluk kırmızı ───────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.crimson.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.crimson.withValues(alpha: 0.15),
                ),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: vm.search,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'AKADEMİK KADRO & OFİSLER',
                  hintStyle: TextStyle(
                    color: AppColors.crimson.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 0.3,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.crimson.withValues(alpha: 0.5),
                  ),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (_, value, __) {
                      if (value.text.isEmpty) return const SizedBox.shrink();
                      return IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          vm.clearSearch();
                        },
                      );
                    },
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),

          // ── Error banner ────────────────────────────────────────
          if (vm.errorMessage != null)
            MaterialBanner(
              content: Text(vm.errorMessage!),
              backgroundColor: AppColors.error.withValues(alpha: 0.08),
              leading: const Icon(Icons.warning_amber, color: AppColors.error),
              actions: [
                TextButton(
                  onPressed: () => vm.loadStaff(forceLocal: true),
                  child: const Text('Yerel veriyi kullan'),
                ),
              ],
            ),

          // ── Staff list ──────────────────────────────────────────
          Expanded(
            child: vm.isLoading
                ? const ShimmerLoading(itemCount: 3)
                : vm.staff.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 64, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            Text(
                              l10n.noData,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => vm.loadStaff(),
                        color: AppColors.crimson,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 4, bottom: 100),
                          itemCount: vm.staff.length,
                          itemBuilder: (context, index) {
                            return StaffCard(staff: vm.staff[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
