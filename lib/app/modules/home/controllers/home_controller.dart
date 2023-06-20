import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/children_marks_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/children_profile_controller.dart';
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

class HomeController extends GetxController {
  RxInt currentPageIndex = 0.obs;
  final authController = AuthController.to;

  RxBool isLoading = true.obs;

  List<Widget> pages = [
    DashboardPage(),
    ChildrenPage(),
    DashboardPage(),
    DashboardPage(),
    DashboardPage(),
  ];

  @override
  void onInit() async {
    super.onInit();

    if (!AuthController.to.isAppStartRootineDone) {
      await authController.appStartRoutine();

      isLoading.value = false;
    }

    //initialize profile controller
    Get.put(ProfileController());

    if (authController.currentUser.value!.role == Config.Parent) {
      //initialize chidren profile controller

      Get.put(ChildrenProfileController());
      Get.put(ChildrenMarksController());

      pages = [
        DashboardPage(),
        ChildrenPage(),
        const ChildrenMarksPage(),
        // DashboardPage(),
        const ProfileView(),
      ];
    } else {
      // initialize marks controller
      Get.put(MarksController());

      pages = [
        const AdminDashboard(),
        StudentsPage(),
        const SubjectsPage(),
        const ClassesPage(),
        const MarksView(),
        const ProfileView()
      ];
    }
  }

  void selectPage(int index) {
    currentPageIndex.value = index;
  }
}
