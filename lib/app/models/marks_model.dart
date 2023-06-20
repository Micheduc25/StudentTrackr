import 'package:cloud_firestore/cloud_firestore.dart';

import 'base_model.dart';
import 'student_model.dart';
import 'subject_model.dart';

class MarksModel extends BaseModel<MarksModel> {
  StudentModel student;
  SubjectModel subject;
  double? value;
  double? total;
  int sequence;
  int? year;

  MarksModel(
      {required String id,
      required DateTime created,
      required DateTime updated,
      required this.student,
      required this.subject,
      required this.value,
      required this.total,
      required this.sequence,
      this.year})
      : super(id: id, created: created, updated: updated) {
    collection = "marks";
    year = year ?? DateTime.now().year;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'student': student.ref,
      'subject': subject.ref,
      'value': value,
      'total': total,
      'sequence': sequence,
      'year': year,
    };
  }

  static Future<MarksModel> fromJson(Map<String, dynamic> json) async {
    return MarksModel(
      id: json["id"],
      created: DateTime.parse(json['created']),
      updated: DateTime.parse(json['updated']),
      sequence: json['sequence'] as int,
      student: await StudentModel.fromJson(
          (await (json['student'] as DocumentReference<Map<String, dynamic>>)
                  .get())
              .data()!),
      subject: await SubjectModel.fromJson(
          (await (json['subject'] as DocumentReference<Map<String, dynamic>>)
                  .get())
              .data()!),
      value: json['value'] as double?,
      total: json['total'] as double?,
      year: json['year'] as int,
    );
  }

  static Stream<List<Future<MarksModel>>> getMarksStream(
      DocumentReference<Map<String, dynamic>> classRef,
      DocumentReference<Map<String, dynamic>> subjectRef,
      int year,
      int sequence) {
    final collection = FirebaseFirestore.instance.collection("marks");

    final query = collection
        // .where("subject.class", isEqualTo: classRef)
        .where("subject", isEqualTo: subjectRef)
        .where("year", isEqualTo: year)
        .where("sequence", isEqualTo: sequence)
        .snapshots()
        .map<List<Future<MarksModel>>>((snap) => snap.docs
            .map<Future<MarksModel>>(
                (doc) async => await MarksModel.fromJson(doc.data()))
            .toList());

    return query;
  }
}
