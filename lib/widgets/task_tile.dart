import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TaskTile({super.key, required this.task, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.96),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      child: ListTile(
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description != null ? Text(task.description!) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              task.isDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.deepPurple,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red[300]),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
