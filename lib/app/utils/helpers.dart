import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../models/base_model.dart';

Future<BaseModel<T>> fetchModel<T>(String collection, String modelId) async {
  final docSnapshot = await FirebaseFirestore.instance
      .collection(collection)
      .doc(modelId)
      .get();
  if (docSnapshot.exists) {
    final model = BaseModel<T>.fromJson(docSnapshot.data()!);
    return model;
  } else {
    throw Exception('Document does not exist');
  }
}

extension FExt on XFile {
  String get extension => path.split('.').last;
}
