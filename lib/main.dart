import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/data/controller/all_task_controller.dart';
import 'package:task_management/data/controller/bottom_nav_provider.dart';
import 'package:task_management/data/controller/home_controller.dart';
import 'package:task_management/data/controller/operation_controller/create_task_controller.dart';
import 'package:task_management/data/controller/operation_controller/update_task_controller.dart';
import 'package:task_management/data/db/local_db/local_db_sqflite.dart';
import 'package:task_management/data/db/object_box/object_box.dart';
import 'package:task_management/firebase_options.dart';
import 'package:task_management/presentation/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalDBHelper.database;
  await initObjectBox();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => AllTaskController()),
        ChangeNotifierProvider(create: (_) => CreateTaskController()),
        ChangeNotifierProvider(create: (_) => UpdateTaskController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.white),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.blueGrey.shade100,
        ),
      ),

      home: SplashScreen(),
    );
  }
}
