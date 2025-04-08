import 'package:task_management/objectbox.g.dart';

import 'package:path_provider/path_provider.dart';
import 'package:task_management/data/task_model/task_model.dart';

late final Store store;
late final Box<TaskModel> taskBox;

Future<void> initObjectBox() async {
  final dir = await getApplicationDocumentsDirectory();
  store = await openStore(directory: '${dir.path}/objectbox');
  taskBox = store.box<TaskModel>();
}
