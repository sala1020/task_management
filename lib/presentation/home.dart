import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/data/controller/bottom_nav_provider.dart';
import 'package:task_management/data/controller/home_controller.dart';
import 'package:task_management/core/bottom_navbar.dart';
import 'package:task_management/presentation/screens/all_task_screen.dart';
import 'package:task_management/presentation/screens/completed_task_screen.dart';
import 'package:task_management/presentation/screens/overdue_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<BottomNavProvider>(context);
    final homeController = Provider.of<HomeController>(context);
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    final List<Widget> screens = [
      const AllTaskScreen(),
      const OverdueScreen(),
      const CompletedTaskScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: isLargeScreen ? 32 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                homeController.greeting,
                style: TextStyle(
                  fontSize: isLargeScreen ? 28 : 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: [
                  Icon(
                    homeController.isConnected ? Icons.wifi : Icons.wifi_off,
                    size: isLargeScreen ? 22 : 18,
                    color: homeController.isConnected ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    homeController.isConnected ? "Online" : "Offline",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isLargeScreen ? 16 : 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blueGrey),
              child: Text(
                'TaskFlow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isLargeScreen ? 28 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.file_download),
              title: const Text('Export to Local'),
              onTap: () {
                Navigator.pop(context);
                homeController.exportToSQLite();
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_upload),
              title: const Text('Import from Local'),
              onTap: () {
                Navigator.pop(context);
                homeController.importFromSQLite();
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(isLargeScreen ? 32 : 8),
        child: screens[navProvider.currentIndex],
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
