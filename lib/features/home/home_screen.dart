import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:tasky/features/home/home_controller.dart';

import 'package:tasky/features/add_task/add_task_screen.dart';

import 'package:tasky/features/home/components/sliver_task_list_widget.dart';

import 'components/achieved_tasks_widget.dart';
import 'components/high_priority_tasks_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (BuildContext context) => HomeController()..init(),
      child: Consumer<HomeController>(
        builder: (BuildContext context, HomeController value, Widget? child) {
          final HomeController controller = context.read<HomeController>();
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
                              backgroundImage: value.userImagePath == null
                                  ? AssetImage("assets/images/logo.png")
                                  : FileImage(File(value.userImagePath!)),
                            ),
                            SizedBox(width: 8),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Good Evening ,${value.username}",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  value.motivationQuote ??
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
                          totalTask: value.totalTask,
                          totalDoneTasks: value.totalDoneTasks,
                          percent: value.percent,
                        ),
                        SizedBox(height: 8),
                        HighPriorityTasksWidget(
                          refresh: () => controller.loadTask(),

                          onTap: (bool? value, int? index) {
                            controller.doneTask(value, index);
                          },
                          tasks: value.tasks,
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
                  controller.isLoading
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
                            controller.loadTask();
                          },
                          tasks: value.tasks,
                          onTap: (bool? value, int? index) {
                            controller.doneTask(value, index);
                          },
                          onDelete: (int? id) {
                            controller.deleteTask(id);
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
                    controller.loadTask();
                  }
                },

                icon: Icon(Icons.add),
                label: Text("Add New Task"),
              ),
            ),
          );
        },
      ),
    );
  }
}
