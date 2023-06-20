import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/routes/app_pages.dart';

class AuthGuard extends GetMiddleware {
  // Get the reference to your authentication service or controller
  final authController = Get.find<AuthController>();

  // Override the redirect method
  @override
  RouteSettings? redirect(String? route) {
    // Check if the user is logged in or not
    if (authController.getCurrentFirebaseUser == null) {
      // If not, redirect to the login page
      return const RouteSettings(name: Routes.LOGIN);
    } else {
      // If yes, continue to the requested route
      return null;
    }
  }
}
