import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_management/core/toast_widget.dart';
import 'package:task_management/data/db/firebase/firebase_functions.dart';
import 'package:task_management/data/db/object_box/object_box.dart';
import 'package:task_management/data/task_model/task_model.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class AllTaskController extends ChangeNotifier {
  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  final firestore = FirestoreHelper();
  late final StreamSubscription _taskStreamSub;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AllTaskController() {
    _loadInitialData();

    _taskStreamSub = taskBox.query().watch(triggerImmediately: true).listen((
      query,
    ) {
      _tasks = query.find();
      notifyListeners();
    });
  }

  Future<void> _loadInitialData() async {
    _setLoading(true);
    _tasks = taskBox.getAll();
    _setLoading(false);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> syncFromCloud() async {
    _setLoading(true);
    try {
      final cloudTasks = await firestore.fetchAllTasks();
      if (cloudTasks.isNotEmpty) {
        taskBox.removeAll();
        taskBox.putMany(cloudTasks);
        _tasks = taskBox.getAll();
        ToastWidget.showToast("Synced from cloud successfully");
      }
    } catch (e) {
      debugPrint("Cloud sync failed: $e");
      ToastWidget.showToast("Cloud sync failed");
    }
    _setLoading(false);
  }

  void addTask(TaskModel task, bool isOnline) async {
    taskBox.put(task);
    if (task.status == "Completed" && isOnline) {
      final alreadyExists = await firestore.checkIfTaskExists(task.id);
      if (!alreadyExists) {
        firestore.uploadTask(task);
      }
    }
    ToastWidget.showToast("Task added successfully");
  }

  void deleteTask(int id, bool isOnline) {
    taskBox.remove(id);
    firestore.deleteTask(id);

    ToastWidget.showToast("Task deleted successfully");
  }

  void uploadCompletedTasksIfNeeded(bool isOnline) async {
    if (!isOnline) return;
    final completedTasks = taskBox.getAll().where(
      (task) => task.status == "Completed",
    );
    for (final task in completedTasks) {
      final alreadyExists = await firestore.checkIfTaskExists(task.id);
      if (!alreadyExists) {
        firestore.uploadTask(task);
      }
    }
  }

  List<TaskModel> getOverdueTasks() {
    final now = DateTime.now();
    return _tasks.where((task) => now.isAfter(task.endDate)).toList();
  }

  List<TaskModel> getCompletedTasks() {
    return _tasks.where((task) => task.status == "Completed").toList();
  }

  List<TaskModel> getPendingTasks() {
    return _tasks.where((task) => task.status != "Completed").toList();
  }

  @override
  void dispose() {
    _taskStreamSub.cancel();
    super.dispose();
  }
}
