import 'package:flutter/material.dart';
import 'package:tasky/core/components/task_item_widget.dart';

import '../../models/task_model.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onTap,
    this.emptyMessage, required this.onDelete, required this.onEdit,
  });

  final List<TaskModel> tasks;
  final Function(bool?, int?) onTap;
  final String? emptyMessage;
  final Function(int?) onDelete;
  final Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              emptyMessage ?? "No Data ",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          )
        : ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(bottom: 50),
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return TaskItemWidget(
                onEdit: ()=> onEdit(),
                model: tasks[index],
                onChanged: (bool? value) {
                  onTap(value, index);
                },
                index: index, onDelete: (int id) {
                  onDelete(id);
              },
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 8);
            },
          );
  }
}
