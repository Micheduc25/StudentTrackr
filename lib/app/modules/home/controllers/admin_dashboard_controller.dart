import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/models/marks_model.dart';
import 'package:student_tracker/app/models/subject_model.dart';

import '../../../models/student_model.dart';

class AdminDashboardController extends GetxController {
  AdminDashboardController() : super();

  static AdminDashboardController get to => Get.find();

  RxList<MarksModel> lastMarksUploaded = RxList([]);
  RxList<StudentModel> lastStudentsUploaded = RxList([]);
  RxList<SubjectModel> lastSubjectsUploaded = RxList([]);

  RxBool isLoading = true.obs;

  @override
  onInit() {
    super.onInit();

    initDashboard();
  }

  Future<void> initDashboard() async {
    isLoading.value = true;
    await loadLastMarks();
    await loadLastStudents();
    await loadLastSubjects();
    isLoading.value = false;
  }

  Future<void> loadLastMarks() async {
    try {
      final lastUploadedMarks = await FirebaseFirestore.instance
          .collection("marks")
          .orderBy(
            "created",
          )
          .limitToLast(1)
          .get();

      if (lastUploadedMarks.docs.isNotEmpty) {
        final marksFutures = lastUploadedMarks.docs
            .map((doc) async => MarksModel.fromJson(doc.data()))
            .toList();

        lastMarksUploaded.value = await Future.wait(marksFutures);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred while loading the last marks",
        webBgColor: "#ff0000",
      );
    }
  }

  Future<void> loadLastStudents() async {
    try {
      final lastUploadedStudents = await FirebaseFirestore.instance
          .collection("students")
          .orderBy(
            "created",
          )
          .limitToLast(1)
          .get();

      if (lastUploadedStudents.docs.isNotEmpty) {
        final studentsFutures = lastUploadedStudents.docs
            .map((doc) async => StudentModel.fromJson(doc.data()))
            .toList();

        lastStudentsUploaded.value = await Future.wait(studentsFutures);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred while loading the last students",
        webBgColor: "#ff0000",
      );
    }
  }

  Future<void> loadLastSubjects() async {
    try {
      final lastUploadedSubjects = await FirebaseFirestore.instance
          .collection("subjects")
          .orderBy(
            "created",
          )
          .limitToLast(1)
          .get();

      if (lastUploadedSubjects.docs.isNotEmpty) {
        final subjectsFutures = lastUploadedSubjects.docs
            .map((doc) async => SubjectModel.fromJson(doc.data()))
            .toList();

        lastSubjectsUploaded.value = await Future.wait(subjectsFutures);
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred while loading the last subjects",
        webBgColor: "#ff0000",
      );
    }
  }
}
