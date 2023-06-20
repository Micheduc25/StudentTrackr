import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_tracker/app/controllers/school_controller.dart';
import 'package:student_tracker/app/controllers/settings_controller.dart';
import 'package:student_tracker/app/models/class_model.dart';
import 'package:student_tracker/app/models/school_model.dart';
import 'package:student_tracker/app/models/user_model.dart';
import 'package:student_tracker/app/modules/home/controllers/classes_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/marks_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/students_controller.dart';
import 'package:student_tracker/app/modules/home/controllers/subjects_controller.dart';
import 'package:student_tracker/app/routes/app_pages.dart';
import 'package:student_tracker/app/utils/config.dart';

class AuthController extends GetxService {
  AuthController() : super();

  static AuthController get to => Get.find<AuthController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final firestore = FirebaseFirestore.instance;

  Rx<UserModel?> currentUser = Rx(null);
  bool isAppStartRootineDone = false;

  // Get the current user
  User? get getCurrentFirebaseUser => _auth.currentUser;

  // Fetch the current user model of the application
  Future<UserModel?> fetchCurrentUserModel() async {
    if (_auth.currentUser == null) return null;

    try {
      final userdocSnapshot =
          await firestore.collection("users").doc(_auth.currentUser!.uid).get();

      UserModel model = UserModel.fromJson(userdocSnapshot.data()!);

      currentUser.value = model;
      return model;
    } on Exception catch (e) {
      return null;
    }
  }

  // routine executed each time the app launches
  Future<void> onAppInit() async {
    final settings = AppSettings.to;
    print(Get.currentRoute);

    _auth.authStateChanges().listen((User? user) async {
      if (user == null) {
        if (settings.isNotFirstLogin == true) {
          Get.rootDelegate.offNamed(Routes.LOGIN);
        } else {
          Get.rootDelegate.offNamed(Routes.SIGNUP);
        }
      } else {
        await appStartRoutine();
        isAppStartRootineDone = true;
      }
    });
  }

  Future<void> appStartRoutine() async {
    if ((await fetchCurrentUserModel()) != null) {
      // if the user hasn't verified his/her email, redirect to the verification page
      if (!_auth.currentUser!.emailVerified) {
        Get.rootDelegate.offNamed(Routes.VERIFY_EMAIL);
        return;
      }

      if (currentUser.value!.role != Config.Parent) {
        // if user is school admin, fetch his school or list of schools
        final schools = await SchoolModel.fetchAllUserSchools();

        final schoolsController = SchoolsController.to;
        final studentsController = StudentsController.to;
        final classesController = ClassesController.to;
        final subjectsController = SubjectsController.to;

        schoolsController.currentSchool.value = schools[0];
        schoolsController.schoolsList = schools.obs;

        // load all classes for the school
        await classesController.fetchClassesList();

        // fetch all students for the school
        await studentsController.fetchClassStudentsList();

        //fetch subjects for each class in the school
        await SubjectsController.to.fetchSubjectsList();

        if (classesController.classes.isNotEmpty) {
          studentsController.currentClass.value = classesController.classes[0];
          subjectsController.currentClass.value = classesController.classes[0];
        }
      }

      Get.rootDelegate.offNamed(Routes.HOME);
    } else {
      Fluttertoast.showToast(
          msg: "An error occured while fetching the current user");
      Get.rootDelegate.offNamed(Routes.LOGIN);
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    final res = await Get.defaultDialog<bool?>(
        title: "Logout",
        middleText: "Are you sure you want to log out from this account?",
        middleTextStyle: Get.textTheme.bodyMedium,
        cancelTextColor: Get.theme.colorScheme.primary,
        confirmTextColor: Get.theme.colorScheme.error,
        onConfirm: () {
          Get.back(result: true);
        },
        onCancel: () {
          Get.back(result: false);
        });

    if (res == true) {
      await _auth.signOut();
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
