import 'package:flutter/material.dart';
import 'package:task_management/core/toast_widget.dart';
import 'package:task_management/data/db/firebase/firebase_functions.dart';
import 'package:task_management/data/db/object_box/object_box.dart';
import 'package:task_management/data/task_model/task_model.dart';

class CreateTaskController extends ChangeNotifier {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final firestore = FirestoreHelper();

  String _priority = 'Medium';
  String _status = 'Pending';
  DateTime? _startDate;
  DateTime? _endDate;

  String get priority => _priority;
  String get status => _status;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void setPriority(String value) {
    _priority = value;
    notifyListeners();
  }

  void setStatus(String value) {
    _status = value;
    notifyListeners();
  }

  void setStartDate(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  void setEndDate(DateTime date) {
    _endDate = date;
    notifyListeners();
  }

  bool validateForm() {
    return titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        _endDate != null;
  }

  void saveTask({bool isOnline = true}) async {
    if (!validateForm()) {
      ToastWidget.showToast("Please fill all fields");
      return;
    }

    final task = TaskModel(
      id: 0,
      title: titleController.text,
      description: descriptionController.text,
      priority: _priority,
      status: _status,
      endDate: _endDate!,
    );

    taskBox.put(task);

    if (_status == "Completed" && isOnline) {
      final alreadyExists = await firestore.checkIfTaskExists(task.id);
      if (!alreadyExists) {
        firestore.uploadTask(task);
      }
    }

    ToastWidget.showToast("Task saved successfully");
    clearForm();
    notifyListeners();
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    _priority = 'Medium';
    _status = 'Pending';
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}
