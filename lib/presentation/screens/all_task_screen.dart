import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_management/data/controller/all_task_controller.dart';
import 'package:task_management/data/controller/operation_controller/create_task_controller.dart';
import 'package:task_management/data/controller/operation_controller/update_task_controller.dart';
import 'package:task_management/data/task_model/task_model.dart';
import 'package:task_management/presentation/operation_screens/create_task.dart';
import 'package:task_management/presentation/operation_screens/edit_task.dart';
import 'package:task_management/presentation/screens/widget/task_summary_carrd.dart';
import 'package:wave/wave.dart';
import 'package:wave/config.dart';

class AllTaskScreen extends StatelessWidget {
  const AllTaskScreen({super.key});

  void _showTaskOptions(BuildContext context, TaskModel task) {
    final controller = Provider.of<AllTaskController>(context, listen: false);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: Colors.blueGrey),
              title: const Text("Edit Task"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeNotifierProvider(
                      create: (_) => UpdateTaskController()..initialize(task),
                      child: UpdateTaskScreen(task: task),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: const Text("Delete Task"),
              onTap: () {
                controller.deleteTask(task.id, true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getWaveColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.blue;
      default:
        return Colors.green;
    }
  }

  double _getWaveHeight(String priority) {
    switch (priority) {
      case "High":
        return 0.9;
      case "Medium":
        return 0.6;
      default:
        return 0.3;
    }
  }

  Widget _buildTaskWave(String priority) {
    final color = _getWaveColor(priority);
    final height = _getWaveHeight(priority);

    return WaveWidget(
      config: CustomConfig(
        colors: [color, color],
        durations: [30000, 18000],
        heightPercentages: [height, height - 0.1],
      ),
      backgroundColor: Colors.transparent,
      size: const Size(double.infinity, double.infinity),
      waveAmplitude: 0,
    );
  }

  bool _isApproachingDeadline(DateTime endDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    final diff = end.difference(today);
    return diff.inDays == 1;
  }

  bool _isOverdue(DateTime endDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    return today.isAfter(end);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AllTaskController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "All Tasks",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final isLarge = width > 800;
          final crossAxisCount = isLarge ? 4 : width > 600 ? 3 : 2;
          final padding = isLarge ? 24.0 : 12.0;
          final cardPadding = isLarge ? 20.0 : 12.0;
          final titleFontSize = isLarge ? 18.0 : 16.0;
          final descFontSize = isLarge ? 14.0 : 13.0;
          final labelFontSize = isLarge ? 13.0 : 12.0;

          final totalTasks = controller.tasks.length;
          final completedTasks =
              controller.tasks.where((t) => t.status == "Completed").length;
          final pendingTasks =
              controller.tasks.where((t) => t.status == "Pending").length;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
            child: controller.tasks.isEmpty
                ? const Center(child: Text("No tasks available"))
                : Column(
                    children: [
                      TaskSummaryCard(
                        totalTasks: totalTasks,
                        completedTasks: completedTasks,
                        pendingTasks: pendingTasks,
                      ),
                      SizedBox(height: padding),
                      Expanded(
                        child: GridView.builder(
                          itemCount: controller.tasks.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: padding,
                            mainAxisSpacing: padding,
                            childAspectRatio: isLarge ? 1.2 : 0.95,
                          ),
                          itemBuilder: (context, index) {
                            final task = controller.tasks[index];
                            final now = DateTime.now();
                            final today = DateTime(now.year, now.month, now.day);
                            final taskEnd = DateTime(task.endDate.year, task.endDate.month, task.endDate.day);
                            final daysLeft = taskEnd.difference(today).inDays;
                            final dateFormatted = DateFormat('dd/MM/yyyy').format(task.endDate);
                            final isOverdue = _isOverdue(task.endDate);
                            final isApproaching = _isApproachingDeadline(task.endDate);

                            final daysText = daysLeft > 0
                                ? "$daysLeft day${daysLeft == 1 ? '' : 's'} left"
                                : daysLeft == 0
                                    ? "Due today ⚠️"
                                    : "${-daysLeft} day${daysLeft == -1 ? '' : 's'} overdue";

                            return GestureDetector(
                              onTap: () => _showTaskOptions(context, task),
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: isOverdue ? Colors.red.withOpacity(0.2) : Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 4,
                                          offset: Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: _buildTaskWave(task.priority),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(cardPadding),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white.withOpacity(0.85),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              task.status == "Completed" ? Icons.check_circle : Icons.pending,
                                              color: task.status == "Completed" ? Colors.green : Colors.orange,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                task.title,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: titleFontSize,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: isLarge ? 10 : 8),
                                        if (isApproaching && !isOverdue)
                                          const Row(
                                            children: [
                                              Icon(Icons.warning, color: Colors.orange, size: 18),
                                              SizedBox(width: 4),
                                              Text(
                                                "Due soon",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.orange,
                                                ),
                                              ),
                                            ],
                                          ),
                                        SizedBox(height: isLarge ? 10 : 8),
                                        Text(
                                          task.description,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(fontSize: descFontSize),
                                        ),
                                        SizedBox(height: isLarge ? 10 : 8),
                                        Text(
                                          "Due: $dateFormatted\n($daysText)",
                                          style: TextStyle(
                                            fontSize: labelFontSize,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        if (isOverdue && task.status != "Completed")
                                           Row(
                                            children: [
                                              Icon(Icons.error, color: Colors.red, size: isLarge?18:14),
                                              SizedBox(width: 4),
                                              Text(
                                                "OVERDUE",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        const Spacer(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Chip(
                                              label: Text(
                                                task.priority.toUpperCase(),
                                                style: TextStyle(fontSize: labelFontSize),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: isLarge ? 6 : 4,
                                              ),
                                              backgroundColor: _getWaveColor(task.priority).withOpacity(0.5),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
      floatingActionButton: LayoutBuilder(
        builder: (context, constraints) {
          final isLarge = constraints.maxWidth > 800;
          return isLarge
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: "sync_btn",
                      onPressed: () {
                        controller.syncFromCloud();
                      },
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(Icons.sync, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    FloatingActionButton(
                      heroTag: "add_btn",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => CreateTaskController(),
                              child: const CreateTaskScreen(),
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      heroTag: "sync_btn",
                      onPressed: () {
                        controller.syncFromCloud();
                      },
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(Icons.sync, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    FloatingActionButton(
                      heroTag: "add_btn",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeNotifierProvider(
                              create: (_) => CreateTaskController(),
                              child: const CreateTaskScreen(),
                            ),
                          ),
                        );
                      },
                      backgroundColor: Colors.blueGrey,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
