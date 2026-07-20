import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/features/home/home_controller.dart';

import 'package:tasky/features/tasks/high_priority_screen.dart';

import '../../../core/widgets/custom_check_box.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder:
          (BuildContext context, HomeController controller, Widget? child) {
            final listTasks = controller.tasks;
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "High Priority Tasks",
                            style: TextStyle(
                              color: Color(0xFF15B86C),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, int index) {
                            final task = listTasks.reversed
                                .where((e) => e.isHighPriority)
                                .toList()[index];
                            return Row(
                              children: [
                                CustomCheckBox(
                                  value: task.isDone,
                                  onChanged: (bool? value) {
                                    final index = listTasks.indexWhere(
                                      (e) => e.id == task.id,
                                    );
                                    controller.doneTask(value, index);
                                  },
                                ),

                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    task.taskName[0].toUpperCase() +
                                        task.taskName
                                            .substring(1)
                                            .toLowerCase(),
                                    style: task.isDone
                                        ? Theme.of(context).textTheme.titleLarge
                                        : Theme.of(
                                            context,
                                          ).textTheme.titleMedium,

                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            );
                          },
                          itemCount:
                              listTasks.reversed
                                      .where((e) => e.isHighPriority)
                                      .length >
                                  4
                              ? 4
                              : listTasks.reversed
                                    .where((e) => e.isHighPriority)
                                    .length,
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HighPriorityScreen(),
                        ),
                      );
                      controller.loadTask();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        padding: EdgeInsets.all(8),

                        height: 56,
                        width: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primaryContainer,

                          border: Border.all(
                            color: ThemeController.isDark()
                                ? Color(0xFF6E6E6E)
                                : Color(0xFFD1DAD6),
                          ),
                        ),
                        child: SvgPicture.asset(
                          "assets/images/arrow-up-right.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            ThemeController.isDark()
                                ? Color(0xFFC6C6C6)
                                : Color(0xFF3A4640),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}
