import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/academic_staff.dart';

/// Profile card for a single academic staff member — matches Screen 3.
///
/// Layout:
/// - Top half: crimson gradient with circuit pattern (decorative circles/lines)
/// - Centered: circular profile photo overlapping both halves
/// - Below: Name + Department
/// - Three crimson action buttons (E-posta, Telefon, Konum)
/// - Bottom: "Ofis: Mahmutbey M304" info
class StaffCard extends StatelessWidget {
  final AcademicStaff staff;

  const StaffCard({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // ── Top: circuit-pattern crimson bg + avatar ────────────
          SizedBox(
            height: 130,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Circuit pattern background
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CircuitPatternPainter(),
                  ),
                ),
                // Avatar — positioned to overflow into white area
                Positioned(
                  bottom: -36,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor:
                          AppColors.crimson.withValues(alpha: 0.15),
                      backgroundImage: staff.imageUrl != null
                          ? NetworkImage(staff.imageUrl!)
                          : null,
                      child: staff.imageUrl == null
                          ? Text(
                              _initials,
                              style: const TextStyle(
                                color: AppColors.crimson,
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 44), // space for avatar overflow

          // ── Name + Department ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  staff.displayName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: AppColors.navyDark,
                  ),
                ),
                if (staff.department != null &&
                    staff.department!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    staff.department!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Three action buttons (E-posta, Telefon, Konum) ─────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionCircleBtn(
                icon: Icons.email_outlined,
                label: 'E-posta',
                onTap: () {},
              ),
              const SizedBox(width: 20),
              _ActionCircleBtn(
                icon: Icons.phone_outlined,
                label: 'Telefon',
                onTap: () {},
              ),
              const SizedBox(width: 20),
              _ActionCircleBtn(
                icon: Icons.location_on_outlined,
                label: 'Konum',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Office info ─────────────────────────────────────────
          if (staff.office.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.meeting_room_outlined,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(
                    'Ofis: ${staff.office}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String get _initials {
    final parts = staff.name.split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return staff.name.isNotEmpty ? staff.name[0].toUpperCase() : '?';
  }
}

/// Small circular crimson action button with icon + label.
class _ActionCircleBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCircleBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.crimson,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Painter for the crimson circuit/tech pattern background.
class _CircuitPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base crimson gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.crimson, AppColors.circuitBg],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Circuit lines
    final linePaint = Paint()
      ..color = AppColors.circuitLine
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Horizontal lines
    for (double y = 20; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }
    // Vertical lines
    for (double x = 30; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }

    // Circuit dots at intersections
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;
    for (double y = 20; y < size.height; y += 28) {
      for (double x = 30; x < size.width; x += 40) {
        canvas.drawCircle(Offset(x, y), 2.5, dotPaint);
      }
    }

    // Decorative larger circles
    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width * 0.2, size.height * 0.3), 30, circlePaint);
    canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.6), 25, circlePaint);
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.1), 20, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
