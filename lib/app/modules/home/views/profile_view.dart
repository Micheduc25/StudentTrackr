import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';

import '../../../utils/config.dart';
import '../../../utils/custom_validators.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = AuthController.to;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: SizedBox(
          width: Get.width > 600 ? Get.width * 0.45 : double.maxFinite,
          child: SingleChildScrollView(
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: Get.width < 600
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: Get.width < 600
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Obx(() => InkWell(
                                onTap: controller.updateProfilePicture,
                                child: CircleAvatar(
                                  foregroundImage: authController.currentUser
                                              .value!.profilePicture !=
                                          null
                                      ? CachedNetworkImageProvider(
                                          authController.currentUser.value!
                                              .profilePicture!)
                                      : null,
                                  maxRadius: Get.width < 600 ? 40 : 70,
                                  child: authController.currentUser.value!
                                              .profilePicture ==
                                          null
                                      ? const Icon(Icons.account_circle,
                                          size: 50)
                                      : null,
                                ),
                              )),
                          const SizedBox(width: 30),
                          if (Get.width > 500)
                            Text(
                              authController.currentUser.value!.fullname,
                              style: Get.textTheme.bodyLarge,
                            ),
                          const SizedBox(width: 30),
                          Obx(() => IconButton(
                              tooltip: "Edit Profile",
                              onPressed: () {
                                controller.canEdit.value =
                                    !controller.canEdit.value;
                              },
                              icon: Icon(
                                controller.canEdit.value
                                    ? Icons.edit_off
                                    : Icons.edit,
                                size: 25,
                              )))
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),

                      // text fields

                      Obx(() => TextFormField(
                            controller: controller.usernameController,
                            validator: CustomFormValidators.usernameValidator,
                            style: const TextStyle(fontSize: 15),
                            readOnly: !controller.canEdit.value,
                            decoration: const InputDecoration(
                              labelText: 'Username',
                            ),
                          )),
                      const SizedBox(height: 25),
                      Obx(() => TextFormField(
                            controller: controller.fullnameController,
                            validator: CustomFormValidators.nameValidator,
                            keyboardType: TextInputType.name,
                            readOnly: !controller.canEdit.value,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              labelText: 'Full Name',
                            ),
                          )),
                      const SizedBox(height: 25),
                      Obx(() => TextFormField(
                            controller: controller.emailController,
                            validator: CustomFormValidators.emailValidator,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: !controller.canEdit.value,
                            style: const TextStyle(fontSize: 15),
                            decoration: const InputDecoration(
                              labelText: 'Email',
                            ),
                          )),
                      const SizedBox(height: 25),
                      Obx(() => TextFormField(
                            controller: controller.phoneNumberController,
                            validator:
                                CustomFormValidators.phoneNumberValidator,
                            style: const TextStyle(fontSize: 15),
                            keyboardType: TextInputType.phone,
                            readOnly: !controller.canEdit.value,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                            ),
                          )),
                      const SizedBox(height: 25),
                      // School info
                      Obx(() {
                        return controller
                                    .authController.currentUser.value!.role ==
                                Config.Parent
                            ? const SizedBox.shrink()
                            : Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 25),
                                  Obx(() => TextFormField(
                                        controller:
                                            controller.schooNameController,
                                        validator: (value) {
                                          if (controller.authController
                                                  .currentUser.value!.role !=
                                              Config.Parent) {
                                            return CustomFormValidators
                                                .nameValidator(value);
                                          }

                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 15),
                                        readOnly: !controller.canEdit.value,
                                        keyboardType: TextInputType.name,
                                        decoration: const InputDecoration(
                                          labelText: 'School Name',
                                        ),
                                      )),
                                  const SizedBox(height: 25),
                                  Obx(() => TextFormField(
                                        controller:
                                            controller.schoolLocationController,
                                        validator: (value) {
                                          if (controller.authController
                                                  .currentUser.value!.role !=
                                              Config.Parent) {
                                            return CustomFormValidators
                                                .nameValidator(value);
                                          }

                                          return null;
                                        },
                                        style: const TextStyle(fontSize: 15),
                                        keyboardType:
                                            TextInputType.streetAddress,
                                        readOnly: !controller.canEdit.value,
                                        decoration: const InputDecoration(
                                          labelText: 'School Location',
                                        ),
                                      )),
                                ],
                              );
                      }),
                      const SizedBox(height: 25),

                      Obx(() => controller.canEdit.value
                          ? ElevatedButton(
                              onPressed: () {
                                controller.updateProfile();
                              },
                              child: controller.isLoading.value
                                  ? SpinKitDualRing(
                                      color: Get.theme.colorScheme.onPrimary,
                                      lineWidth: 4,
                                      size: 20,
                                    )
                                  : const Text("Save"))
                          : const SizedBox.shrink())
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
