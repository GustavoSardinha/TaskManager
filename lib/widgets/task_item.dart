import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../Models/task.dart';
class TaskItem extends StatelessWidget {
   const TaskItem ({super.key, required this.task, required this.onDelete});
  final Task task;
  final Function(Task) onDelete;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.25,
          children: [
            SlidableAction(
              label: 'Deletar',
              backgroundColor: Colors.red,
              icon: Icons.delete,
              onPressed: (context) {
                onDelete(task);
              },
            ),
          ],
        ),
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.grey[200],
        ),
        child: Column(

          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              DateFormat('dd/MM/yyyy -  hh:mm').format(task.date),
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              task.title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
