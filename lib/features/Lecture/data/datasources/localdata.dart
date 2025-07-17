import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack/core/Models/lecture_model.dart';
import 'package:hive/hive.dart';

abstract class LectureLocalData {
  List<LectureModel> getLecturesForDay(String day, {String search = ''});
}

class LectureLocalDataImpl extends LectureLocalData {
  @override
  List<LectureModel> getLecturesForDay(String day, {String search = ''}) {
    final box = Hive.box('lecturesBox');
    final raw = box.get(day, defaultValue: []) as List;
    var all = raw
        .map((e) => LectureModel.fromMap(Map<String, dynamic>.from(e), day))
        .toList();

    if (search.isNotEmpty) {
      all = all
          .where(
              (lec) => lec.subject.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }
    return all;
  }
}
