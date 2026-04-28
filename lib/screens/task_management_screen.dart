// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/task_provider.dart';
// import '../db/db_helper.dart';
// import '../models/task.dart';
// import 'profile_screen.dart';
// import '../models/user.dart';

// class TaskManagementScreen extends StatefulWidget {
// final User user;

//   const TaskManagementScreen({super.key, required this.user});

//   @override
//   State<TaskManagementScreen> createState() => _TaskManagementScreenState();
// }

// class _TaskManagementScreenState extends State<TaskManagementScreen> {
//     late TaskProvider provider;
//   @override
//   void initState() {
//     super.initState();
//       Future.microtask(() {
//     Provider.of<TaskProvider>(context, listen: false)
//         .loadTasks(widget.user.studentId);
//   });
//   }



//   void _showTaskDialog({Task? task}) {
//     final isEditing = task != null;
//     final formKey = GlobalKey<FormState>();
//     final titleController = TextEditingController(text: task?.title ?? '');
//     final descController = TextEditingController(text: task?.description ?? '');
//     DateTime selectedDate =
//         task != null ? DateTime.parse(task.dueDate) : DateTime.now();
//     String priority = task?.priority ?? 'Medium';

//     showDialog(
//       context: context,
//       builder: (context) => StatefulBuilder(
//         builder: (context, setDialogState) => AlertDialog(
//           title: Text(isEditing ? 'Edit Task' : 'Add Task'),
//           content: SingleChildScrollView(
//             child: Form(
//               key: formKey,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // Title
//                   TextFormField(
//                     controller: titleController,
//                     decoration: const InputDecoration(labelText: 'Task Title *'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Task title is mandatory.';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16),

//                   // Description
//                   TextFormField(
//                     controller: descController,
//                     decoration:
//                         const InputDecoration(labelText: 'Description (Optional)'),
//                     maxLines: 3,
//                   ),
//                   const SizedBox(height: 16),

