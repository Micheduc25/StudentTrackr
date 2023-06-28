import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar(
      {super.key,
      required this.currentIndex,
      required this.onItemSelected,
      this.items = const ["Home", "Students Profile", "Results", "Profile"]});

  final void Function(int, String) onItemSelected;
  final int currentIndex;

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => onItemSelected(index, items[index]),
        selectedItemColor: Get.theme.colorScheme.primary,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Students Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Results',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Profile',
          ),
        ]);
  }
}
