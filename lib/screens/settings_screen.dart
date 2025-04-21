import 'package:flutter/material.dart';
import '../services/app_localization.dart';

class SettingsScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;
  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
      ),
      drawer: _buildDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.appearanceTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.themeModeTitle),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceChip(
                          label: const Text('Light'),
                          selected: currentThemeMode == ThemeMode.light,
                          onSelected: (selected) {
                            if (selected) onThemeChanged(ThemeMode.light);
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Dark'),
                          selected: currentThemeMode == ThemeMode.dark,
                          onSelected: (selected) {
                            if (selected) onThemeChanged(ThemeMode.dark);
                          },
                        ),
                        ChoiceChip(
                          label: const Text('System'),
                          selected: currentThemeMode == ThemeMode.system,
                          onSelected: (selected) {
                            if (selected) onThemeChanged(ThemeMode.system);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              localizations.languageTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.languageTitle),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ChoiceChip(
                          label: const Text('English'),
                          selected: currentLocale.languageCode == 'en',
                          onSelected: (selected) {
                            if (selected) onLocaleChanged(const Locale('en'));
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Русский'),
                          selected: currentLocale.languageCode == 'ru',
                          onSelected: (selected) {
                            if (selected) onLocaleChanged(const Locale('ru'));
                          },
                        ),
                        ChoiceChip(
                          label: const Text('Қазақша'),
                          selected: currentLocale.languageCode == 'kk',
                          onSelected: (selected) {
                            if (selected) onLocaleChanged(const Locale('kk'));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              localizations.welcome,
              style: const TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(localizations.homeTitle),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(localizations.aboutTitle),
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(localizations.settingsTitle),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}