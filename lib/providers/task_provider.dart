import 'package:flutter/material.dart';
import '../models/task.dart';
import '../db/db_helper.dart';

class TaskProvider extends ChangeNotifier {
  final DatabaseHelper db = DatabaseHelper.instance;

  List<Task> _tasks = [];
  List<Task> _favoriteTasks = [];

  List<Task> get tasks => _tasks;
  List<Task> get favoriteTasks => _favoriteTasks;

  Future<void> loadTasks(String userId) async {
    _tasks = await db.getTasksByUser(userId);
    notifyListeners();
  }

  Future<void> loadFavorites(String userId) async {
    _favoriteTasks = await db.getFavoriteTasks(userId);
    notifyListeners();
  }

  Future<void> addTask(Task task, String userId) async {
    await db.insertTask(task);
    await loadTasks(userId);
  }

  Future<void> updateTask(Task task, String userId) async {
    await db.updateTask(task);
    await loadTasks(userId);
    await loadFavorites(userId);
  }

  Future<void> deleteTask(int id, String userId) async {
    await db.deleteTask(id);
    await loadTasks(userId);
    await loadFavorites(userId);
  }

  Future<void> toggleCompleted(Task task, String userId) async {
    await db.toggleTask(task.id!, !task.isCompleted);
    await loadTasks(userId);
  }

  Future<void> toggleFavorite(Task task, String userId) async {
    await db.toggleFavorite(task.id!, !task.isFavorite);
    await loadTasks(userId);
    await loadFavorites(userId);
  }
}