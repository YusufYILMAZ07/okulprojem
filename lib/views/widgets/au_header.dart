import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// Global crimson header bar used on all screens.
///
/// Left: University logo + "Altınbaş Üniversitesi" text.
/// Right: Search icon + profile avatar (+ optional notification bell).
class AuHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showNotificationBell;
  final VoidCallback? onSearchTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  const AuHeader({
    super.key,
    this.showNotificationBell = false,
    this.onSearchTap,
    this.onProfileTap,
    this.onNotificationTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.crimson,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // ── Logo ─────────────────────────────────────────
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'AÜ',
                      style: TextStyle(
                        color: AppColors.crimson,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Altınbaş Üniversitesi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // ── Actions ──────────────────────────────────────
                _HeaderIconButton(
                  icon: Icons.search,
                  onTap: onSearchTap,
                ),
                if (showNotificationBell) ...[
                  const SizedBox(width: 4),
                  _HeaderIconButton(
                    icon: Icons.notifications_outlined,
                    onTap: onNotificationTap,
                  ),
                ],
                const SizedBox(width: 8),
                // Profile avatar
                GestureDetector(
                  onTap: onProfileTap,
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _HeaderIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
