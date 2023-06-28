import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/models/student_model.dart';
import 'package:student_tracker/app/modules/home/controllers/children_marks_controller.dart';

class ChildrenProfileController extends GetxController {
  ChildrenProfileController() : super();

  static ChildrenProfileController get to => Get.find();

  final authController = AuthController.to;

  RxBool isLoading = true.obs;

  RxList<StudentModel> childrenList = RxList([]);

  TextEditingController codeController = TextEditingController();

  @override
  onInit() {
    super.onInit();

    fetchChildrenList(true);
  }

  Future<void> fetchChildrenList([bool inInit = false]) async {
    isLoading.value = true;

    final childrenSnapshot = await FirebaseFirestore.instance
        .collection("students")
        .where("parents", arrayContains: authController.currentUser.value!.ref)
        .get();

    final childrenFutures = childrenSnapshot.docs
        .map((doc) async => await StudentModel.fromJson(doc.data()))
        .toList();

    childrenList.value = await Future.wait<StudentModel>(childrenFutures);

    if (inInit) {
      ChildrenMarksController.to.currentChild.value = childrenList.firstOrNull;
      ChildrenMarksController.to.fetchCurrentChildMarks();
    }

    isLoading.value = false;
  }

  void registerStudent() async {
    codeController.clear();

    final res = await Get.dialog<bool?>(SizedBox(
      width: Get.width * 0.4,
      child: AlertDialog(
        title: const Text('Register Child'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Child Code'),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: Get.width < 600 ? double.maxFinite : 250,
            child: ElevatedButton(
              onPressed: () {
                Get.back(result: true);
              },
              child: const Text('Register'),
            ),
          ),
          if (Get.width > 600)
            SizedBox(
              width: Get.width < 600 ? double.maxFinite : 250,
              child: ElevatedButton(
                onPressed: () {
                  Get.back(result: false);
                },
                child: const Text('Cancel'),
              ),
            ),
        ],
      ),
    ));

    if (res != true) {
      codeController.clear();
      return;
    }

    Get.showOverlay(
        asyncFunction: () async {
          final results = await FirebaseFirestore.instance
              .collection("students")
              .where("code", isEqualTo: codeController.text)
              .limit(1)
              .get();

          if (results.docs.isEmpty) {
            Fluttertoast.showToast(
                msg: "No student with this code has been found");
            return;
          }

          final student = await StudentModel.fromJson(results.docs[0].data());

          student.parents = student.parents == null
              ? [authController.currentUser.value!]
              : student.parents! + [authController.currentUser.value!];

          await student.update();

          await fetchChildrenList(true);

          Fluttertoast.showToast(msg: "Child registered successfully");
        },
        loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
  }

  void removeChild(StudentModel child) async {
    final res = await Get.defaultDialog<bool?>(
        title: "Remove child",
        middleText: "Are you sure you want to remove ${child.fullName}?",
        confirmTextColor: Get.theme.colorScheme.error,
        cancelTextColor: Get.theme.colorScheme.primary,
        onConfirm: () {
          Get.back(result: true);
        },
        onCancel: () {
          Get.back(result: false);
        });

    if (res != true) return;

    Get.showOverlay(
        asyncFunction: () async {
          child.parents!
              .removeWhere((p) => p.id == authController.currentUser.value!.id);

          await child.update();

          await fetchChildrenList();

          Fluttertoast.showToast(msg: "Child Removed");
        },
        loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
  }
}
