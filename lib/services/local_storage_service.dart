import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/task.dart';

class LocalStorageService {
  static late Box _taskBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _taskBox = await Hive.openBox('tasks');
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    await _taskBox.put('tasks', tasks.map((t) => t.toMap()).toList());
  }

  static List<Task> loadTasks() {
    final list = _taskBox.get('tasks', defaultValue: <Map<String, dynamic>>[]);
    return (list as List)
        .map((e) => Task.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', theme);
  }

  static Future<String?> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('themeMode');
  }
}
