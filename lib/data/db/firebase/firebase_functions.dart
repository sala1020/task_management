import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management/data/task_model/task_model.dart';

class FirestoreHelper {
  final _firestore = FirebaseFirestore.instance;
  final _collection = 'Completed tasks';

  Future<void> uploadTask(TaskModel task) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(task.id.toString())
          .set(task.toJson());
      print("done");
    } catch (e) {
      print("Failed to upload task: $e");
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _firestore.collection(_collection).doc(id.toString()).delete();
    } catch (e) {
      print("Failed to delete task: $e");
    }
  }

  Future<List<TaskModel>> fetchAllTasks() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print("Failed to fetch tasks: $e");
      return [];
    }
  }

  Future<bool> checkIfTaskExists(int taskId) async {
    try {
      final doc =
          await _firestore.collection(_collection).doc(taskId.toString()).get();
      return doc.exists;
    } catch (e) {
      print("Error checking if task exists: $e");
      return false;
    }
  }
}
