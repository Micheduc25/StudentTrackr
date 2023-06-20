import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';

class AdminNavigationRail extends StatefulWidget {
  const AdminNavigationRail({super.key, this.onItemSelected});

  final void Function(int, String)? onItemSelected;

  @override
  State<AdminNavigationRail> createState() => _AdminNavigationRailState();
}

class _AdminNavigationRailState extends State<AdminNavigationRail> {
  List<String> navItems = [
    "Home",
    "Students",
    "Subjects",
    "Classes",
    "Marks",
    "Profile"
  ];
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (widget.onItemSelected != null) {
      widget.onItemSelected!(index, navItems[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onItemTapped,
      labelType: NavigationRailLabelType.all,
      leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Image.asset("assets/images/logo.png", width: 50),
              const SizedBox(width: 10),
              Text(
                "StudentTrackr",
                style: Get.textTheme.titleSmall,
              )
            ],
          )),
      trailing: Padding(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: Get.height * 0.3, bottom: 15),
        child: InkWell(
          onTap: () {
            AuthController.to.signOut();
          },
          child: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(children: [
              Icon(Icons.logout),
              SizedBox(width: 15),
              Text("Logout")
            ]),
          ),
        ),
      ),
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.school),
          label: Text('Students'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.book),
          label: Text('Subjects'),
        ),
        NavigationRailDestination(
          icon: Icon(FontAwesomeIcons.school),
          label: Text('Classes'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.assignment),
          label: Text('Marks'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person),
          label: Text('Profile'),
        ),
      ],
    );
  }
}
