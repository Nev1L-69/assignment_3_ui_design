import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;
  final Function(Locale) onLocaleChanged;
  final Locale currentLocale;

  const ProfileScreen({
    super.key,
    required this.onThemeChanged,
    required this.currentThemeMode,
    required this.onLocaleChanged,
    required this.currentLocale,
  });

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    if (!authService.isAuthenticated) {
      // Если вдруг кто-то без входа сюда попал
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Email: ${authService.user?.email ?? ''}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 24),
            const Text(
              'Theme:',
              style: TextStyle(fontSize: 16),
            ),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: currentThemeMode == ThemeMode.dark,
              onChanged: (bool value) {
                onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Language:',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<Locale>(
              value: currentLocale,
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('ru'),
                  child: Text('Русский'),
                ),
                DropdownMenuItem(
                  value: Locale('kk'),
                  child: Text('Қазақша'),
                ),
              ],
              onChanged: (Locale? newLocale) {
                if (newLocale != null) {
                  onLocaleChanged(newLocale);
                }
              },
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await authService.logout();
                  Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                },
                child: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
