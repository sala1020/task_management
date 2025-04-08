import 'package:flutter/material.dart';
import 'package:task_management/core/toast_widget.dart';
import 'package:task_management/data/db/firebase/firebase_functions.dart';
import 'package:task_management/data/db/object_box/object_box.dart';
import 'package:task_management/data/task_model/task_model.dart';

class UpdateTaskController extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final firestore = FirestoreHelper();

  late String _priority;
  late String _status;
  late DateTime _endDate;
  late int _taskId;

  String get priority => _priority;
  String get status => _status;
  DateTime get endDate => _endDate;

  void initialize(TaskModel task) {
    _taskId = task.id;
    titleController.text = task.title;
    descriptionController.text = task.description;
    _priority = task.priority;
    _status = task.status;
    _endDate = task.endDate;
    notifyListeners();
  }

  void setPriority(String value) {
    _priority = value;
    notifyListeners();
  }

  void setStatus(String value) {
    _status = value;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  bool validateForm() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty;
  }

  Future<void> updateTaskInBox({bool isOnline = true}) async {
    if (!validateForm()) {
      ToastWidget.showToast("Please fill all fields");
      return;
    }

    final existingTask = taskBox.get(_taskId);
    final wasCompleted = existingTask?.status == "Completed";
    final isNowCompleted = _status == "Completed";

    final updated = TaskModel(
      id: _taskId,
      title: titleController.text,
      description: descriptionController.text,
      priority: _priority,
      status: _status,
      endDate: _endDate,
    );

    taskBox.put(updated);

    if (isNowCompleted && isOnline) {
      final alreadyExists = await firestore.checkIfTaskExists(updated.id);
      if (!alreadyExists) {
        firestore.uploadTask(updated);
      }
    } else if (wasCompleted && !isNowCompleted && isOnline) {
      firestore.deleteTask(updated.id);
    }

    ToastWidget.showToast("Task updated successfully");
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
