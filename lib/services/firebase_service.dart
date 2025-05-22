import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../models/user_profile.dart';

class FirebaseService {
  static final _db = FirebaseFirestore.instance;

  static Future<List<Task>> getTasks(String uid) async {
    final snap =
        await _db.collection('users').doc(uid).collection('tasks').get();
    return snap.docs.map((doc) => Task.fromMap(doc.data())).toList();
  }

  static Future<void> addTask(String uid, Task task) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .set(task.toMap());
  }

  static Future<void> updateTask(String uid, Task task) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(task.id)
        .update(task.toMap());
  }

  static Future<void> deleteTask(String uid, String taskId) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  static Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserProfile.fromMap(doc.data()!);
    }
    return null;
  }

  static Future<void> setUserProfile(UserProfile profile) async {
    await _db.collection('users').doc(profile.uid).set(profile.toMap());
  }
}
