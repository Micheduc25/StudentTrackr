import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_tracker/app/models/user_model.dart';

import 'base_model.dart';
import 'class_model.dart';

class StudentModel extends BaseModel<StudentModel> {
  String fullName;
  String code;
  int? age;
  List<UserModel>? parents;
  ClassModel studentClass;
  int? year;

  StudentModel(
      {required String id,
      required DateTime created,
      required DateTime updated,
      required this.fullName,
      required this.code,
      required this.studentClass,
      this.year,
      this.age,
      this.parents})
      : super(id: id, created: created, updated: updated) {
    collection = "students";
    year = year ?? DateTime.now().year;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'fullName': fullName,
      'code': code,
      'age': age,
      'parents': parents?.map((p) => p.ref).toList(),
      'class': studentClass.ref,
      'year': year
    };
  }

  static Future<StudentModel> fromJson(Map<String, dynamic> json) async {
    List<UserModel>? studentParents;
    if (json["parents"] != null) {
      final studentParentsRefs = (json["parents"] as List<dynamic>)
          .cast<DocumentReference<Map<String, dynamic>>>()
          .map((userRef) => userRef.get())
          .toList();

      studentParents = (await Future.wait(studentParentsRefs))
          .map<UserModel>((user) => UserModel.fromJson(user.data()!))
          .toList();
    }
    return StudentModel(
      id: json["id"],
      code: json["code"],
      year: json["year"],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      fullName: json['fullName'] as String,
      age: json['age'],
      parents: studentParents,
      studentClass: await ClassModel.fromJson(
          (await (json['class'] as DocumentReference<Map<String, dynamic>>)
                  .get())
              .data()!),
    );
  }

  static Future<List<StudentModel>> fetchClassStudentsList(
      DocumentReference<Map<String, dynamic>> classRef) async {
    final collection = FirebaseFirestore.instance.collection("students");

    final query = await (collection.where("class", isEqualTo: classRef).get());

    final classes = await Future.wait(query.docs
        .map<Future<StudentModel>>((cls) => StudentModel.fromJson(cls.data()))
        .toList());

    return classes;
  }
}
