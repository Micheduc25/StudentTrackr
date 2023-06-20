import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:student_tracker/app/controllers/settings_controller.dart';
import 'package:student_tracker/app/models/marks_model.dart';
import 'package:student_tracker/app/modules/home/controllers/children_profile_controller.dart';

import '../../../models/student_model.dart';

class ChildrenMarksController extends GetxController {
  ChildrenMarksController() : super();

  RxMap<String, List<MarksModel>> childrenMarksMap =
      <String, List<MarksModel>>{}.obs;

  RxList sequenceList = <int>[1, 2, 3].obs;

  RxBool isLoading = true.obs;

  static ChildrenMarksController get to => Get.find();

  final childrenProfileController = ChildrenProfileController.to;

  RxInt selectedSequence = 1.obs;

  Rx<StudentModel?> currentChild =
      Rx<StudentModel?>(ChildrenProfileController.to.childrenList.firstOrNull);

  @override
  onInit() {
    super.onInit();

    fetchCurrentChildMarks();
  }

  Future<void> fetchCurrentChildMarks([int? sequence]) async {
    if (currentChild.value == null) {
      isLoading.value = false;
    }

    // if (childrenMarksMap[currentChild.value!.id] == null &&
    //     sequence == selectedSequence.value) {
    // }
    isLoading.value = true;

    try {
      final marksSnapshot = await FirebaseFirestore.instance
          .collection("marks")
          .where("student", isEqualTo: currentChild.value!.ref)
          .where("sequence", isEqualTo: selectedSequence.value)
          .get();

      final marksList = marksSnapshot.docs
          .map<Future<MarksModel>>(
              (doc) async => await MarksModel.fromJson(doc.data()))
          .toList();

      childrenMarksMap[currentChild.value!.id] =
          await Future.wait<MarksModel>(marksList);
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "An error occurred while loadin the marks");
    }

    Fluttertoast.showToast(msg: "Latest Marks retrieved");

    isLoading.value = false;
  }

  void selectChild(String childId) async {
    final selectedChild = ChildrenProfileController.to.childrenList
        .firstWhereOrNull((c) => c.id == childId);

    if (selectedChild == null) return;

    currentChild.value = selectedChild;

    // load the child's marks
    fetchCurrentChildMarks(selectedSequence.value);
  }

  void selectSequence(int sequence) {
    selectedSequence.value = sequence;

    // load the child's marks
    fetchCurrentChildMarks(sequence);
  }

  double getStudentTotalMarkObtained() {
    if (childrenMarksMap[currentChild.value!.id] == null) {
      return 0;
    }

    double sum = 0;

    for (final MarksModel mark in childrenMarksMap[currentChild.value!.id]!) {
      if (mark.value != null) sum += mark.value!;
    }

    return sum;
  }

  double getStudentTotalSubjectsMarks() {
    if (childrenMarksMap[currentChild.value!.id] == null) {
      return 0;
    }

    double sum = 0;

    for (final MarksModel mark in childrenMarksMap[currentChild.value!.id]!) {
      if (mark.total != null && mark.value != null) {
        sum += mark.total!;
      } else if (mark.value != null && mark.total == null) {
        sum += AppSettings.to.markTotal;
      }
    }

    return sum;
  }

  double getAverage() {
    final average =
        getStudentTotalMarkObtained() / getStudentTotalSubjectsMarks() * 20;

    return average;
  }
}
