import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/models/class_model.dart';
import 'package:student_tracker/app/models/student_model.dart';
import 'package:student_tracker/app/modules/home/controllers/classes_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/subjects_controller.dart';
import 'package:uuid/uuid.dart';

import '../../../models/marks_model.dart';

class StudentsController extends GetxController {
  final classesController = ClassesController.to;

  RxMap<String, List<StudentModel>> classesStudents = RxMap();

  RxList<StudentModel> students = <StudentModel>[].obs;

  Rx<ClassModel?> currentClass = Rx(null);

  TextEditingController fullNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  RxBool isLoading = true.obs;

  static StudentsController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  List<StudentModel>? get getCurrentStudents =>
      classesStudents[currentClass.value!.id];

  Future<void> fetchClassStudentsList() async {
    isLoading.value = true;

    for (ClassModel cls in classesController.classes) {
      classesStudents[cls.id] =
          await StudentModel.fetchClassStudentsList(cls.ref);

      classesStudents[cls.id]!.sort((a, b) => a.fullName.compareTo(b.fullName));
    }

    if (classesController.classes.isEmpty) {
      currentClass.value = classesController.classes.firstOrNull;
    }

    update(["students_list"]);

    isLoading.value = false;
  }

  void selectClass(String id) async {
    final selectedClass =
        classesController.classes.firstWhere((cls) => cls.id == id);

    currentClass.value = selectedClass;

    if (classesStudents[id] == null) {
      await fetchClassStudentsList();
    }

    update(["students_list"]);
  }

  void addStudent() {
    String name = fullNameController.text.trim();

    String age = ageController.text.trim();

    if (name.isNotEmpty) {
      Get.showOverlay(
          asyncFunction: () async {
            try {
              final now = DateTime.now();
              StudentModel newStudent = StudentModel(
                  id: "",
                  created: now,
                  updated: now,
                  fullName: name,
                  code: generateUniqueCode(),
                  age: int.tryParse(age),
                  studentClass: currentClass.value!);

              newStudent = await newStudent.create();

              classesStudents[currentClass.value!.id]!.insert(0, newStudent);

              // give student default marks for all subjects in his class

              final studentsSubjects = SubjectsController
                  .to.classesSubjects[currentClass.value!.id]!;

              for (final subject in studentsSubjects) {
                final now = DateTime.now();

                for (int i = 1; i <= 3; i++) {
                  final sequenceMark = MarksModel(
                      id: "",
                      created: now,
                      updated: now,
                      student: newStudent,
                      subject: subject,
                      value: null,
                      total: null,
                      sequence: i);

                  await sequenceMark.create();
                }
              }

              update(["students_list"]);

              fullNameController.clear();
              ageController.clear();
            } on Exception catch (e) {
              Fluttertoast.showToast(
                  msg: "An error occurred while creating the class");
            }
          },
          loadingWidget:
              SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
    }
  }

  void editStudent(StudentModel student) async {
    fullNameController.text = student.fullName;
    ageController.text = student.age.toString();
    final res = await Get.dialog<bool?>(SizedBox(
      width: Get.width * 0.4,
      child: AlertDialog(
        title: const Text('Edit Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            const SizedBox(
              height: 16,
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 250,
            child: ElevatedButton(
              onPressed: () {
                Get.back(result: true);
              },
              child: const Text('Save'),
            ),
          ),
          SizedBox(
            width: 250,
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
      fullNameController.clear();
      ageController.clear();
    }

    String name = fullNameController.text.trim();
    String age = ageController.text.trim();

    final studentIndex = classesStudents[currentClass.value!.id]!
        .indexWhere((stud) => stud.id == student.id);

    if (studentIndex == -1) return;

    if (name.isNotEmpty) {
      Get.showOverlay(
          asyncFunction: () async {
            try {
              classesStudents[currentClass.value!.id]![studentIndex].fullName =
                  name;

              classesStudents[currentClass.value!.id]![studentIndex].age =
                  int.tryParse(age);

              classesStudents[currentClass.value!.id]![studentIndex].updated =
                  DateTime.now();

              await classesStudents[currentClass.value!.id]![studentIndex]
                  .update();

              update(["students_list"]);

              fullNameController.clear();
            } on Exception catch (e) {
              Fluttertoast.showToast(
                  msg:
                      "An error occurred while updating the class ${classesStudents[currentClass.value!.id]![studentIndex].fullName}");
            }
          },
          loadingWidget:
              SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
      fullNameController.clear();
    }
  }

  void deleteStudent(StudentModel studentModel) async {
    final res = await Get.defaultDialog<bool?>(
        title: "Delete",
        middleText: "Are you sure you want to delete ${studentModel.fullName}?",
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
            final studentToDelete = classesStudents[currentClass.value!.id]!
                .firstWhereOrNull((stud) => stud.id == studentModel.id);

            if (studentToDelete == null) return;

            // delete all of the students marks in all courses

            final studentMarks = await FirebaseFirestore.instance
                .collection("marks")
                .where("student", isEqualTo: studentToDelete.ref)
                .get();

            for (final mark in studentMarks.docs) {
              await mark.reference.delete();
            }

            // delete the student himself
            await studentToDelete.delete();

            classesStudents[currentClass.value!.id]!
                .removeWhere((stud) => stud.id == studentToDelete.id);

            update(["students_list"]);
          } on Exception catch (e) {
            Fluttertoast.showToast(msg: "Failed to delete class");
          }
        },
        loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
  }

  String generateUniqueCode() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
