import 'dart:convert';

import 'package:flutter/material.dart';

import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';
import '../../models/task_model.dart' show TaskModel;

class AddTaskController with ChangeNotifier {
  final GlobalKey<FormState> taskKey = GlobalKey<FormState>();
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescriptionController =
      TextEditingController();
  bool isHighPriority = true;

  Future<void> addTask(BuildContext context) async {
    if (taskKey.currentState?.validate() ?? false) {
      final taskJson = PreferencesManager().getString(StorageKey.tasks);

      List<dynamic> listTasks = [];
      if (taskJson != null) {
        listTasks = jsonDecode(taskJson);
      }
      TaskModel model = TaskModel(
        id: listTasks.length + 1,
        taskName: taskNameController.text,
        taskDescription: taskDescriptionController.text,
        isHighPriority: isHighPriority,
      );

      listTasks.add(model.toJson());

      final taskEncode = jsonEncode(listTasks);
      await PreferencesManager().setString(StorageKey.tasks, taskEncode);

      Navigator.of(context).pop(true);
      notifyListeners();
    }
  }

  toggle(bool? value) {
    if (value != null) {
      isHighPriority = value;
      notifyListeners();
    }
  }
}