//                   // Due Date
//                   Row(
//                     children: [
//                       const Text('Due Date: '),
//                       TextButton(
//                         onPressed: () async {
//                           final picked = await showDatePicker(
//                             context: context,
//                             initialDate: selectedDate,
//                             firstDate: DateTime(2020),
//                             lastDate: DateTime(2030),
//                           );
//                           if (picked != null) {
//                             setDialogState(() => selectedDate = picked);
//                           }
//                         },
//                         child: Text(
//                           '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // Priority
//                   DropdownButtonFormField<String>(
//                     decoration: const InputDecoration(labelText: 'Priority'),
//                     value: priority,
//                     items: ['Low', 'Medium', 'High']
//                         .map((p) => DropdownMenuItem(value: p, child: Text(p)))
//                         .toList(),
//                     onChanged: (value) {
//                       if (value != null) {
//                         setDialogState(() => priority = value);
//                       }
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (formKey.currentState!.validate()) {
//                   final newTask = Task(
//                     id: task?.id,
//                     title: titleController.text,
//                     description: descController.text.isEmpty
//                         ? null
//                         : descController.text,
//                     dueDate:
//                         '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
//                     priority: priority,
//                     isCompleted: task?.isCompleted ?? false,
//                     userId: widget.user.studentId,
//                   );
//                   print('Inserting task with userId: ${newTask.userId}'); 
//       print('Task map: ${newTask.toMap()}'); 

//                   if (isEditing) {
//                     await Provider.of<TaskProvider>(context, listen: false)
//                     .updateTask(newTask, widget.user.studentId);
//                   } else {
//                     await Provider.of<TaskProvider>(context, listen: false)
//                     .addTask(newTask, widget.user.studentId);
//                   }

//                   Navigator.pop(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(
//                           isEditing ? 'Task updated.' : 'Task added.'),
//                     ),
//                   );
//                 }
//               },
//               child: Text(isEditing ? 'Save' : 'Add'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _deleteTask(Task task) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Delete Task'),
//         content: Text('Are you sure you want to delete "${task.title}"?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (confirm == true) {
//       await Provider.of<TaskProvider>(context, listen: false)
//     .deleteTask(task.id!, widget.user.studentId);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Task deleted.')),
//       );
//     }
//   }

//   Future<void> _toggleComplete(Task task) async {
//     task.isCompleted = !task.isCompleted;
//     await Provider.of<TaskProvider>(context, listen: false)
//     .updateTask(task, widget.user.studentId);
//   }

//   @override
//   Widget build(BuildContext context) {
//       final provider = Provider.of<TaskProvider>(context);
//       final tasks = provider.tasks;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Tasks'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.person),
//             tooltip: 'Profile',
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => ProfileScreen(user: widget.user),
//                 ),
//               );

//             },
//           ),
//         ],
//       ),
//       body: tasks.isEmpty
//           ? const Center(child: Text('No tasks yet. Tap + to add one.'))
//           : ListView.builder(
//               padding: const EdgeInsets.all(16),
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 final task = tasks[index];
//                 return Card(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   child: ListTile(
//                     leading: Checkbox(
//                       value: task.isCompleted,
//                       onChanged: (_) => _toggleComplete(task),
//                     ),
//                     title: Text(
//                       task.title,
//                       style: TextStyle(
//                         decoration: task.isCompleted
//                             ? TextDecoration.lineThrough
//                             : null,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (task.description != null &&
//                             task.description!.isNotEmpty)
//                           Text(task.description!),
//                         Text(
//                             'Due: ${task.dueDate}  |  Priority: ${task.priority}'),
//                       ],
//                     ),
//                     isThreeLine: true,
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         IconButton(
//                           icon: const Icon(Icons.edit),
//                           onPressed: () => _showTaskDialog(task: task),
//                         ),
//                         IconButton(
//                           icon: const Icon(Icons.delete),
//                           onPressed: () => _deleteTask(task),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => _showTaskDialog(),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../models/user.dart';
import 'profile_screen.dart';
import 'favorite_tasks_screen.dart';

class TaskManagementScreen extends StatefulWidget {
  final User user;

  const TaskManagementScreen({super.key, required this.user});

  @override
  State<TaskManagementScreen> createState() =>
      _TaskManagementScreenState();
}

class _TaskManagementScreenState
    extends State<TaskManagementScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<TaskProvider>(context, listen: false)
          .loadTasks(widget.user.studentId);
    });
  }

  // ================= ADD / EDIT TASK =================
  void _showTaskDialog({Task? task}) {
    final isEditing = task != null;
    final formKey = GlobalKey<FormState>();

    final titleController =
        TextEditingController(text: task?.title ?? '');
    final descController =
        TextEditingController(text: task?.description ?? '');

    DateTime selectedDate =
        task != null ? DateTime.parse(task.dueDate) : DateTime.now();

    String priority = task?.priority ?? 'Medium';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Task' : 'Add Task'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration:
                        const InputDecoration(labelText: 'Task Title *'),
                    validator: (value) =>
                        value == null || value.isEmpty
                            ? 'Task title is mandatory'
                            : null,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: descController,
                    decoration: const InputDecoration(
                        labelText: 'Description (Optional)'),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      const Text('Due Date: '),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedDate = picked);
                          }
                        },
                        child: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: priority,
                    decoration:
                        const InputDecoration(labelText: 'Priority'),
                    items: ['Low', 'Medium', 'High']
                        .map((p) =>
                            DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() => priority = value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final newTask = Task(
                    id: task?.id,
                    title: titleController.text,
                    description: descController.text.isEmpty
                        ? null
                        : descController.text,
                    dueDate:
                        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                    priority: priority,
                    isCompleted: task?.isCompleted ?? false,
                    isFavorite: task?.isFavorite ?? false, // ⭐ IMPORTANT
                    userId: widget.user.studentId,
                  );

                  if (isEditing) {
                    await Provider.of<TaskProvider>(context,
                            listen: false)
                        .updateTask(newTask, widget.user.studentId);
                  } else {
                    await Provider.of<TaskProvider>(context,
                            listen: false)
                        .addTask(newTask, widget.user.studentId);
                  }

                  Navigator.pop(context);
                }
              },
              child: Text(isEditing ? 'Save' : 'Add'),
            )
          ],
        ),
      ),
    );
  }

  // ================= DELETE =================
  Future<void> _deleteTask(Task task) async {
    await Provider.of<TaskProvider>(context, listen: false)
        .deleteTask(task.id!, widget.user.studentId);
  }

  // ================= COMPLETE =================
  Future<void> _toggleComplete(Task task) async {
    task.isCompleted = !task.isCompleted;
    await Provider.of<TaskProvider>(context, listen: false)
        .updateTask(task, widget.user.studentId);
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = provider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),

        // ⭐ FAVORITE SCREEN NAVIGATION
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FavoriteTasksScreen(user: widget.user),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ProfileScreen(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),

      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (_) => _toggleComplete(task),
                    ),

                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),

                    subtitle: Text(
                        'Due: ${task.dueDate} | Priority: ${task.priority}'),

                    // ⭐ FAVORITE BUTTON ADDED HERE
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            task.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: task.isFavorite
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: () {
                            Provider.of<TaskProvider>(context,
                                    listen: false)
                                .toggleFavorite(
                                    task, widget.user.studentId);
                          },
                        ),

                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showTaskDialog(task: task),
                        ),

                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteTask(task),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}