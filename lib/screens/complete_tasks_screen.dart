import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/widgets/task_list_widget.dart';

import '../models/task_model.dart';

class CompleteTasksScreen extends StatefulWidget {
  const CompleteTasksScreen({super.key});

  @override
  State<CompleteTasksScreen> createState() => _CompleteTasksScreenState();
}

class _CompleteTasksScreenState extends State<CompleteTasksScreen> {
  List<TaskModel> completeTasks = [];
  bool isLoading = false;

  //
  @override
  void initState() {
    _loadTask();
    super.initState();
  }

  Future<void> _loadTask() async {
    setState(() {
      isLoading = true;
    });
    final finalTask = PreferencesManager().getString("tasks");
    // await Future.delayed(Duration(seconds: 1));

    if (finalTask != null) {
      final taskDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        completeTasks = taskDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isDone)
            .toList();
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _deleteTask(int? id) async {
    List<TaskModel> tasks = [];
    if (id == null) return;
    final finalTask = PreferencesManager().getString("tasks");

    if (finalTask != null) {
      final taskAfterDecode = jsonDecode(finalTask) as List<dynamic>;
      tasks = taskAfterDecode
          .map((element) => TaskModel.fromJson(element))
          .toList();
      tasks.removeWhere((task) => task.id == id);
    }
    setState(() {
      completeTasks.removeWhere((task) => task.id == id);
    });
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(18.0),
          child: Center(
            child: Text(
              "Completed Tasks",
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      // backgroundColor: Colors.deepPurple,
                      strokeWidth: 5,
                    ),
                  )
                : TaskListWidget(
                    onEdit: () {
                      _loadTask();
                    },
                    tasks: completeTasks,
                    onTap: (value, index) async {
                      setState(() {
                        completeTasks[index!].isDone = value ?? false;
                      });
                      final allData = PreferencesManager().getString("tasks");

                      if (allData != null) {
                        List<TaskModel> allDataList =
                            (jsonDecode(allData) as List)
                                .map((e) => TaskModel.fromJson(e))
                                .toList();
                        final newIndex = allDataList.indexWhere(
                          (e) => e.id == completeTasks[index!].id,
                        );
                        allDataList[newIndex] = completeTasks[index!];
                        await PreferencesManager().setString(
                          "tasks",
                          jsonEncode(allDataList),
                        );

                        _loadTask();
                      }
                    },
                    emptyMessage: 'No Tasks Found',
                    onDelete: (int? id) {
                      _deleteTask(id);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
