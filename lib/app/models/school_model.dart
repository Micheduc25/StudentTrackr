import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_tracker/app/controllers/auth_controller.dart';
import 'package:student_tracker/app/models/user_model.dart';

import 'base_model.dart';

class SchoolModel extends BaseModel {
  String name;
  UserModel createdBy;
  String location;
  List<UserModel> admins;

  SchoolModel(
      {required String id,
      required DateTime created,
      required DateTime updated,
      required this.createdBy,
      required this.location,
      required this.name,
      required this.admins})
      : super(id: id, created: created, updated: updated) {
    collection = "schools";
  }

  static Future<SchoolModel> fromJson(Map<String, dynamic> json) async {
    List<UserModel>? schoolAdmins;
    if (json["admins"] != null) {
      final schoolAdminsRefs = ((json["admins"] as List<dynamic>)
              .cast<DocumentReference<Map<String, dynamic>>>())
          .map((userRef) => userRef.get())
          .toList();

      schoolAdmins = (await Future.wait(schoolAdminsRefs))
          .map<UserModel>((user) => UserModel.fromJson(user.data()!))
          .toList();
    }

    final creator = await (json['createdBy']).get();

    return SchoolModel(
        id: json["id"],
        name: json['name'],
        createdBy: UserModel.fromJson(creator.data()!),
        admins: schoolAdmins ?? [],
        location: json['location'],
        created: DateTime.parse(json['created']),
        updated: DateTime.parse(json['updated']));
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'name': name,
      'createdBy': createdBy.ref,
      'location': location,
      'admins': admins
          .map<DocumentReference<Map<String, dynamic>>>((a) => a.ref)
          .toList()
    };
  }

  static Future<SchoolModel> fetchCurrentSchoolModel() async {
    final collection = FirebaseFirestore.instance.collection("schools");

    final query = await (collection
        .where("createdBy", isEqualTo: AuthController.to.currentUser.value!.ref)
        .limit(1)
        .get());

    return SchoolModel.fromJson(query.docs.first.data());
  }

  static Future<List<SchoolModel>> fetchAllUserSchools() async {
    final collection = FirebaseFirestore.instance.collection("schools");

    final query = await (collection
        .where("admins",
            arrayContains: AuthController.to.currentUser.value!.ref)
        .get());

    final schools = await Future.wait(query.docs
        .map<Future<SchoolModel>>(
            (snapshot) => SchoolModel.fromJson(snapshot.data()))
        .toList());

    return schools;
  }
}
