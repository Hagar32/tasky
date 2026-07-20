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
      child: Scaffold(
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
                        Selector<HomeController, String?>(
                          selector: (context, controller) =>
                              controller.userImagePath,
                          builder:
                              (
                                BuildContext context,
                                String? userImagePath,
                                Widget? child,
                              ) {
                                return CircleAvatar(
                                  backgroundColor: Color(0xFF282828),
                                  backgroundImage: userImagePath == null
                                      ? AssetImage("assets/images/logo.png")
                                      : FileImage(File(userImagePath)),
                                );
                              },
                        ),
                        SizedBox(width: 8),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Selector<HomeController, String?>(
                              selector: (context, controller) =>
                                  controller.username,
                              builder:
                                  (
                                    BuildContext context,
                                    String? username,
                                    Widget? child,
                                  ) {
                                    return Text(
                                      "Good Evening ,$username",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    );
                                  },
                            ),
                            Selector<HomeController, String?>(
                              selector: (context, controller) =>
                                  controller.motivationQuote,

                              builder:
                                  (
                                    BuildContext context,
                                    String? motivationQuote,
                                    Widget? child,
                                  ) {
                                    return Text(
                                      motivationQuote ??
                                          "One task at a time.One step closer.",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleSmall,
                                    );
                                  },
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
                    AchievedTasksWidget(),
                    SizedBox(height: 8),
                    HighPriorityTasksWidget(),

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
              SliverTaskListWidget(),
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
                context.read<HomeController>().loadTask();
              }
            },

            icon: Icon(Icons.add),
            label: Text("Add New Task"),
          ),
        ),
      ),
    );
  }
}
