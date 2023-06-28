import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/controllers/school_controller.dart';
import 'package:student_tracker/app/utils/config.dart';
import 'package:student_tracker/app/utils/helpers.dart';
import 'package:uuid/uuid.dart';

class ProfileController extends GetxService {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Rx<AutovalidateMode> autovalidateMode =
      Rx<AutovalidateMode>(AutovalidateMode.disabled);

  RxBool isLoading = false.obs;

  final authController = AuthController.to;

  // Create text editing controllers for the text form fields
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController schooNameController = TextEditingController();
  TextEditingController schoolLocationController = TextEditingController();

  RxBool canEdit = false.obs;

  ProfileController() : super();

  static ProfileController get to => Get.find();

  @override
  void onInit() {
    final currentUser = authController.currentUser.value!;

    usernameController.text = currentUser.username;

    fullnameController.text = currentUser.fullname;

    emailController.text = currentUser.email;

    phoneNumberController.text = currentUser.phoneNumber;

    if (currentUser.role != Config.Parent) {
      schooNameController.text = SchoolsController.to.currentSchool.value!.name;
      schoolLocationController.text =
          SchoolsController.to.currentSchool.value!.location;
    }

    super.onInit();
  }

  void updateProfilePicture() async {
    Get.showOverlay(
        asyncFunction: () async {
          final imgFile =
              await ImagePicker().pickImage(source: ImageSource.gallery);

          if (imgFile == null) return;

          try {
            final storage = FirebaseStorage.instance;
            final Reference ref = storage.ref().child(
                'images/${const Uuid().v4()}.${imgFile.name.split('.').last}');

            final fileBytes = await imgFile.readAsBytes();

            final TaskSnapshot task = await ref.putData(
                fileBytes,
                SettableMetadata(
                    contentType: 'image/${imgFile.name.split('.').last}'));

            final String downloadUrl = await task.ref.getDownloadURL();

            authController.currentUser.value!.profilePicture = downloadUrl;

            await authController.currentUser.value!.update();
          } on Exception catch (_) {
            Fluttertoast.showToast(
                msg: "An error occurred while updating profile photo",
                webBgColor: "#ff0000");
          }
        },
        loadingWidget: SpinKitDualRing(color: Get.theme.colorScheme.onPrimary));
  }

  void updateProfile() async {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      final currentUser = AuthController.to.currentUser.value!;

      final updatedUserMap = {};

      if (usernameController.text != currentUser.username) {
        updatedUserMap["username"] = usernameController.text;
      }

      if (fullnameController.text != currentUser.fullname) {
        updatedUserMap["fullname"] = fullnameController.text;
      }

      if (phoneNumberController.text != currentUser.phoneNumber) {
        updatedUserMap["phoneNumber"] = phoneNumberController.text;
      }

      try {
        isLoading.value = true;
        await FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser.id)
            .update({
          ...updatedUserMap,
          "updated": DateTime.now().toIso8601String()
        });

        authController.currentUser.value!.username = updatedUserMap["username"];
        authController.currentUser.value!.fullname = updatedUserMap["fullname"];
        authController.currentUser.value!.phoneNumber =
            updatedUserMap["phoneNumber"];

        // if school information was changed update it
        if (currentUser.role != Config.Parent) {
          final schoolsController = SchoolsController.to;

          if (schoolsController.currentSchool.value!.name !=
              schooNameController.text) {
            schoolsController.currentSchool.value!.name =
                schooNameController.text;
          }

          if (schoolsController.currentSchool.value!.location !=
              schoolLocationController.text) {
            schoolsController.currentSchool.value!.location =
                schoolLocationController.text;
          }

          await schoolsController.currentSchool.value!.update();
        }

        canEdit.value = false;
        Fluttertoast.showToast(
          msg: "Profile updated successfully!",
        );
      } catch (e) {
        Fluttertoast.showToast(
            msg: "An error occurred while updating the user",
            webBgColor: "#ff0000");
      } finally {
        isLoading.value = false;
      }
    } else {
      autovalidateMode.value = AutovalidateMode.always;
    }
  }
}
