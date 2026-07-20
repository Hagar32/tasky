import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/models/task_model.dart';

import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';

class HomeController with ChangeNotifier {
  List<TaskModel> tasksList = [];
  String? username;
  String? motivationQuote;
  List<TaskModel> tasks = [];

  bool isLoading = false;
  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;
  String? userImagePath;

  init (){
  loadUserData();
  loadTask();

}
  Future<void> loadTask() async {
    isLoading = true;


    final finalTask = PreferencesManager().getString(StorageKey.tasks);

    if (finalTask != null) {
      final taskDecode = jsonDecode(finalTask) as List<dynamic>;


      tasks = taskDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();

       calculatePercent();
    }

    isLoading = false;
    notifyListeners();
  }

  void loadUserData() {
    username = PreferencesManager().getString(StorageKey.username);

    motivationQuote =
        PreferencesManager().getString(StorageKey.motivationQuote);
    userImagePath = PreferencesManager().getString(StorageKey.userImage);
    notifyListeners();
  }

  void calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
    notifyListeners();
  }

  Future<void> deleteTask(int? id) async {
    if (id == null) return;

      tasks.removeWhere((task) => task.id == id);
      calculatePercent();

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
    notifyListeners();
  }

  Future<void> doneTask(bool? value, int? index) async {

      tasks[index!].isDone = value ?? false;
      calculatePercent();


    final updatedTask = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString(StorageKey.tasks, jsonEncode(updatedTask));
      notifyListeners();
  }


}
