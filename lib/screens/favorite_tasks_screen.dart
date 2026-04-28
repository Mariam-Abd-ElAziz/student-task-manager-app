import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/user.dart';
import '../models/task.dart';

class FavoriteTasksScreen extends StatefulWidget {
  final User user;

  const FavoriteTasksScreen({super.key, required this.user});

  @override
  State<FavoriteTasksScreen> createState() =>
      _FavoriteTasksScreenState();
}

class _FavoriteTasksScreenState extends State<FavoriteTasksScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TaskProvider>(context, listen: false)
          .loadFavorites(widget.user.studentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final favorites = provider.favoriteTasks;

    return Scaffold(
      appBar: AppBar(title: const Text("Favorite Tasks")),
      body: favorites.isEmpty
          ? const Center(child: Text("No favorite tasks yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final task = favorites[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(
                      'Due: ${task.dueDate} | Priority: ${task.priority}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        Provider.of<TaskProvider>(context, listen: false)
                            .toggleFavorite(task, widget.user.studentId);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}