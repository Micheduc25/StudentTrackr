import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/admin_dashboard_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/children_marks_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/children_profile_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/dashboard_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/profile_controller.dart';
import 'package:student_tracker/app/modules/home/views/admins/admin_dashboard.dart';
import 'package:student_tracker/app/modules/home/views/admins/classes_view.dart';
import 'package:student_tracker/app/modules/home/views/admins/marks_view.dart';
import 'package:student_tracker/app/modules/home/views/admins/students_view.dart';
import 'package:student_tracker/app/modules/home/views/admins/subjects_view.dart';
import 'package:student_tracker/app/modules/home/views/parents/children_marks_view.dart';
import 'package:student_tracker/app/modules/home/views/parents/dashboard.dart';
import 'package:student_tracker/app/modules/home/views/parents/students_profile.dart';
import 'package:student_tracker/app/modules/home/views/profile_view.dart';

import '../../../utils/config.dart';
import 'marks_controller.dart';

class HomeController extends GetxService {
  RxInt currentPageIndex = 0.obs;
  final authController = AuthController.to;

  RxBool isLoading = true.obs;

  final adminPages = [
    "Home",
    "Students",
    "Subjects",
    "Classes",
    "Marks",
    "Profile"
  ];

  final parentPages = ["Home", "Students Profile", "Results", "Profile"];

  List<Widget> pages = [
    DashboardPage(),
    ChildrenPage(),
    DashboardPage(),
    DashboardPage(),
    DashboardPage(),
  ];

  static HomeController get to => Get.find();
  @override
  void onInit() async {
    super.onInit();

    if (!AuthController.to.isAppStartRootineDone) {
      await authController.appStartRoutine();
    }

    isLoading.value = false;

    //initialize profile controller
    Get.put(ProfileController());

    if (authController.currentUser.value!.role == Config.Parent) {
      //initialize chidren profile controller

      Get.put(ChildrenProfileController());
      Get.put(ChildrenMarksController());

      Get.put(DashboardController());

      pages = [
        const DashboardPage(),
        ChildrenPage(),
        const ChildrenMarksPage(),
        // DashboardPage(),
        const ProfileView(),
      ];

      setInitialPageIndex(parentPages);
    } else {
      // initialize marks controller
      Get.put(MarksController());
      Get.put(AdminDashboardController());

      pages = [
        const AdminDashboard(),
        StudentsPage(),
        const SubjectsPage(),
        const ClassesPage(),
        const MarksView(),
        const ProfileView()
      ];

      setInitialPageIndex(adminPages);
    }
  }

  void setInitialPageIndex(List<String> pagesList) {
    if (Get.parameters["location"] != null) {
      final pageIndex =
          pagesList.indexWhere((p) => p == Get.parameters["location"]);

      if (pageIndex > -1) currentPageIndex.value = pageIndex;
    }
  }

  void selectPage(int index, String page) {
    currentPageIndex.value = index;

    // Get.rootDelegate.offNamed(Routes.HOME, parameters: {"location": page});
  }
}
