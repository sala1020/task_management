import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/data/controller/all_task_controller.dart';

class OverdueScreen extends StatelessWidget {
  const OverdueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allTasks = Provider.of<AllTaskController>(context).tasks;

    // Filter overdue tasks
    final overdueTasks =
        allTasks.where((task) {
          return DateTime.now().isAfter(task.endDate) &&
              task.status != "Completed";
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Overdue Tasks",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            overdueTasks.isEmpty
                ? const Center(child: Text("No overdue tasks 🎉"))
                : ListView.builder(
                  itemCount: overdueTasks.length,
                  itemBuilder: (context, index) {
                    final task = overdueTasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.red.shade100,
                      child: ListTile(
                        title: Text(
                          task.title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Description: ${task.description}"),
                            Text(
                              "Due: ${task.endDate.toString().split(' ')[0]}",
                            ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.warning_amber,
                          color: Colors.redAccent,
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
