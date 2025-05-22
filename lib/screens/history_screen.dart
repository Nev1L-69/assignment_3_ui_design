import 'package:flutter/material.dart';
import '../widgets/app_bar_actions.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Здесь список завершённых задач или заметок
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: const [AppBarActions()],
      ),
      body: const Center(child: Text('Task History')),
    );
  }
}
