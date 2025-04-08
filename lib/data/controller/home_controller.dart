import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:task_management/core/toast_widget.dart';
import 'package:task_management/data/db/local_db/backup_helper.dart';
import 'package:task_management/data/db/local_db/local_db_sqflite.dart';
import 'package:task_management/data/db/object_box/object_box.dart';
import 'package:task_management/data/db/firebase/firebase_functions.dart';

class HomeController extends ChangeNotifier {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final FirestoreHelper firestore = FirestoreHelper();

  String _greeting = '';
  bool _isConnected = true;

  String get greeting => _greeting;
  bool get isConnected => _isConnected;

  HomeController() {
    _setGreeting();
    _monitorConnectivity();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      _greeting = 'Good Morning ☀️';
    } else if (hour < 17) {
      _greeting = 'Good Afternoon 🌤️';
    } else {
      _greeting = 'Good Evening 🌙';
    }
    notifyListeners();
  }

  void _monitorConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      final currentlyConnected = results.any(
        (r) => r != ConnectivityResult.none,
      );

      if (_isConnected != currentlyConnected) {
        _isConnected = currentlyConnected;

        final String message =
            _isConnected ? "Back online ✅" : "You're offline ❌";
        ToastWidget.showToast(message);
        notifyListeners();

        if (currentlyConnected) {
          await _uploadOfflineCompletedTasks();
          ToastWidget.showToast("Synced completed tasks while coming online");
        }
      }
    });
  }

  Future<void> _uploadOfflineCompletedTasks() async {
    final tasks = taskBox.getAll();
    final completedTasks = tasks.where((task) => task.status == "Completed");

    for (final task in completedTasks) {
      final exists = await firestore.checkIfTaskExists(task.id);
      if (!exists) {
        await firestore.uploadTask(task);
      }
    }
  }

  Future<void> exportToSQLite() async {
    try {
      final tasks = taskBox.getAll();

      await LocalDBHelper.deleteAllTasks();
      for (final task in tasks) {
        await LocalDBHelper.insertTask(task);
      }

      await DatabaseBackupHelper.exportDatabase();

      ToastWidget.showToast("${tasks.length} task(s) exported to SQLite ✅");
    } catch (e) {
      ToastWidget.showToast("Export failed ❌: ${e.toString()}");
    }
  }

  Future<void> importFromSQLite() async {
    try {
      await DatabaseBackupHelper.importDatabaseFromUserFile();

      final importedTasks = await LocalDBHelper.getAllTasks();

      if (importedTasks.isEmpty) {
        ToastWidget.showToast("No tasks found in SQLite to import ❌");
        return;
      }

      await taskBox.removeAll();
      for (final task in importedTasks) {
        taskBox.put(task);
      }

      await _uploadOfflineCompletedTasks();

      ToastWidget.showToast(
        "${importedTasks.length} task(s) imported from SQLite ✅",
      );
      notifyListeners();
    } catch (e) {
      ToastWidget.showToast("Import failed ❌: Please choose .db file}");
      print(e.toString());
    }
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
