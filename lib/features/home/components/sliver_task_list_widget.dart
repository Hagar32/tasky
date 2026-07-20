import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tasky/core/components/task_item_widget.dart';
import 'package:tasky/features/home/home_controller.dart';

class SliverTaskListWidget extends StatelessWidget {
  const SliverTaskListWidget({super.key, this.emptyMessage});

  final String? emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder:
          (BuildContext context, HomeController controller, Widget? child) {
            final listTasks = controller.tasks;
            return controller.isLoading
                ? SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator(value: 20)),
                  )
                : listTasks.isEmpty
                ? SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'No Data',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.only(bottom: 50),
                    sliver: SliverList.separated(
                      itemCount: listTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskItemWidget(
                          onEdit: () => controller.loadTask(),
                          model: listTasks[index],
                          onChanged: (bool? value) {
                            controller.doneTask(value, index);
                          },
                          index: index,
                          onDelete: (int id) {
                            controller.deleteTask(id);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 8);
                      },
                    ),
                  );
          },
    );
  }
}
