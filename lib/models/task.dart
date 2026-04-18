
//Models

class Task {
  final int? id;
  final int userId;
  final String title;
  final String? description;
  final String dueDate;       
  final String priority;      
  final bool isCompleted;
 
  Task({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });
 
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'due_date': dueDate,
      'priority': priority,
      'is_completed': isCompleted ? 1 : 0,
    };
  }
 
  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      title: map['title'] as String,
      description: map['description'] as String?,
      dueDate: map['due_date'] as String,
      priority: map['priority'] as String,
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }
}
 