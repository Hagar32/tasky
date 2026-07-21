import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tasky/core/components/task_list_widget.dart';

import 'package:tasky/features/tasks/controllers/tasks_controller.dart';

class TodoTasksScreen extends StatelessWidget {
  const TodoTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
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
            child: controller.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      // backgroundColor: Colors.deepPurple,
                      strokeWidth: 5,
                    ),
                  )
                : Consumer<TasksController>(
                    builder: (BuildContext context, TasksController valueController, _) {
                      return TaskListWidget(
                        onEdit: () {
                          controller.init();
                        },
                        tasks: valueController.todoTasks,
                        onTap: (value, index) async {
                          controller.doneTask(value, valueController.todoTasks[index!].id);
                        },
                        emptyMessage: 'No Tasks Found',
                        onDelete: (int? id) {
                          controller.deleteTask(id);
                        },
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
