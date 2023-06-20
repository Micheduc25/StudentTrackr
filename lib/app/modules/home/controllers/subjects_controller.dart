import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/models/class_model.dart';
import 'package:student_tracker/app/models/marks_model.dart';
import 'package:student_tracker/app/models/student_model.dart';
import 'package:student_tracker/app/models/subject_model.dart';
import 'package:student_tracker/app/modules/home/controllers/classes_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/students_controller.dart';

class SubjectsController extends GetxController {
  ClassesController classesController = ClassesController.to;

  RxMap<String, List<SubjectModel>> classesSubjects = RxMap();

  RxList<SubjectModel> subjects = <SubjectModel>[].obs;

  TextEditingController nameController = TextEditingController();

  RxBool isLoading = true.obs;

  static SubjectsController get to => Get.find();
  Rx<ClassModel?> currentClass = Rx(null);

  @override
  void onInit() {
    super.onInit();

    if (classesController.classes.isNotEmpty) {
      currentClass.value = classesController.classes[0];

      fetchSubjectsList();
    }
  }

  List<SubjectModel>? get getCurrentSubjects =>
      classesSubjects[currentClass.value!.id];

  Future<void> fetchSubjectsList() async {
    isLoading.value = true;
    List<SubjectModel> newSubjects = [];
    for (ClassModel cls in classesController.classes) {
      classesSubjects[cls.id] = await SubjectModel.fetchSubjectsList(cls.ref);

      classesSubjects[cls.id]!.sort((a, b) => a.name.compareTo(b.name));

      newSubjects.addAll(classesSubjects[cls.id]!);
    }

    if (classesController.classes.isEmpty) {
      currentClass.value = classesController.classes.firstOrNull;
    }

    isLoading.value = false;
  }

  void selectClass(String id) async {
    final selectedClass =
        classesController.classes.firstWhere((cls) => cls.id == id);

    currentClass.value = selectedClass;

    if (classesSubjects[id] == null) {
      await fetchSubjectsList();
    }

    update(["subjects_list"]);
  }

  void addSubject() {
    String name = nameController.text.trim();

    if (name.isNotEmpty) {
      Get.showOverlay(
          asyncFunction: () async {
            try {
              SubjectModel newSubject = SubjectModel(
                  id: "",
                  name: name,
                  subjectclass: currentClass.value!,
                  created: DateTime.now(),
                  updated: DateTime.now());

              //save subject to database
              newSubject = await newSubject.create();

              classesSubjects[currentClass.value!.id]!.insert(0, newSubject);

              // set default mark of zero for all students in that class for each sequence
              final studentsController = StudentsController.to;

              final studs =
                  studentsController.classesStudents[currentClass.value!.id]!;

              for (StudentModel stud in studs) {
                final now = DateTime.now();
                for (int i = 1; i <= 3; i++) {
                  final sequenceMark = MarksModel(
                      id: "",
                      created: now,
                      updated: now,
                      student: stud,
                      subject: newSubject,
                      value: null,
                      total: null,
                      sequence: i);

                  await sequenceMark.create();
                }
              }

              nameController.clear();
              update(["subjects_list"]);
            } on Exception catch (e) {
              Fluttertoast.showToast(
                  msg: "An error occurred while creating the class");
            }
          },
          loadingWidget:
              SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
    }
  }

  void editSubject(SubjectModel subject) async {
    nameController.text = subject.name;

    final res = await Get.dialog<bool?>(SizedBox(
      width: Get.width * 0.4,
      child: AlertDialog(
        title: const Text('Edit Subject'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Student Name'),
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
      nameController.clear();
    }

    String name = nameController.text.trim();

    final subjectIndex = subjects.indexWhere((cls) => cls.id == subject.id);

    if (subjectIndex == -1) return;

    if (name.isNotEmpty) {
      Get.showOverlay(
          asyncFunction: () async {
            try {
              classesSubjects[currentClass.value!.id]![subjectIndex].name =
                  name;

              classesSubjects[currentClass.value!.id]![subjectIndex].updated =
                  DateTime.now();

              await classesSubjects[currentClass.value!.id]![subjectIndex]
                  .update();

              update(["subjects_list"]);

              nameController.clear();
            } on Exception catch (e) {
              Fluttertoast.showToast(
                  msg:
                      "An error occurred while updating the subject: ${subjects[subjectIndex].name}");
            }
          },
          loadingWidget:
              SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
      nameController.clear();
    }
  }

  void deleteSubject(SubjectModel subjectModel) async {
    final res = await Get.defaultDialog<bool?>(
        title: "Delete ${subjectModel.name}",
        middleText: "Are you sure you want to delete ${subjectModel.name}?",
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
            // delete all marks belonging to that subject

            final subjectMarks = await FirebaseFirestore.instance
                .collection("marks")
                .where("subject", isEqualTo: subjectModel.ref)
                .get();

            for (final doc in subjectMarks.docs) {
              await doc.reference.delete();
            }

            //delete the subject itself
            await subjectModel.delete();

            //remove subject from subject list
            classesSubjects[currentClass.value!.id]!
                .removeWhere((sbj) => sbj.id == subjectModel.id);

            update(["subjects_list"]);
          } on Exception catch (e) {
            Fluttertoast.showToast(msg: "Failed to delete subject");
          }
        },
        loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
  }
}
