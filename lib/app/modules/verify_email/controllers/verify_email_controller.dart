import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/routes/app_pages.dart';

import '../../../controllers/school_controller.dart';
import '../../../models/school_model.dart';
import '../../../utils/config.dart';

class VerifyEmailController extends GetxController {
  final authController = AuthController.to;
  RxBool isLoading = false.obs;

  void verifyEmail() async {
    isLoading.value = true;

    try {
      await authController.getCurrentFirebaseUser!.reload();

      if (authController.getCurrentFirebaseUser!.emailVerified) {
        await AuthController.to.appStartRoutine();

        isLoading.value = false;
      } else {
        isLoading.value = false;
        Fluttertoast.showToast(msg: "Please verify your email and try again");
      }
    } on Exception catch (e) {
      isLoading.value = false;
      Fluttertoast.showToast(msg: "An unexpected error occurred");
    }
  }

  void resendEmailVerification() async {
    await authController.getCurrentFirebaseUser!.sendEmailVerification();
    Fluttertoast.showToast(msg: "Email verification sent");
  }
}
