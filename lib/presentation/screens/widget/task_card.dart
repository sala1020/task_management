
import 'package:flutter/material.dart';
import 'package:task_management/data/task_model/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final double titleFontSize;
  final double descFontSize;
  final double labelFontSize;
  final bool isLarge;
  final bool isApproaching;
  final bool isOverdue;
  final String dateFormatted;
  final String daysText;
  final Color Function(String) getWaveColor;

  const TaskCard({
    Key? key,
    required this.task,
    required this.titleFontSize,
    required this.descFontSize,
    required this.labelFontSize,
    required this.isLarge,
    required this.isApproaching,
    required this.isOverdue,
    required this.dateFormatted,
    required this.daysText,
    required this.getWaveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
              Icon(Icons.error, color: Colors.red, size: isLarge ? 18 : 14),
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
              backgroundColor: getWaveColor(task.priority).withOpacity(0.5),
            ),
          ],
        ),
      ],
    );
  }
}