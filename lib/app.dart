import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'viewmodels/academic_staff_viewmodel.dart';
import 'viewmodels/calendar_viewmodel.dart';
import 'viewmodels/menu_viewmodel.dart';
import 'viewmodels/shuttle_viewmodel.dart';
import 'views/pages/app_shell.dart';

class AuProflutApp extends StatelessWidget {
  const AuProflutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AcademicStaffViewModel()),
        ChangeNotifierProvider(create: (_) => MenuViewModel()),
        ChangeNotifierProvider(create: (_) => ShuttleViewModel()),
        ChangeNotifierProvider(create: (_) => CalendarViewModel()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Altınbaş Kampüs',
            locale: localeProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: AppTheme.light,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}
