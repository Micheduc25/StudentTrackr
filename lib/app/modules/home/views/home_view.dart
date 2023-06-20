import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/utils/config.dart';
import 'package:student_tracker/app/widgets/admin_side_navigation_bar.dart';
import 'package:student_tracker/app/widgets/side_navigation_bar.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Row(
      children: [
        Obx(() => AuthController.to.currentUser.value != null &&
                AuthController.to.currentUser.value!.role == Config.Parent
            ? AppNavigationRail(
                onItemSelected: (index, page) {
                  controller.selectPage(index);
                },
              )
            : const SizedBox.shrink()),
        Obx(() => AuthController.to.currentUser.value != null &&
                AuthController.to.currentUser.value!.role != Config.Parent
            ? AdminNavigationRail(
                onItemSelected: (index, page) {
                  controller.selectPage(index);
                },
              )
            : const SizedBox.shrink()),
        Expanded(
            child: Obx(() => controller.isLoading.value
                ? Center(
                    child:
                        SpinKitDualRing(color: Get.theme.colorScheme.primary))
                : controller.pages[controller.currentPageIndex.value]))
      ],
    )));
  }
}
