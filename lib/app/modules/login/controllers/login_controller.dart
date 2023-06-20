import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/settings_controller.dart';
import 'package:student_tracker/app/utils/config.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // final formKey = AppSettings.to.formKey;

  final _authController = AuthController.to;

  Rx<AutovalidateMode> validationMode = AutovalidateMode.disabled.obs;

  RxBool isLoading = false.obs;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    try {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        // If the validate method returns true, proceed with the registration

        //login user

        await _authController.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        final appSettings = AppSettings.to;

        if (appSettings.isNotFirstLogin != true) {
          appSettings.saveSettings({Config.isNotFirstLogin: true});
        }
      } else {
        validationMode.value = AutovalidateMode.always;
        // If the validate method returns false, show an error message
        Get.snackbar("Error", "Please fill in all the fields correctly");
      }
    } catch (e) {
      // Show an error message using Get.snackbar or Get.dialog
      isLoading.value = false;
      Get.snackbar("Error", e.toString());
    }
  }
}
