import 'package:cloud_firestore/cloud_firestore.dart';

class BaseModel<T> {
  String id;
  DateTime created;
  DateTime updated;
  String collection = "collection";

  BaseModel({required this.id, required this.created, required this.updated});

  CollectionReference<Map<String, dynamic>> get collectionRef =>
      FirebaseFirestore.instance.collection(collection);

  DocumentReference<Map<String, dynamic>> get ref => collectionRef.doc(id);

  factory BaseModel.fromJson(Map<String, dynamic> map) {
    return BaseModel<T>(
      id: map["id"],
      created: DateTime.parse(map['created']),
      updated: DateTime.parse(map['updated']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      'created': created.toIso8601String(),
      'updated': updated.toIso8601String(),
    };
  }

  Future<T> create() async {
    final docRef = collectionRef.doc(id.isEmpty ? null : id);

    if (id.isEmpty) {
      id = docRef.id;
    }

    await docRef.set(toMap());
    return this as T;
  }

  Future<T> read(String modelId) async {
    final docSnapshot = await collectionRef.doc(modelId).get();
    if (docSnapshot.exists) {
      final model = BaseModel<T>.fromJson(docSnapshot.data()!);
      return model as T;
    } else {
      throw Exception('Document does not exist');
    }
  }

  Future<T> update() async {
    await collectionRef.doc(id).update(toMap());
    return this as T;
  }

  Future<void> delete() async {
    await collectionRef.doc(id).delete();
  }

  Future<List<T>> list() async {
    final querySnapshot = await collectionRef.get();
    return querySnapshot.docs.map<T>((doc) {
      final model = BaseModel<T>.fromJson(doc.data()) as T;
      return model;
    }).toList();
  }

  static Stream<List<T>> getListStream<T>(
      {required String collection,
      required T Function(Map<String, dynamic>) objectBuilder,
      Query<Map<String, dynamic>>? queryBuilder}) {
    return FirebaseFirestore.instance
        .collection(collection)
        .snapshots()
        .map<List<T>>((snapshot) =>
            snapshot.docs.map((doc) => objectBuilder(doc.data())).toList());
  }
}
