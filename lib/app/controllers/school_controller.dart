import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:student_tracker/app/models/school_model.dart';

class SchoolsController extends GetxController {
  SchoolsController() : super();

  static SchoolsController get to => Get.find();

  Rx<SchoolModel?> currentSchool = Rx(null);

  RxList schoolsList = RxList();

  @override
  void onInit() {
    super.onInit();
  }

  void fetchSchool() async {
    try {
      currentSchool.value = await SchoolModel.fetchCurrentSchoolModel();
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "unable to fetch current school");
    }
  }
}
