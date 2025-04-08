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

    // Watch for changes in the local task box
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
    if (isOnline) {
      firestore.deleteTask(id);
    } else {
      debugPrint("Offline delete detected — skipping Firestore delete");
    }
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

  double getWaveHeight() {
    final tasks = taskBox.getAll();
    if (tasks.isEmpty) return 0.2;
    final completed = tasks.where((t) => t.status == "Completed").length;
    return (completed / tasks.length).clamp(0.2, 1.0);
  }

  /// Determines wave color based on most frequent priority
  Color getWaveColor() {
    final tasks = taskBox.getAll();
    if (tasks.isEmpty) return Colors.blue;

    final high = tasks.where((t) => t.priority == "High").length;
    final medium = tasks.where((t) => t.priority == "Medium").length;
    final low = tasks.where((t) => t.priority == "Low").length;

    if (high >= medium && high >= low) {
      return Colors.red;
    } else if (medium >= high && medium >= low) {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  Widget buildWaveWidget() {
    return SizedBox(
      height: 160,
      child: WaveWidget(
        config: CustomConfig(
          colors: [getWaveColor(), getWaveColor()],
          durations: [35000, 19440],
          heightPercentages: [getWaveHeight(), getWaveHeight() - 0.1],
        ),
        backgroundColor: Colors.white,
        size: const Size(double.infinity, double.infinity),
        waveAmplitude: 0,
      ),
    );
  }

  @override
  void dispose() {
    _taskStreamSub.cancel();
    super.dispose();
  }
}
