import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

class TaskStorage {
  TaskStorage._();

  static const String _tasksKey = 'tasks';

  static Future<List<TaskModel>> loadTasks() async {
    final preferences = await SharedPreferences.getInstance();

    final storedTasks = preferences.getStringList(_tasksKey);

    if (storedTasks == null || storedTasks.isEmpty) {
      return [];
    }

    final tasks = <TaskModel>[];

    for (final encodedTask in storedTasks) {
      try {
        final decoded = jsonDecode(encodedTask);

        if (decoded is Map<String, dynamic>) {
          tasks.add(TaskModel.fromJson(decoded));
        }
      } catch (_) {
        // Ignore an invalid stored task rather than
        // preventing the rest of the tasks from loading.
      }
    }

    return tasks;
  }

  static Future<void> saveTasks(List<TaskModel> tasks) async {
    final preferences = await SharedPreferences.getInstance();

    final encodedTasks = tasks
        .map((task) => jsonEncode(task.toJson()))
        .toList();

    await preferences.setStringList(_tasksKey, encodedTasks);
  }
}
