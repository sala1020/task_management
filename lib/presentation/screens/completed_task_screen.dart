import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/data/controller/all_task_controller.dart';

class CompletedTaskScreen extends StatelessWidget {
  const CompletedTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AllTaskController>(context);

    // final allTasks = Provider.of<AllTaskController>(context).tasks;

    // Filter completed tasks
    final completedTasks =
        controller.tasks.where((task) => task.status == "Completed").toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Completed Tasks",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.syncFromCloud();
        },
        child: Icon(Icons.sync, color: Colors.white),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child:
            completedTasks.isEmpty
                ? const Center(child: Text("No completed tasks yet ✅"))
                : ListView.builder(
                  itemCount: completedTasks.length,
                  itemBuilder: (context, index) {
                    final task = completedTasks[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: Colors.green.shade100,
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
                              "Completed on: ${task.endDate.toString().split(' ')[0]}",
                            ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
