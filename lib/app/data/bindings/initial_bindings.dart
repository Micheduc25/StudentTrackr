import 'package:get/get.dart';
import 'package:student_tracker/app/controllers/settings_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/classes_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/home_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/marks_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/students_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/subjects_controller.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/school_controller.dart';
import '../../controllers/user_controller.dart';

class InitialBindings implements Bindings {
  // Override the dependencies method
  @override
  void dependencies() {
    Get.put<AppSettings>(AppSettings());

    Get.put<AuthController>(AuthController());

    Get.put<UserController>(UserController());

    Get.put<SchoolsController>(SchoolsController());

    Get.put<ClassesController>(ClassesController());

    Get.put<StudentsController>(StudentsController());

    Get.put<SubjectsController>(SubjectsController());
  }
}
