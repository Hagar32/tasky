import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tasky/core/theme/theme_controller.dart';

import '../enums/task_item_actions_enum.dart';
import '../services/preferences_manager.dart';
import '../widgets/custom_check_box.dart';
import '../widgets/custom_text_form_field.dart';
import '../../models/task_model.dart';

class TaskItemWidget extends StatelessWidget {
  const TaskItemWidget({
    super.key,
    required this.model,
    required this.onChanged,
    required this.index,
    required this.onDelete,
    required this.onEdit,
  });

  final TaskModel model;
  final Function(bool?) onChanged;
  final int index;
  final Function(int) onDelete;
  final Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,

      height: 56,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        // border: BoxBorder.all(color: ThemeController.isDarkTheme(), width: 1),
        border: BoxBorder.all(
          color: ThemeController.isDark()
              ? Colors.transparent
              : Color(0xFFD1DAD6),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(width: 8),
          CustomCheckBox(
            value: model.isDone,
            onChanged: (bool? value) => onChanged(value),
          ),

          SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.taskName[0].toUpperCase() +
                      model.taskName.substring(1).toLowerCase(),
                  style: model.isDone
                      ? Theme.of(context).textTheme.titleLarge
                      : Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                ),
                if (model.taskDescription.isNotEmpty)
                  Text(
                    model.taskDescription[0].toUpperCase() +
                        model.taskDescription.substring(1).toLowerCase(),
                    style: model.isDone
                        ? Theme.of(context).textTheme.titleLarge
                        : Theme.of(context).textTheme.titleSmall,
                    maxLines: 1,
                  ),
              ],
            ),
          ),
          PopupMenuButton<TaskItemActionsEnum>(
            icon: Icon(
              Icons.more_vert,

              color: ThemeController.isDark()
                  ? (model.isDone ? Color(0xFFA0A0A0) : Color(0xFFC6C6C6))
                  : (model.isDone ? Color(0xFF6A6A6A) : Color(0xFF3A4640)),
            ),
            onSelected: (value) async {
              switch (value) {
                case TaskItemActionsEnum.markAsDone:
                  onChanged(!model.isDone);
                case TaskItemActionsEnum.delete:
                  _showAlertDialog(context);
                case TaskItemActionsEnum.edit:
                  final result = await _showBottomSheet(context, model);
                  if (result == true) {
                    onEdit();
                  }
              }
            },
            itemBuilder: (context) => TaskItemActionsEnum.values.map((e) {
              return PopupMenuItem<TaskItemActionsEnum>(
                value: e,
                child: Text(
                  // e.name[0].toUpperCase() + e.name.substring(1).toLowerCase(),
                  e.name,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  _showAlertDialog(context) {
    showDialog(
      // barrierDismissible: true,
      // barrierColor: Colors.black.withValues(alpha: 0.5),
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Task"),
          content: Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                onDelete(model.id);
                Navigator.of(context).pop();
              },

              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showBottomSheet(BuildContext context, TaskModel model) async {
    GlobalKey<FormState> key = GlobalKey<FormState>();
    TextEditingController taskNameController = TextEditingController(
      text: model.taskName,
    );
    TextEditingController taskDescriptionController = TextEditingController(
      text: model.taskDescription,
    );
    bool isHighPriority = model.isHighPriority;
    return showModalBottomSheet<bool>(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    CustomTextFormField(
                      title: "Task Name",
                      controller: taskNameController,
                      hintText: "Finish UI design for login screen",
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter a Task Name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),

                    CustomTextFormField(
                      title: "Task Description",
                      controller: taskDescriptionController,
                      hintText:
                          "Finish onboarding UI and hand off to \ndevs by Thursday.",
                      maxLines: 5,
                    ),

                    SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "High Priority",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Switch(
                          value: isHighPriority,
                          onChanged: (bool? value) {
                            if (value != null) {
                              setState(() {
                                isHighPriority = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(MediaQuery.of(context).size.width, 40),
                      ),
                      onPressed: () async {
                        if (key.currentState?.validate() ?? false) {
                          final taskJson = PreferencesManager().getString(
                            "tasks",
                          );
                          List<dynamic> listTasks = [];
                          if (taskJson != null) {
                            listTasks = jsonDecode(taskJson);
                          }
                          TaskModel newModel = TaskModel(
                            id: model.id,

                            taskName: taskNameController.text,
                            taskDescription: taskDescriptionController.text,
                            isHighPriority: isHighPriority,
                            isDone: model.isDone,
                          );
                          final item = listTasks.firstWhere(
                            (e) => e['id'] == model.id,
                          );

                          final int index = listTasks.indexOf(item);
                          listTasks[index] = newModel;

                          final taskEncode = jsonEncode(listTasks);
                          await PreferencesManager().setString(
                            "tasks",
                            taskEncode,
                          );
                          Navigator.of(context).pop(true);
                        }
                      },
                      label: Text("Edit Task"),
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
