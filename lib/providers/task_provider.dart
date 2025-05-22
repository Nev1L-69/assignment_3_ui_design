import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/local_storage_service.dart';
import '../services/firebase_service.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  Future<void> loadTasks(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    if (uid != null) {
      try {
        _tasks = await FirebaseService.getTasks(uid);
      } catch (e) {
        _tasks = LocalStorageService.loadTasks();
      }
    } else {
      _tasks = LocalStorageService.loadTasks();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(BuildContext context, Task task) async {
    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    _tasks.add(task);
    notifyListeners();
    if (uid != null) {
      await FirebaseService.addTask(uid, task);
    }
    await LocalStorageService.saveTasks(_tasks);
  }

  Future<void> updateTask(BuildContext context, Task updated) async {
    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    final idx = _tasks.indexWhere((t) => t.id == updated.id);
    if (idx != -1) _tasks[idx] = updated;
    notifyListeners();
    if (uid != null) {
      await FirebaseService.updateTask(uid, updated);
    }
    await LocalStorageService.saveTasks(_tasks);
  }

  Future<void> deleteTask(BuildContext context, String id) async {
    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
    if (uid != null) {
      await FirebaseService.deleteTask(uid, id);
    }
    await LocalStorageService.saveTasks(_tasks);
  }
}
