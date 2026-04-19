import 'package:cloud_firestore/cloud_firestore.dart';

class ApiService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Sync task to Firebase
  Future<void> syncTask(Map<String, dynamic> task) async {
    await _db.collection("tasks").add(task);
    print("Task synced to Firebase ✅");
  }

  Future<Map<String, dynamic>?> getUser(String studentId) async {
  final doc = await _db.collection("users").doc(studentId).get();
  if (doc.exists) {
    return doc.data();
  }
  return null;
}

  // Get all tasks from Firebase
  Future<List<Map<String, dynamic>>> getTasks(String userId) async {
    final snapshot = await _db
        .collection("tasks")
        .where("userId", isEqualTo: userId)
        .get();
    return snapshot.docs.map((d) => d.data()).toList();
  }

  // Save user to Firebase
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _db.collection("users").doc(user['studentId']).set(user);
    print("User saved to Firebase ✅");
  }

  // Delete task from Firebase
  Future<void> deleteTask(String taskId) async {
    await _db.collection("tasks").doc(taskId).delete();
    print("Task deleted from Firebase ✅");
  }
}