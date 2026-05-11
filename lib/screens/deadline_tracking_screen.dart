import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';

class DeadlineTrackingScreen extends StatefulWidget {
  const DeadlineTrackingScreen({super.key});

  @override
  State<DeadlineTrackingScreen> createState() => _DeadlineTrackingScreenState();
}

class _DeadlineTrackingScreenState extends State<DeadlineTrackingScreen> {
  Task? selectedTask;

  String _formatDate(DateTime date) {
    const monthNames = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${date.day} ${monthNames[date.month]}';
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deadline Tracking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<Task>(
              decoration: const InputDecoration(
                labelText: 'Select a Task',
                border: OutlineInputBorder(),
              ),
              value: selectedTask,
              items: tasks.map((Task task) {
                return DropdownMenuItem<Task>(
                  value: task,
                  child: Text(task.title),
                );
              }).toList(),
              onChanged: (Task? newValue) {
                setState(() {
                  selectedTask = newValue;
                });
              },
            ),
            const SizedBox(height: 32),
            if (selectedTask != null) ...[
              _buildDeadlineInfo(selectedTask!),
            ] else ...[
              const Center(
                child: Text(
                  'Please select a task to view the deadline.',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildDeadlineInfo(Task task) {
    try {
      DateTime dueDate = DateTime.parse(task.dueDate);
      DateTime now = DateTime.now();
      
      // Set the deadline to the end of the due date (23:59:59)
      DateTime deadline = DateTime(dueDate.year, dueDate.month, dueDate.day, 23, 59, 59);
      Duration difference = deadline.difference(now);
      
      String timeRemaining;
      bool isOverdue = false;

      if (difference.isNegative) {
        timeRemaining = 'Overdue';
        isOverdue = true;
      } else {
        int days = difference.inDays;
        int hours = difference.inHours % 24;
        
        if (days > 0) {
          timeRemaining = '$days ${days == 1 ? 'day' : 'days'}, $hours ${hours == 1 ? 'hour' : 'hours'}';
        } else if (hours > 0) {
          timeRemaining = '$hours ${hours == 1 ? 'hour' : 'hours'} (Due Today)';
        } else {
          timeRemaining = 'Less than an hour (Due Today)';
        }
      }

      String formattedDueDate = _formatDate(dueDate);
      String formattedToday = _formatDate(now);

      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Deadline: $formattedDueDate',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Today: $formattedToday',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Remaining: $timeRemaining',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: isOverdue ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      return const Text('Invalid date format for the selected task.');
    }
  }
}
