import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user.dart';
import '../models/task.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static const String _dbName = "student_task_manager.db";
  static const int _dbVersion = 1;

  static const String tableUsers = "users";
  static const String tableTasks = "tasks";

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return await openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // USERS TABLE
    await db.execute('''
      CREATE TABLE users (
        student_id TEXT PRIMARY KEY,
        full_name TEXT NOT NULL,
        uni_email TEXT NOT NULL UNIQUE,
        gender TEXT,
        academic_level INTEGER,
        password TEXT NOT NULL,
        profile_photo TEXT
      )
    ''');

    // TASKS TABLE
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        due_date TEXT NOT NULL,
        priority TEXT NOT NULL,
        is_completed INTEGER DEFAULT 0,
        is_favorite INTEGER DEFAULT 0,
        FOREIGN KEY (user_id) REFERENCES users (student_id)
      )
    ''');
  }

  //User CRUD

  Future<int> insertUser(User user) async {
    final db = await database;
    return await db.insert(tableUsers, user.toMap());
  }

  Future<User?> getUserByCredentials(
      String email, String password) async {
    final db = await database;

    final result = await db.query(
      tableUsers,
      where: "uni_email = ? AND password = ?",
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<User?> getUserById(String studentId) async {
    final db = await database;

    final result = await db.query(
      tableUsers,
      where: "student_id = ?",
      whereArgs: [studentId],
    );

    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<int> updateUser(
      String studentId, Map<String, dynamic> data) async {
    final db = await database;

    return db.update(
      tableUsers,
      data,
      where: "student_id = ?",
      whereArgs: [studentId],
    );
  }

  // Task CRUD

  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert(tableTasks, task.toMap());
  }

  Future<List<Task>> getTasksByUser(String userId) async {
    final db = await database;

    final result = await db.query(
      tableTasks,
      where: "user_id = ?",
      whereArgs: [userId],
      orderBy: "due_date ASC",
    );

    return result.map((e) => Task.fromMap(e)).toList();
  }

  Future<int> updateTask(Task task) async {
    final db = await database;

    return db.update(
      tableTasks,
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;

    return db.delete(
      tableTasks,
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<int> toggleTask(int id, bool value) async {
    final db = await database;

    return db.update(
      tableTasks,
      {"is_completed": value ? 1 : 0},
      where: "id = ?",
      whereArgs: [id],
    );
  }

  Future<List<Task>> getFavoriteTasks(String userId) async {
  final db = await database;

  final result = await db.query(
    tableTasks,
    where: "user_id = ? AND is_favorite = ?",
    whereArgs: [userId, 1],
  );

  return result.map((e) => Task.fromMap(e)).toList();
}

Future<int> toggleFavorite(int id, bool value) async {
  final db = await database;

  return db.update(
    tableTasks,
    {"is_favorite": value ? 1 : 0},
    where: "id = ?",
    whereArgs: [id],
  );
}


  // Close db

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}