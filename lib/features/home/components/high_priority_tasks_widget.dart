import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tasky/core/theme/theme_controller.dart';
import 'package:tasky/models/task_model.dart';
import 'package:tasky/features/tasks/high_priority_screen.dart';

import '../../../core/widgets/custom_check_box.dart';

class HighPriorityTasksWidget extends StatelessWidget {
  const HighPriorityTasksWidget({
    super.key,

    required this.onTap,
    required this.tasks,
    required this.refresh,

  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;


  final Function refresh;

  @override
  Widget build(BuildContext context) {
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
                    final task = tasks.reversed
                        .where((e) => e.isHighPriority)
                        .toList()[index];
                    return Row(
                      children: [
                        CustomCheckBox(
                          value: task.isDone,
                          onChanged: (bool? value) {
                            final index = tasks.indexWhere(
                              (e) => e.id == task.id,
                            );
                            onTap(value, index);
                          },
                        ),

                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            task.taskName[0].toUpperCase() +
                                task.taskName.substring(1).toLowerCase(),
                            style: task.isDone
                                ? Theme.of(context).textTheme.titleLarge
                                : Theme.of(context).textTheme.titleMedium,

                            maxLines: 1,
                          ),
                        ),
                      ],
                    );
                  },
                  itemCount:
                      tasks.reversed.where((e) => e.isHighPriority).length > 4
                      ? 4
                      : tasks.reversed.where((e) => e.isHighPriority).length,
                ),
                // ...tasks.reversed.where((e) => e.isHighPriority).take(4).map((
                //   element,
                // ) {
                //   return Row(
                //     children: [
                //       Checkbox(
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(4),
                //         ),
                //
                //         value: element.isDone,
                //         checkColor: Color(0xFFFFFCFC),
                //         activeColor: Color(0xFF15B86C),
                //
                //         onChanged: (bool? value) {
                //           final index = tasks.indexWhere(
                //             (e) => e.id == element.id,
                //           );
                //           onTap(value, index);
                //         },
                //       ),
                //       SizedBox(width: 4),
                //       Flexible(
                //         child: Text(
                //           element.taskName,
                //           style: TextStyle(
                //             color: element.isDone
                //                 ? Color(0xFFA0A0A0)
                //                 : Color(0xFFFFFCFC),
                //             fontSize: 14,
                //             fontWeight: FontWeight.w400,
                //             decoration: element.isDone
                //                 ? TextDecoration.lineThrough
                //                 : TextDecoration.none,
                //             decorationThickness: 3,
                //             decorationColor: Color(0xFFA0A0A0),
                //             overflow: TextOverflow.ellipsis,
                //           ),
                //           maxLines: 1,
                //         ),
                //       ),
                //     ],
                //   );
                // }),
              ],
            ),
          ),

          GestureDetector(
            onTap: () async {
              // onArrowTap();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HighPriorityScreen(),
                ),
              );
              refresh();
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
  }
}
