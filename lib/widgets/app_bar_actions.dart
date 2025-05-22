import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            themeProvider.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : themeProvider.themeMode == ThemeMode.light
                ? Icons.light_mode
                : Icons.brightness_auto,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            ThemeMode newMode;
            switch (themeProvider.themeMode) {
              case ThemeMode.light:
                newMode = ThemeMode.dark;
                break;
              case ThemeMode.dark:
                newMode = ThemeMode.system;
                break;
              default:
                newMode = ThemeMode.light;
            }
            themeProvider.setTheme(newMode);
          },
          tooltip: 'Theme',
        ),
        PopupMenuButton<Locale>(
          icon: Icon(Icons.language, color: Colors.deepPurple),
          onSelected: (Locale locale) => localeProvider.setLocale(locale),
          itemBuilder:
              (_) => [
                PopupMenuItem(
                  value: const Locale('en'),
                  child: const Text('EN'),
                ),
                PopupMenuItem(
                  value: const Locale('ru'),
                  child: const Text('RU'),
                ),
                PopupMenuItem(
                  value: const Locale('kk'),
                  child: const Text('KK'),
                ),
              ],
        ),
      ],
    );
  }
}
