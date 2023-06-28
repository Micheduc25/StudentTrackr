import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_tracker/app/models/class_model.dart';

import 'base_model.dart';

class SubjectModel extends BaseModel<SubjectModel> {
  String name;
  ClassModel subjectclass;
  int coefficient;
  SubjectModel(
      {required String id,
      required DateTime created,
      required DateTime updated,
      required this.subjectclass,
      required this.name,
      this.coefficient = 1})
      : super(id: id, created: created, updated: updated) {
    collection = "subjects";
  }

  @override
  String toString() {
    return name;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'name': name,
      'coefficient': coefficient,
      'class': subjectclass.ref
    };
  }

  static Future<SubjectModel> fromJson(Map<String, dynamic> json) async {
    return SubjectModel(
      id: json["id"],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      coefficient: json['coefficient'] ?? 1,
      subjectclass: await ClassModel.fromJson(
          (await (json['class'] as DocumentReference<Map<String, dynamic>>)
                  .get())
              .data()!),
      name: json['name'] as String,
    );
  }

  static Future<List<SubjectModel>> fetchSubjectsList(
      DocumentReference<Map<String, dynamic>> classRef) async {
    final collection = FirebaseFirestore.instance.collection("subjects");

    final query = await (collection.where("class", isEqualTo: classRef).get());

    final subjects = await Future.wait(query.docs
        .map<Future<SubjectModel>>((subj) => SubjectModel.fromJson(subj.data()))
        .toList());

    return subjects;
  }
}
