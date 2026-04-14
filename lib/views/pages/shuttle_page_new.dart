import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Shuttle (Servis Saatleri) Sayfası — Responsive mobil tasarım.
///
/// Özellikler:
/// - Kurumsal renkler (Kırmızı + Lacivert)
/// - Her güzergah Card içinde, saatler Chip şeklinde
/// - Info Banner (duyuru mesajı)
/// - Mobil-first, responsive
class ShuttlePageNew extends StatelessWidget {
  const ShuttlePageNew({super.key});

  static const List<Map<String, dynamic>> shuttleSchedules = [
    {
      "route": "Mahmutbey - Bakırköy Kampüs",
      "times": ["07:30", "11:00", "*16:00"]
    },
    {
      "route": "Bakırköy Kampüs - Mahmutbey",
      "times": ["08:20", "12:00", "17:00"]
    },
    {
      "route": "Mahmutbey - Gayrettepe",
      "times": ["07:15", "12:00", "16:00"]
    },
    {
      "route": "Gayrettepe - Mahmutbey",
      "times": ["08:40", "13:00", "17:00"]
    },
    {
      "route": "Mahmutbey Metro - Mahmutbey",
      "times": ["08:10", "08:20", "13:00"]
    },
    {
      "route": "Mahmutbey - Mahmutbey Metro",
      "times": ["08:15", "12:45", "17:00"]
    },
    {
      "route": "Mahmutbey - Yenibosna",
      "times": ["14:00", "16:00"]
    },
    {
      "route": "Yenibosna - Mahmutbey",
      "times": ["07:45", "08:00"]
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── İnfo Banner — Duyuru ───────────────────────────────────
            _InfoBanner(),

            const SizedBox(height: 20),

            // ── Güzergahlar Listesi ────────────────────────────────────
            ...shuttleSchedules.map((schedule) => _RouteCard(
                  route: schedule['route'] as String,
                  times: List<String>.from(schedule['times'] as List),
                )),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// İNFO BANNER — DUYURU
// ─────────────────────────────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.crimson.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.crimson.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Icon(
            Icons.info_outlined,
            color: AppColors.crimson,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Değerli Altınbaş Üniversitesi Mensupları, 19 Şubat - 19 Mart 2026 Tarihi itibari ile hafta içi öğrenci shuttle servisleri bu saatlerde hizmet verecektir.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade800,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GÜZERGAH KARTI — ROUTE CARD
// ─────────────────────────────────────────────────────────────────────────────

class _RouteCard extends StatelessWidget {
  final String route;
  final List<String> times;

  const _RouteCard({required this.route, required this.times});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Güzergah Başlığı (Bordo arka plan) ──────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: AppColors.crimson,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.directions_bus, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    route,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // ── Saatler (Yatay Chip'ler) ───────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: times.map((time) => _TimeChip(time: time)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SAAT CHIP — TIME CHIP
// ─────────────────────────────────────────────────────────────────────────────

class _TimeChip extends StatelessWidget {
  final String time;

  const _TimeChip({required this.time});

  // * işareti var mı kontrol et (sıradaki hareket)
  bool get isNextDeparture => time.startsWith('*');
  String get displayTime => time.replaceAll('*', '').trim();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isNextDeparture ? AppColors.crimson : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isNextDeparture ? AppColors.crimson : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isNextDeparture)
            const Padding(
              padding: EdgeInsets.only(right: 4),
              child: Icon(Icons.star, color: Colors.white, size: 14),
            ),
          Text(
            displayTime,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isNextDeparture ? Colors.white : AppColors.navyDark,
            ),
          ),
        ],
      ),
    );
  }
}
