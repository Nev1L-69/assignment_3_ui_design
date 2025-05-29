import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_task_manager/providers/app_settings_provider.dart';
import 'package:firebase_task_manager/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _language = 'en';
  bool _isDarkTheme = false;
  final _user = FirebaseAuth.instance.currentUser;

  Future<void> _loadSettings() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('settings')
        .doc('preferences')
        .get();

    if (doc.exists) {
      _language = doc['language'] ?? 'en';
      _isDarkTheme = doc['isDarkTheme'] ?? false;

      final provider = Provider.of<AppSettingsProvider>(context, listen: false);
      provider.loadAll(
        locale: Locale(_language),
        isDark: _isDarkTheme,
      );
    }

    setState(() {}); // Обновляем UI
  }

  Future<void> _saveSettings() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_user!.uid)
        .collection('settings')
        .doc('preferences')
        .set({
      'language': _language,
      'isDarkTheme': _isDarkTheme,
    });

    final provider = Provider.of<AppSettingsProvider>(context, listen: false);
    provider.setLocale(Locale(_language));
    provider.setTheme(_isDarkTheme);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context).get('save'))),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isDark = Provider.of<AppSettingsProvider>(context).isDarkTheme;

    final textColor = isDark ? Colors.white : Colors.black;
    final background = isDark ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(title: Text(loc.get('settings'))),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.get('theme'), style: TextStyle(color: textColor)),
            SwitchListTile(
              title: Text(loc.get('theme'), style: TextStyle(color: textColor)),
              value: _isDarkTheme,
              onChanged: (val) {
                setState(() => _isDarkTheme = val);
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .setTheme(val);
              },
            ),
            const SizedBox(height: 20),
            Text(loc.get('language'), style: TextStyle(color: textColor)),
            DropdownButton<String>(
              value: _language,
              dropdownColor: isDark ? Colors.grey[900] : null,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
                DropdownMenuItem(value: 'kk', child: Text('Қазақша')),
              ],
              onChanged: (val) {
                setState(() => _language = val!);
                Provider.of<AppSettingsProvider>(context, listen: false)
                    .setLocale(Locale(val!));
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text(loc.get('save')),
            ),
          ],
        ),
      ),
    );
  }
}
