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

int calculateDateDifference(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

extension DateExt on DateTime {
  String visualFormat(
      {bool showDate = true, bool showTime = true, String? separator}) {
    late String datePart;
    final dateString = toString();

    if (calculateDateDifference(this) == -1) {
      datePart = "Yesterday";
    } else if (calculateDateDifference(this) == 0) {
      datePart = "Today";
    } else if (calculateDateDifference(this) == 1) {
      datePart = "Tomorrow";
    } else {
      datePart =
          dateString.split(' ')[0].split('-').reversed.toList().join('-');
    }

    if (!showTime) return datePart;

    final timePart =
        dateString.split(' ')[1].split(":").getRange(0, 2).join(':');

    if (!showDate) return timePart;

    return "$datePart ${separator ?? 'at'} $timePart";
  }
}
