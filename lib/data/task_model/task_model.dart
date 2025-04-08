import 'package:objectbox/objectbox.dart';

@Entity()
class TaskModel {
  @Id()
  int id;

  final String title;
  final String description;
  final String priority;
  final String status;
  final DateTime endDate;

  TaskModel({
    this.id = 0,
    required this.title,
    required this.description,
    required this.priority,
    required this.status,
    required this.endDate,
  });

  // 🔁 Convert TaskModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'priority': priority,
      'status': status,
      'endDate': endDate.toIso8601String(),
    };
  }

  // 🔁 Create TaskModel from JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] ?? 0,
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      status: json['status'],
      endDate: DateTime.parse(json['endDate']),
    );
  }

  //for local db
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'endDate': endDate.toIso8601String(),
      'status': status,
      'priority': priority,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      endDate: DateTime.parse(map['endDate']),
      status: map['status'],
      priority: map['priority'],
    );
  }
}

List<TaskModel> sampleTasks = [
  TaskModel(
    id: 1,
    title: "Finish Assignment",
    description: "Complete the Flutter app assignment by tonight",
    priority: "High",
    status: "Pending", // Not completed
    endDate: DateTime.now().subtract(Duration(hours: 2)), // Past time = overdue
  ),
  TaskModel(
    id: 2,
    title: "Workout",
    description: "Evening workout session for 30 mins",
    priority: "Medium",
    status: "Completed",
    endDate: DateTime.now().subtract(Duration(days: 1)),
  ),
  TaskModel(
    id: 3,
    title: "Grocery Shopping",
    description: "Buy milk, bread, and eggs",
    priority: "Low",
    status: "Pending",
    endDate: DateTime.now().add(Duration(days: 1)),
  ),
  TaskModel(
    id: 4,
    title: "Read Book",
    description: "Read 20 pages of a self-help book",
    priority: "Low",
    status: "Pending",
    endDate: DateTime.now().add(Duration(days: 2)),
  ),
];
