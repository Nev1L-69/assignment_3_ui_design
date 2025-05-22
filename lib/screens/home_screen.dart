import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController inputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final localeProvider = context.watch<LocaleProvider>();
    final tasks = taskProvider.tasks;
    final isLoading = taskProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Planner'),
        actions: [
          // Языки
          DropdownButton<Locale>(
            value: localeProvider.locale,
            underline: const SizedBox(),
            onChanged: (v) {
              if (v != null) localeProvider.setLocale(v);
            },
            items: const [
              DropdownMenuItem(value: Locale('en'), child: Text('EN')),
              DropdownMenuItem(value: Locale('ru'), child: Text('RU')),
              DropdownMenuItem(value: Locale('kk'), child: Text('KK')),
            ],
          ),
          // Тема
          IconButton(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode
                  : themeProvider.themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : Icons.brightness_4,
            ),
            onPressed: () {
              final next =
                  themeProvider.themeMode == ThemeMode.light
                      ? ThemeMode.dark
                      : themeProvider.themeMode == ThemeMode.dark
                      ? ThemeMode.system
                      : ThemeMode.light;
              themeProvider.setTheme(next);
            },
            tooltip: 'Switch Theme',
          ),
          // Переходы
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            tooltip: 'Profile',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
            tooltip: 'History',
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
            tooltip: 'About',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child:
                        tasks.isEmpty
                            ? const Center(child: Text('No tasks yet.'))
                            : ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder:
                                  (_, i) => ListTile(
                                    title: Text(tasks[i].title),
                                    trailing: Checkbox(
                                      value: tasks[i].isDone,
                                      onChanged: (val) {
                                        final updated = Task(
                                          id: tasks[i].id,
                                          title: tasks[i].title,
                                          isDone: val ?? false,
                                          created: tasks[i].created,
                                        );
                                        context.read<TaskProvider>().updateTask(
                                          context,
                                          updated,
                                        );
                                      },
                                    ),
                                    onLongPress:
                                        () => context
                                            .read<TaskProvider>()
                                            .deleteTask(context, tasks[i].id),
                                  ),
                            ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: inputController,
                            decoration: const InputDecoration(
                              labelText: 'New Task',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final title = inputController.text.trim();
                            if (title.isNotEmpty) {
                              final task = Task(
                                id:
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString(),
                                title: title,
                                isDone: false,
                                created: DateTime.now(),
                              );
                              await context.read<TaskProvider>().addTask(
                                context,
                                task,
                              );
                              inputController.clear();
                            }
                          },
                          child: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }
}
