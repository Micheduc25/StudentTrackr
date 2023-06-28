import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class AdminBottomNavBar extends StatelessWidget {
  const AdminBottomNavBar(
      {super.key,
      required this.currentIndex,
      required this.onItemSelected,
      this.items = const [
        "Home",
        "Students",
        "Subjects",
        "Classes",
        "Marks",
        "Profile"
      ]});

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
            icon: Icon(Icons.school),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Subjects',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.school),
            label: 'Classes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Marks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_sharp),
            label: 'Profile',
          ),
        ]);
  }
}
