import 'dart:convert';

import 'package:projeto_flutter/Models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskRepository{
  TaskRepository()
  {
    SharedPreferences.getInstance().then((value) => sharedPreferences = value);
  }
  late SharedPreferences sharedPreferences;
  final String tasksKey = 'task_list';

  Future<List<Task>> getTaskList() async{
      sharedPreferences = await SharedPreferences.getInstance();
      final String jsonTasks = sharedPreferences.getString(tasksKey) ?? '[]';
      final List taskListDecoded = json.decode(jsonTasks) as List;
      return taskListDecoded.map((e) => Task.fromJson(e) ).toList();
  }

  void saveTaskList(List<Task> tasks){
    final String jsonTasks = json.encode(tasks);
    sharedPreferences.setString(tasksKey, jsonTasks);
  }
}