import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/locale_provider.dart';
import '../../l10n/app_localizations.dart';

/// Ayarlar sayfası — language picker.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.selectLanguage)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _langTile(
            context: context,
            flag: '🇹🇷',
            title: l10n.turkish,
            isSelected: localeProvider.isTurkish,
            onTap: () {
              localeProvider.setLocale(const Locale('tr'));
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          _langTile(
            context: context,
            flag: '🇬🇧',
            title: l10n.english,
            isSelected: !localeProvider.isTurkish,
            onTap: () {
              localeProvider.setLocale(const Locale('en'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _langTile({
    required BuildContext context,
    required String flag,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color:
          isSelected ? AppColors.crimson.withValues(alpha: 0.1) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.crimson : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(flag, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.navyDark,
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check_circle,
                    color: AppColors.crimson, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}
