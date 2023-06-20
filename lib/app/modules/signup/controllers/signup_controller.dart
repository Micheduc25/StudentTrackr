import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/controllers/settings_controller.dart';
import 'package:student_tracker/app/models/school_model.dart';
import 'package:student_tracker/app/models/user_model.dart';
import 'package:student_tracker/app/routes/app_pages.dart';
import 'package:student_tracker/app/utils/config.dart';

class SignupController extends GetxController {
  final formKey = GlobalKey<FormState>();
  // final formKey = AppSettings.to.formKey;

  final _authController = AuthController.to;

  Rx<AutovalidateMode> validationMode = AutovalidateMode.disabled.obs;

  RxBool isLoading = false.obs;

  // Create variables for the dropdown form field
  RxString role = "Parent".obs;
  List<String> roles = ["Parent", "SchoolAdmin"];

  // Create text editing controllers for the text form fields
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController schooNameController = TextEditingController();
  TextEditingController schoolLocationController = TextEditingController();

  void signUp() async {
    try {
      if (formKey.currentState!.validate()) {
        isLoading.value = true;
        // If the validate method returns true, proceed with the registration

        //create user
        final cred = await _authController.registerWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        if (cred.user == null) {
          Fluttertoast.showToast(
              msg: "an error occurred while registering the user");
          return;
        }
        final firebaseUser = cred.user!;
        final now = DateTime.now();
        final newUser = UserModel(
            id: firebaseUser.uid,
            username: usernameController.text,
            fullname: fullnameController.text,
            phoneNumber: phoneNumberController.text,
            email: emailController.text,
            role: role.value,
            created: now,
            updated: now);

        await newUser.create();

        await firebaseUser.updateDisplayName(usernameController.text);

        await firebaseUser.sendEmailVerification();

        // if user is a school admin create school also
        if (role.value != Config.Parent) {
          final now = DateTime.now();
          final userSchool = SchoolModel(
              id: "",
              created: now,
              updated: now,
              createdBy: newUser,
              location: schoolLocationController.text,
              name: schooNameController.text,
              admins: [newUser]);

          await userSchool.create();
        }

        await AppSettings.to.saveSettings({Config.isNotFirstLogin: true});

        Get.snackbar("Success", "You have signed up successfully");
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
