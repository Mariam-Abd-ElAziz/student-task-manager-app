import 'package:cloud_firestore/cloud_firestore.dart';

class ApiService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ================= TASKS =================

  Future<void> addTask(Map<String, dynamic> task) async {
    final docRef = _db.collection("tasks").doc();

    task["id"] = docRef.id;

    await docRef.set(task);
  }

  Future<List<Map<String, dynamic>>> getTasks(String userId) async {
    final snapshot = await _db
        .collection("tasks")
        .where("userId", isEqualTo: userId)
        .get();

    return snapshot.docs.map((e) => e.data()).toList();
  }

  Future<void> updateTask(String taskId, Map<String, dynamic> task) async {
    await _db.collection("tasks").doc(taskId).update(task);
  }

  Future<void> deleteTask(String taskId) async {
    await _db.collection("tasks").doc(taskId).delete();
  }

  // ================= USERS =================

  Future<void> saveUser(Map<String, dynamic> user) async {
    await _db.collection("users").doc(user['studentId']).set(user);
  }

  Future<Map<String, dynamic>?> getUser(String studentId) async {
    final doc = await _db.collection("users").doc(studentId).get();
    return doc.exists ? doc.data() : null;
  }
}
