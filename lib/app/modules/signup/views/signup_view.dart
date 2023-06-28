import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/modules/signup/controllers/signup_controller.dart';
import 'package:student_tracker/app/routes/app_pages.dart';
import 'package:student_tracker/app/utils/config.dart';
import 'package:student_tracker/app/utils/custom_validators.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Get.width < 600 ? double.maxFinite : Get.width * 0.5,
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
                        Text("Create an Account",
                            style: Get.textTheme.titleLarge),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: controller.usernameController,
                          validator: CustomFormValidators.usernameValidator,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: controller.fullnameController,
                          validator: CustomFormValidators.nameValidator,
                          keyboardType: TextInputType.name,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: controller.emailController,
                          validator: CustomFormValidators.emailValidator,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontSize: 15),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: controller.phoneNumberController,
                          validator: CustomFormValidators.phoneNumberValidator,
                          style: const TextStyle(fontSize: 15),
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: controller.passwordController,
                          validator: (value) =>
                              CustomFormValidators.passwordValidator(value,
                                  controller.confirmPasswordController.text),
                          style: const TextStyle(fontSize: 15),
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextFormField(
                          controller: controller.confirmPasswordController,
                          validator: CustomFormValidators.passwordValidator,
                          style: const TextStyle(fontSize: 15),
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                          ),
                        ),
                        const SizedBox(height: 25),

                        //role selector
                        DropdownButtonFormField(
                          value: controller.role.value,
                          items: controller.roles
                              .map((role) => DropdownMenuItem(
                                    value: role,
                                    child: Text(role),
                                  ))
                              .toList(),
                          style: const TextStyle(fontSize: 15),
                          onChanged: (value) {
                            controller.role.value = value.toString();
                          },
                          decoration: const InputDecoration(
                            labelText: 'Role',
                          ),
                        ),

                        // School info
                        Obx(() {
                          return controller.role.value == Config.Parent
                              ? const SizedBox.shrink()
                              : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 25),
                                    TextFormField(
                                      controller:
                                          controller.schooNameController,
                                      validator: (value) {
                                        if (controller.role.value !=
                                            Config.Parent) {
                                          return CustomFormValidators
                                              .nameValidator(value);
                                        }

                                        return null;
                                      },
                                      style: const TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                        labelText: 'School Name',
                                      ),
                                    ),
                                    const SizedBox(height: 25),
                                    TextFormField(
                                      controller:
                                          controller.schoolLocationController,
                                      validator: (value) {
                                        if (controller.role.value !=
                                            Config.Parent) {
                                          return CustomFormValidators
                                              .nameValidator(value);
                                        }

                                        return null;
                                      },
                                      style: const TextStyle(fontSize: 15),
                                      keyboardType: TextInputType.streetAddress,
                                      decoration: const InputDecoration(
                                        labelText: 'School Location',
                                      ),
                                    ),
                                  ],
                                );
                        }),
                        const SizedBox(height: 25),
                        Obx(() {
                          return ElevatedButton(
                            onPressed: () {
                              if (controller.isLoading.value) return;

                              controller.signUp();
                            },
                            child: !controller.isLoading.value
                                ? const Text('Sign up')
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
                            Text("Already have an account?",
                                style: Get.textTheme.bodyMedium),
                            TextButton(
                              child: Text('login'.tr,
                                  style: Get.textTheme.bodyMedium!.copyWith(
                                      color: Get.theme.primaryColor,
                                      fontWeight: FontWeight.w700)),
                              onPressed: () {
                                Get.rootDelegate.offNamed(Routes.LOGIN);
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
