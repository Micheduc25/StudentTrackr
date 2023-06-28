import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/models/marks_model.dart';
import 'package:student_tracker/app/models/student_model.dart';
import 'package:student_tracker/app/modules/home/controllers/children_marks_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/children_profile_controller.dart';

class DashboardController extends GetxController {
  DashboardController() : super();

  static DashboardController get to => Get.find();

  RxBool isLoading = true.obs;

  RxMap<String, RxList<MarksModel>> lastUploadedResults =
      RxMap<String, RxList<MarksModel>>({});

  @override
  onInit() {
    super.onInit();
    initController();
  }

  Future<void> initController() async {
    isLoading.value = true;
    await loadChildrenLastMarks();
    isLoading.value = false;
  }

  Future<void> loadChildrenLastMarks() async {
    final childrenController = ChildrenProfileController.to;

    if (childrenController.childrenList.isEmpty) {
      // attempt to load the children first

      await childrenController.fetchChildrenList(true);
    }

    final children = childrenController.childrenList;

    if (children.isEmpty) {
      return;
    }

    for (final child in children) {
      final childLastMarksDocs = await FirebaseFirestore.instance
          .collection("marks")
          .where("student", isEqualTo: child.ref)
          .orderBy("updated")
          .limitToLast(1)
          .get();

      final childMarks = await Future.wait(childLastMarksDocs.docs
          .map<Future<MarksModel>>(
              (doc) async => await MarksModel.fromJson(doc.data())));

      lastUploadedResults[child.id] = childMarks.obs;
    }
  }

  Future<void> calculateOverallPerformance() async {
    final resultsController = ChildrenMarksController.to;

    if (resultsController.childrenMarksMap.isEmpty) {
      //attempt to get the children marks

      await resultsController.fetchCurrentChildMarks();
    }
  }
}
