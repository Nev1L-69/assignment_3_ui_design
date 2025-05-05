import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/app_localization.dart';

class HomeScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;
  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.homeTitle),
        actions: [
          if (!authService.isAuthenticated)
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text(
                localizations.login,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          if (authService.isAuthenticated)
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              child: Text(
                localizations.profileTitle,
                style: const TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (!authService.isAuthenticated)
            Container(
              color: Colors.amber,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Text(
                localizations.guestMode,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: Center(
              child: Text(
                authService.isAuthenticated
                    ? '${localizations.welcome}, ${authService.user?.email}!'
                    : '${localizations.welcome}, Guest!',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context, localizations, authService),
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
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(localizations.settingsTitle),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          if (authService.isAuthenticated) ...[
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
