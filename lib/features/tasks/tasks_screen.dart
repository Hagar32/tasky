import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/core/components/task_list_widget.dart';

import '../../models/task_model.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<TaskModel> todoTasks = [];
  bool isLoading = false;

  //
  @override
  void initState() {
    _loadTask();
    super.initState();
  }

  void _loadTask() {
    setState(() {
      isLoading = true;
    });
    final finalTask = PreferencesManager().getString("tasks");

    if (finalTask != null) {
      final taskDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        todoTasks = taskDecode
            .map((element) => TaskModel.fromJson(element))
            .where((element) => element.isDone == false)
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
      todoTasks.removeWhere((task) => task.id == id);
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
              "To Do Tasks",
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
                    tasks: todoTasks,
                    onTap: (value, index) async {
                      setState(() {
                        todoTasks[index!].isDone = value ?? false;
                      });
                      final allData = PreferencesManager().getString("tasks");

                      if (allData != null) {
                        List<TaskModel> allDataList =
                            (jsonDecode(allData) as List)
                                .map((e) => TaskModel.fromJson(e))
                                .toList();
                        final int newIndex = allDataList.indexWhere(
                          (e) => e.id == todoTasks[index!].id,
                        );
                        allDataList[newIndex] = todoTasks[index!];
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
