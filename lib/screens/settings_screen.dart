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
      body: SingleChildScrollView(  // Добавляем возможность прокрутки
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Блок выбора темы
            _buildThemeSection(localizations),
            const SizedBox(height: 24),
            // Блок выбора языка
            _buildLanguageSection(localizations),
            // Добавляем дополнительное пространство внизу
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          localizations.appearanceTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localizations.themeModeTitle),
                const SizedBox(height: 12),
                SingleChildScrollView(  // Прокрутка для вариантов темы
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildThemeChoiceChip('Light', ThemeMode.light),
                      const SizedBox(width: 8),
                      _buildThemeChoiceChip('Dark', ThemeMode.dark),
                      const SizedBox(width: 8),
                      _buildThemeChoiceChip('System', ThemeMode.system),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeChoiceChip(String label, ThemeMode mode) {
    return ChoiceChip(
      label: Text(label),
      selected: currentThemeMode == mode,
      onSelected: (selected) {
        if (selected) onThemeChanged(mode);
      },
    );
  }

  Widget _buildLanguageSection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          localizations.languageTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localizations.languageTitle),
                const SizedBox(height: 12),
                SingleChildScrollView(  // Прокрутка для вариантов языка
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildLanguageChoiceChip('English', 'en'),
                      const SizedBox(width: 8),
                      _buildLanguageChoiceChip('Русский', 'ru'),
                      const SizedBox(width: 8),
                      _buildLanguageChoiceChip('Қазақша', 'kk'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageChoiceChip(String label, String languageCode) {
    return ChoiceChip(
      label: Text(label),
      selected: currentLocale.languageCode == languageCode,
      onSelected: (selected) {
        if (selected) onLocaleChanged(Locale(languageCode));
      },
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