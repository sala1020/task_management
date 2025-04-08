import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/data/controller/bottom_nav_provider.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<BottomNavProvider>(context);

    return BottomNavigationBar(
      currentIndex: navProvider.currentIndex,
      onTap: (index) => navProvider.changeIndex(index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'All'),
        BottomNavigationBarItem(icon: Icon(Icons.warning), label: 'Overdue'),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle),
          label: 'Completed',
        ),
        // BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      enableFeedback: true,
      unselectedItemColor: Colors.blueGrey,
      selectedItemColor: Colors.black,
    );
  }
}
