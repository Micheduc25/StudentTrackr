import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:student_tracker/app/controllers/school_controller.dart';
import 'package:student_tracker/app/controllers/settings_controller.dart';
import 'package:student_tracker/app/models/class_model.dart';
import 'package:student_tracker/app/models/marks_model.dart';
import 'package:student_tracker/app/models/subject_model.dart';
import 'package:student_tracker/app/modules/home/controllers/classes_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/subjects_controller.dart';

import 'students_controller.dart';

class MarksController extends GetxController {
  late RxList<int> yearsList;
  RxList<int> sequencesList = RxList([1, 2, 3]);

  Map<String, TextEditingController> marksControllersMap =
      <String, TextEditingController>{};

  final classesController = ClassesController.to;

  final subjectsController = SubjectsController.to;

  final studentsController = StudentsController.to;

  late Rx<ClassModel?> selectedClass;
  late Rx<SubjectModel?> selectedSubject;

  late RxInt selectedYear;

  late RxInt selectedSequence;

  RxBool isLoading = false.obs;

  MarksController() : super() {
    //generate school year list

    final initalSchoolYear =
        SchoolsController.to.currentSchool.value!.created.year;

    final finalSchoolYear = DateTime.now().year;

    yearsList = List.generate(((finalSchoolYear - initalSchoolYear) + 1),
        (index) => initalSchoolYear + index).obs;

    // set default class
    selectedClass = Rx(classesController.classes.isNotEmpty
        ? classesController.classes[0]
        : null);

    //set default subject value
    selectedSubject = Rx(subjectsController.getCurrentSubjects?[0]);

    //set default year
    selectedYear = yearsList.first.obs;

    //set default sequence
    selectedSequence = sequencesList.first.obs;
  }

  static MarksController get to => Get.find();

  @override
  void onInit() {
    super.onInit();
  }

  void selectYear(int year) async {
    selectedYear.value = year;
  }

  void selectClass(String id) async {
    selectedClass.value =
        classesController.classes.firstWhereOrNull((cls) => cls.id == id);

    if (subjectsController
        .classesSubjects[selectedClass.value!.id]!.isNotEmpty) {
      selectedSubject.value =
          subjectsController.classesSubjects[selectedClass.value!.id]![0];
    }
  }

  void selectSubject(String id) async {
    selectedSubject.value = subjectsController
        .classesSubjects[selectedClass.value!.id]!
        .firstWhereOrNull((subj) => subj.id == id);
  }

  void selectSequence(int sequence) async {
    selectedSequence.value = sequence;
  }

  Stream<List<Future<MarksModel>>> getMarksStream() {
    final stream = MarksModel.getMarksStream(selectedClass.value!.ref,
        selectedSubject.value!.ref, selectedYear.value, selectedSequence.value);
    return stream;
  }

  void saveMarks(MarksModel mark) async {
    if (marksControllersMap[mark.id] == null) return;

    final markValue = double.tryParse(marksControllersMap[mark.id]!.text);

    // make sure mark is not more than total
    if (markValue != null && markValue > AppSettings.to.markTotal) {
      Fluttertoast.showToast(
        msg: "The mark cannot be more than ${AppSettings.to.markTotal}",
        webBgColor: "#ff0000",
      );
      return;
    }

    mark.value = markValue;
    mark.updated = DateTime.now();

    Get.showOverlay(
        asyncFunction: () async {
          try {
            await mark.update();

            Fluttertoast.showToast(msg: "Mark updated successfully");
          } on Exception catch (e) {
            Fluttertoast.showToast(
                msg: "An error occurred while saving the marks");
          }
        },
        loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
  }

  void saveAllMarks() async {
    if (marksControllersMap.values.isNotEmpty) {
      final collection = FirebaseFirestore.instance.collection("marks");

      Get.showOverlay(
          asyncFunction: () async {
            for (String id in marksControllersMap.keys) {
              final value = double.tryParse(marksControllersMap[id]!.text);

              if (value != null && value > AppSettings.to.markTotal) {
                Fluttertoast.showToast(
                  msg:
                      "The mark cannot be more than ${AppSettings.to.markTotal}",
                  webBgColor: "#ff0000",
                );
                continue;
              }

              await collection.doc(id).update({
                "value": value,
                "updated": DateTime.now().toIso8601String()
              });
            }
          },
          loadingWidget:
              SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
    }
  }
}
