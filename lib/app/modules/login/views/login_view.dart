import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/custom_validators.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Get.width * 0.5,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Obx(() {
                return Form(
                  autovalidateMode: controller.validationMode.value,
                  key: controller.formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          width: 80,
                        ),
                        const SizedBox(height: 20),
                        Text("Sign In", style: Get.textTheme.titleLarge),
                        const SizedBox(height: 25),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: controller.emailController,
                          validator: CustomFormValidators.emailValidator,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: controller.passwordController,
                          validator: (value) =>
                              CustomFormValidators.passwordValidator(value),
                          style: const TextStyle(fontSize: 15),
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                        const SizedBox(height: 25),
                        Obx(() {
                          return ElevatedButton(
                            onPressed: () {
                              if (controller.isLoading.value) return;

                              controller.login();
                            },
                            child: !controller.isLoading.value
                                ? const Text('Sign in')
                                : SpinKitDualRing(
                                    color: Get.theme.colorScheme.onPrimary,
                                    size: 20,
                                    lineWidth: 4,
                                  ),
                          );
                        }),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account yet?",
                                style: Get.textTheme.bodyMedium),
                            TextButton(
                              child: Text('signup'.tr,
                                  style: Get.textTheme.bodyMedium!.copyWith(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.w700)),
                              onPressed: () {
                                Get.offNamed(Routes.SIGNUP);
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
