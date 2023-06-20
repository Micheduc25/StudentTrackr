import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/school_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SchoolsController());

    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
  }
}
