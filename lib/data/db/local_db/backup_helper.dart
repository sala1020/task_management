import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';

class DatabaseBackupHelper {
  static const String dbName = 'tasks.db';

  static Future<void> exportDatabase() async {
    final storageStatus = await Permission.manageExternalStorage.request();
    if (!storageStatus.isGranted) {
      throw Exception("Storage permission denied");
    }

    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(appDir.path, dbName);

    final downloadsDir = Directory('/storage/emulated/0/Download');
    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }

    final backupPath = p.join(downloadsDir.path, 'task_backup_$dbName');

    final dbFile = File(dbPath);
    if (await dbFile.exists()) {
      await dbFile.copy(backupPath);
      print("✅ Exported to: $backupPath");
    } else {
      throw Exception("Database file not found at $dbPath");
    }
  }

  static Future<void> importDatabaseFromUserFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      final pickedFile = File(result.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();
      final targetPath = p.join(appDir.path, dbName);

      await pickedFile.copy(targetPath);
      print("✅ Imported DB from: ${pickedFile.path}");
    } else {
      throw Exception("No .db file selected");
    }
  }
}
