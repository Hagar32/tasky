import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tasky/core/widgets/custom_text_form_field.dart';
import 'package:tasky/features/add_task/add_task_controller.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddTaskController>(
      create: (_) => AddTaskController(),
      builder: (BuildContext context, _) {
        final controller = context.read<AddTaskController>();
        return Scaffold(
          appBar: AppBar(title: Text("New Task")),
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: controller.taskKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      title: "Task Name",
                      controller: controller.taskNameController,
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
                      controller: controller.taskDescriptionController,
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
                        Consumer<AddTaskController>(
                          builder:
                              (
                                BuildContext context,
                                AddTaskController value,
                                _,
                              ) {
                                return Switch(
                                  value: value.isHighPriority,
                                  onChanged: (bool? value) {
                                    controller.toggle(value);
                                  },
                                );
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
                        context.read<AddTaskController>().addTask(context);
                      },
                      label: Text("Add Task"),
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
