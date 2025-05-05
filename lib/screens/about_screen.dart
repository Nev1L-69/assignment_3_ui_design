import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_localization.dart';
import '../services/auth_service.dart';

class AboutScreen extends StatelessWidget {
  final Locale currentLocale;

  const AboutScreen({super.key, required this.currentLocale});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.aboutTitle),
      ),
      drawer: _buildDrawer(context, localizations, authService),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            localizations.aboutText,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
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
              Navigator.pop(context); // остаёмся на About
            },
          ),
          if (authService.isAuthenticated) ...[
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(localizations.settingsTitle),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
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
