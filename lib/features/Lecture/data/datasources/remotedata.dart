// lib/features/lecture/data/datasources/lecture_remote_data.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/core/Models/lecture_model.dart';
import 'package:hive/hive.dart';

abstract class LectureRemoteData {
  Future<List<LectureModel>> getLecturesForDay(
    String yearLabel,
    String day, {
    String search = '',
  });
}
class LectureRemoteDataImpl implements LectureRemoteData {
  @override
  Future<List<LectureModel>> getLecturesForDay(
    String yearLabel, 
    String day, {
    String search = '',
  }) async {
    try {
      final query = FirebaseFirestore.instance
          .collection('محاضرات')
          .doc(yearLabel)
          .collection('الأيام')
          .doc(day)
          .collection('محاضرات');

      final QuerySnapshot snapshot;
      if (search.isNotEmpty) {
        snapshot = await query
            .where('المادة', isGreaterThanOrEqualTo: search)
            .where('المادة', isLessThanOrEqualTo: '$search\uf8ff')
            .get();
      } else {
        snapshot = await query.get();
      }

      final lectures = snapshot.docs
          .map((doc) => LectureModel.fromMap(doc.data() as Map<String, dynamic>, day))
          .toList();

      await Hive.box('lecturesBox').put(day, lectures.map((e) => e.toMap()).toList());
      
      return lectures;
    } catch (e) {
      throw NetworkFailure('Failed to fetch lectures: $e');
    }
  }
}