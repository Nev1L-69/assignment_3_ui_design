import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_localization.dart';
import '../services/auth_service.dart';

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
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.settingsTitle),
      ),
      drawer: _buildDrawer(context, localizations, authService),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildThemeSection(localizations),
            const SizedBox(height: 24),
            _buildLanguageSection(localizations),
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
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildThemeChoiceChip(localizations, 'light', ThemeMode.light),
                      const SizedBox(width: 8),
                      _buildThemeChoiceChip(localizations, 'dark', ThemeMode.dark),
                      const SizedBox(width: 8),
                      _buildThemeChoiceChip(localizations, 'system', ThemeMode.system),
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

  Widget _buildThemeChoiceChip(AppLocalizations localizations, String labelKey, ThemeMode mode) {
    String label;
    switch (labelKey) {
      case 'light':
        label = 'Light'; // Если хочешь - можно добавить в локализацию
        break;
      case 'dark':
        label = 'Dark';
        break;
      case 'system':
        label = 'System';
        break;
      default:
        label = labelKey;
    }

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
                SingleChildScrollView(
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

  Widget _buildDrawer(BuildContext context, AppLocalizations localizations, AuthService authService) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Text(
              localizations.navigation,
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
          if (authService.isAuthenticated) ...[
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(localizations.settingsTitle),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(localizations.profileTitle),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(localizations.logout),
              onTap: () async {
                await authService.logout();
                Navigator.pop(context);
              },
            ),
          ],
        ],
      ),
    );
  }
}
