import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:tasky/core/services/preferences_manager.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/features/add_task/add_task_screen.dart';

import 'package:tasky/features/home/components/sliver_task_list_widget.dart';

import 'components/achieved_tasks_widget.dart';
import 'components/high_priority_tasks_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? username;
  String? motivationQuote;
  List<TaskModel> tasks = [];

  bool isLoading = false;
  int totalTask = 0;
  int totalDoneTasks = 0;
  double percent = 0;
  String? userImagePath;

  @override
  void initState() {
    _loadUserDetails();
    _loadTask();
    super.initState();
  }

  Future<void> _loadTask() async {
    setState(() {
      isLoading = true;
    });
    // await Future.delayed(Duration(seconds: 1));
    final finalTask = PreferencesManager().getString("tasks");

    if (finalTask != null) {
      final taskDecode = jsonDecode(finalTask) as List<dynamic>;

      setState(() {
        tasks = taskDecode
            .map((element) => TaskModel.fromJson(element))
            .toList();

        _calculatePercent();
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void _calculatePercent() {
    totalTask = tasks.length;
    totalDoneTasks = tasks.where((e) => e.isDone).length;
    percent = totalTask == 0 ? 0 : totalDoneTasks / totalTask;
  }

  void _loadUserDetails() {
    setState(() {
      username = PreferencesManager().getString("username");

      motivationQuote = PreferencesManager().getString("motivationQuote");
      userImagePath = PreferencesManager().getString("user_image");
    });
  }

  Future<void> _deleteTask(int? id) async {
    if (id == null) return;
    setState(() {
      tasks.removeWhere((task) => task.id == id);
      _calculatePercent();
    });
    //todo : make shared method
    final updatedTask = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  Future<void> _doneTask(bool? value, int? index) async {
    setState(() {
      tasks[index!].isDone = value ?? false;
      _calculatePercent();
    });

    final updatedTask = tasks.map((element) => element.toJson()).toList();
    await PreferencesManager().setString("tasks", jsonEncode(updatedTask));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Color(0xFF282828),
                        backgroundImage: userImagePath == null
                            ? AssetImage("assets/images/logo.png")
                            : FileImage(File(userImagePath!)),
                      ),
                      SizedBox(width: 8),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Evening ,$username",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            motivationQuote ??
                                "One task at a time.One step closer.",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Text(
                    "Yuhuu ,Your work Is ",
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        "almost done ! ",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(width: 8),
                      SvgPicture.asset(
                        "assets/images/waving_hand.svg",
                        width: 32,
                        height: 32,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  AchievedTasksWidget(
                    totalTask: totalTask,
                    totalDoneTasks: totalDoneTasks,
                    percent: percent,
                  ),
                  SizedBox(height: 8),
                  HighPriorityTasksWidget(
                    refresh: () => _loadTask(),

                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    tasks: tasks,
                  ),

                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 16),
                    child: Text(
                      "My Tasks",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,

                        strokeWidth: 5,
                      ),
                    ),
                  )
                : SliverTaskListWidget(
                    onEdit: () {
                      _loadTask();
                    },
                    tasks: tasks,
                    onTap: (bool? value, int? index) {
                      _doneTask(value, index);
                    },
                    onDelete: (int? id) {
                      _deleteTask(id);
                    },
                  ),
          ],
        ),
      ),

      floatingActionButton: SizedBox(
        height: 40,
        width: 168,
        child: FloatingActionButton.extended(
          onPressed: () async {
            final bool? result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTaskScreen()),
            );
            if (result != null && result == true) {
              _loadTask();
            }
          },

          icon: Icon(Icons.add),
          label: Text("Add New Task"),
        ),
      ),
    );
  }
}
