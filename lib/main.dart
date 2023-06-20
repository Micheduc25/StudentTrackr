import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/data/bindings/initial_bindings.dart';
import 'package:student_tracker/app/themes/dark.dart';
import 'package:student_tracker/app/themes/light.dart';

import 'app/routes/app_pages.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();

  runApp(
    GetMaterialApp.router(
      title: "StudentTrackr",
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBindings(),
      getPages: AppPages.routes,
      theme: lightTheme,
      darkTheme: darkTheme,
      routerDelegate: Get.rootDelegate,
      onReady: () {
        AuthController.to.onAppInit();
      },
    ),
  );
}
