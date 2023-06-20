import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/routes/app_pages.dart';

import '../controllers/verify_email_controller.dart';

class VerifyEmailView extends GetView<VerifyEmailController> {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(child: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: Get.width * 0.6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    // borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Get.offNamed(Routes.LOGIN);
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        FontAwesomeIcons.chevronLeft,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("Email Verification".tr,
                      style: Get.textTheme.titleLarge,
                      textAlign: TextAlign.center),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "A verification email has been sent to ${AuthController.to.getCurrentFirebaseUser!.email}. Please check your spam emails if you don't see the email in your main inbox",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (controller.isLoading.value) return;

                        controller.verifyEmail();
                      },
                      child: !controller.isLoading.value
                          ? Text("I have verified my E-mail".tr)
                          : SpinKitDualRing(
                              color: Get.theme.colorScheme.onPrimary,
                              size: 20,
                              lineWidth: 4)),
                  const SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () async {
                        if (controller.isLoading.value) return;

                        controller.resendEmailVerification();
                      },
                      child: Text("Resend Email Verification".tr))
                ],
              ),
            ),
          );
        })),
      ),
    );
  }
}
