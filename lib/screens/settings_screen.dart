import 'package:flutter/material.dart';
import '../widgets/app_bar_actions.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: const [AppBarActions()],
      ),
      body: const Center(
        child: Text('Settings (theme/language buttons вверху)'),
      ),
    );
  }
}
