import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_tracker/app/models/school_model.dart';

import 'base_model.dart';

class ClassModel extends BaseModel<ClassModel> {
  String name;
  SchoolModel school;

  ClassModel({
    required String id,
    required DateTime created,
    required DateTime updated,
    required this.school,
    required this.name,
  }) : super(id: id, created: created, updated: updated) {
    collection = "classes";
  }

  @override
  Map<String, dynamic> toMap() {
    return {...super.toMap(), 'name': name, 'school': school.ref};
  }

  @override
  String toString() {
    return name;
  }

  static Future<ClassModel> fromJson(Map<String, dynamic> json) async {
    final schoolMap =
        (await (json['school'] as DocumentReference<Map<String, dynamic>>)
                .get())
            .data()!;

    return ClassModel(
        id: json["id"],
        school: await SchoolModel.fromJson(schoolMap),
        created: DateTime.parse(json["created"]),
        updated: DateTime.parse(json["updated"]),
        name: json["name"]);
  }

  static Future<List<ClassModel>> fetchClassList(
      DocumentReference<Map<String, dynamic>> schoolRef) async {
    final collection = FirebaseFirestore.instance.collection("classes");

    final query =
        await (collection.where("school", isEqualTo: schoolRef).get());

    final classes = await Future.wait(query.docs
        .map<Future<ClassModel>>((cls) => ClassModel.fromJson(cls.data()))
        .toList());

    return classes;
  }
}
