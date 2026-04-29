import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/api_service.dart';

class TaskProvider extends ChangeNotifier {
  final ApiService _api = ApiService();

  List<Task> tasks = [];
  List<Task> favoriteTasks = [];

  // ================= LOAD ALL TASKS =================
  Future<void> loadTasks(String userId) async {
    final data = await _api.getTasks(userId);

    tasks = data.map((e) => Task.fromMap(e)).toList();

    _filterFavorites();

    notifyListeners();
  }

  // ================= FAVORITES =================
  void _filterFavorites() {
    favoriteTasks = tasks.where((t) => t.isFavorite == true).toList();
  }

  Future<void> loadFavorites(String userId) async {
    await loadTasks(userId); // reuse same data
  }

  // ================= ADD =================
  Future<void> addTask(Task task, String userId) async {
    await _api.addTask(task.toMap());
    await loadTasks(userId);
  }

  // ================= UPDATE =================
  Future<void> updateTask(Task task, String userId) async {
    await _api.updateTask(task.id!, task.toMap());
    await loadTasks(userId);
  }

  // ================= DELETE =================
  Future<void> deleteTask(String taskId, String userId) async {
    await _api.deleteTask(taskId);
    await loadTasks(userId);
  }

  // ================= TOGGLE FAVORITE =================
  Future<void> toggleFavorite(Task task, String userId) async {
    task.isFavorite = !task.isFavorite;

    await updateTask(task, userId);
  }
}
