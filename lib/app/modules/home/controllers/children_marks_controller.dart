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

  Future<List<MarksModel>?> fetchCurrentChildMarks([int? sequence]) async {
    if (currentChild.value == null) {
      isLoading.value = false;
      return null;
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

      Fluttertoast.showToast(msg: "Latest Marks retrieved");

      isLoading.value = false;

      return childrenMarksMap[currentChild.value!.id];
    } on Exception catch (e) {
      isLoading.value = false;

      Fluttertoast.showToast(msg: "An error occurred while loadin the marks");
    }
    return null;
  }

  Future<Map<String, List<MarksModel>>> fetchAllChildrenMarks() async {
    final marksMap = <String, List<MarksModel>>{};
    final marksCollection = FirebaseFirestore.instance.collection("marks");

    for (final StudentModel child
        in ChildrenProfileController.to.childrenList) {
      List<MarksModel> currentMarks = [];

      final marksQuery = marksCollection.where("student", isEqualTo: child.ref);

      for (final sequence in [1, 2, 3]) {
        final sequenceQuery = marksQuery.where("sequence", isEqualTo: sequence);
        final marksSnapshot = await sequenceQuery.get();

        final sequenceMarks = marksSnapshot.docs
            .map<Future<MarksModel>>((doc) => MarksModel.fromJson(doc.data()))
            .toList();

        currentMarks.addAll(await Future.wait(sequenceMarks));
      }
      marksMap[child.id] = currentMarks;
    }
    return marksMap;
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

  Map<String, double?>? calculateOverallPerformancesPerChild() {
    if (childrenMarksMap.isEmpty) return null;

    Map<String, double?> totalsMap = {
      for (String el in childrenMarksMap.keys) el: null
    };

    for (final String currentId in childrenMarksMap.keys) {
      if (childrenMarksMap[currentId] == null ||
          childrenMarksMap[currentId]!.isEmpty) continue;
      // calculate total for each child
      double markSum = 0;
      double markTotal = 0;

      for (MarksModel mark in childrenMarksMap[currentId]!) {
        if (mark.value == null) continue;

        markSum += mark.value!;
        markTotal += AppSettings.to.markTotal;
      }

      if (markTotal == 0) continue;

      totalsMap[currentId] = (markSum / markTotal) * 100;
    }

    return totalsMap;
  }

  Future<Map<String, double>> calculatePerformancesPerChild(
      double MARK_TOTAL) async {
    final allChildrenMarksMap = await fetchAllChildrenMarks();

    Map<String, double> averagesMap = {};
    for (final String currentId in allChildrenMarksMap.keys.toSet()) {
      if (allChildrenMarksMap[currentId] == null ||
          allChildrenMarksMap[currentId]!.isEmpty) continue;

      List<MarksModel> marks = allChildrenMarksMap[currentId]!;

      double markSum = marks
          .where((mark) => mark.value != null)
          .map((mark) => (mark.value! * mark.subject.coefficient))
          .reduce((a, b) => a + b);

      double markTotal = marks.length * MARK_TOTAL;
      if (markTotal == 0) continue;
      averagesMap[currentId] = (markSum / markTotal) * 100;
    }
    return averagesMap;
  }

  Future<double?> calculateTotalAveragePerformance() async {
    try {
      final averagePerStudent =
          await calculatePerformancesPerChild(AppSettings.to.markTotal);

      if (averagePerStudent.isEmpty) return null;

      final averageTotal = averagePerStudent.values.reduce((a, b) => a + b);
      final finalAverage = averageTotal / averagePerStudent.values.length;

      return finalAverage;
    } on Exception catch (e) {
      return null;
    }
  }
}
