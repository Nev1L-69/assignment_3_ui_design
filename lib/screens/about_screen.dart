import 'package:flutter/material.dart';
import '../widgets/app_bar_actions.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        actions: const [AppBarActions()],
      ),
      body: const Center(
        child: Text(
          'Daily Planner\nВерсия 1.0\nАвтор: Team',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
