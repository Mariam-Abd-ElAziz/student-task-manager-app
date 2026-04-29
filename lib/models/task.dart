class Task {
  String? id;
  String title;
  String? description;
  String dueDate;
  String priority;
  bool isCompleted;
  bool isFavorite;
  String userId;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.isFavorite,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "dueDate": dueDate,
      "priority": priority,
      "isCompleted": isCompleted,
      "isFavorite": isFavorite,
      "userId": userId,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map["id"],
      title: map["title"],
      description: map["description"],
      dueDate: map["dueDate"],
      priority: map["priority"],
      isCompleted: map["isCompleted"] ?? false,
      isFavorite: map["isFavorite"] ?? false,
      userId: map["userId"],
    );
  }
}
