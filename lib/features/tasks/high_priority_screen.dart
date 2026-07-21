import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/components/task_list_widget.dart';
import 'controllers/tasks_controller.dart';

class HighPriorityScreen extends StatelessWidget {
  const HighPriorityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.read<TasksController>();
    return Scaffold(
      appBar: AppBar(title: Text("High Priority Tasks")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: controller.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 5,
                ),
              )
            : Consumer<TasksController>(
                builder: (BuildContext context, TasksController valueController, _) {
                  return TaskListWidget(
                    onEdit: () {
                      controller.init();
                    },
                    tasks: valueController.highPriorityTasks,
                    onTap: (value, index) async {
                      controller.doneTask(value, valueController.highPriorityTasks[index!].id);
                    },
                    emptyMessage: 'No Tasks Found',
                    onDelete: (int? id) {
                      controller.deleteTask(id);
                    },
                  );
                },
              ),
      ),
    );
  }
}
