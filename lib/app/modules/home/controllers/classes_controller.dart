import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/school_controller.dart';
import 'package:student_tracker/app/models/base_model.dart';
import 'package:student_tracker/app/models/class_model.dart';

class ClassesController extends GetxController {
  RxList<ClassModel> classes = <ClassModel>[].obs;

  TextEditingController nameController = TextEditingController();

  RxBool isLoading = true.obs;

  static ClassesController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchClassesList() async {
    isLoading.value = true;
    classes.value = await ClassModel.fetchClassList(
        SchoolsController.to.currentSchool.value!.ref);

    classes.sort((a, b) => a.name.compareTo(b.name));

    isLoading.value = false;
  }

  void addClass() {
    String name = nameController.text.trim();

    if (name.isNotEmpty) {
      Get.showOverlay(
          asyncFunction: () async {
            try {
              ClassModel newClass = ClassModel(
                  id: "",
                  name: name,
                  school: SchoolsController.to.currentSchool.value!,
                  created: DateTime.now(),
                  updated: DateTime.now());

              newClass = await newClass.create();

              classes.insert(0, newClass);

              nameController.clear();
            } on Exception catch (e) {
              Fluttertoast.showToast(
                  msg: "An error occurred while creating the class");
            }
          },
          loadingWidget:
              SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
    }
  }

  void editClass(String id) {
    String name = nameController.text.trim();

    final classIndex = classes.indexWhere((cls) => cls.id == id);

    if (classIndex == -1) return;

    if (name.isNotEmpty) {
      Get.showOverlay(
          asyncFunction: () async {
            try {
              classes[classIndex].name = name;
              classes[classIndex].updated = DateTime.now();

              await classes[classIndex].update();

              update(["classes_list"]);

              nameController.clear();
            } on Exception catch (e) {
              Fluttertoast.showToast(
                  msg:
                      "An error occurred while updating the class ${classes[classIndex].name}");
            }
          },
          loadingWidget:
              SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
      nameController.clear();
    }
  }

  void deleteClass(ClassModel classModel) async {
    final res = await Get.defaultDialog<bool?>(
        title: "Delete",
        middleText: "Are you sure you want to delete this class?",
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
          try {
            final classToDelete =
                classes.firstWhereOrNull((cls) => cls.id == classModel.id);

            if (classToDelete == null) return;

            await classToDelete.delete();

            classes.removeWhere((cls) => cls.id == classToDelete.id);
          } on Exception catch (e) {
            Fluttertoast.showToast(msg: "Failed to delete class");
          }
        },
        loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
  }
}
