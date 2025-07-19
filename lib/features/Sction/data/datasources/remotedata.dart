import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack/core/Models/section_model.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:hive/hive.dart';

abstract class SectionRemoteData {
  Future<List<SectionModel>> getSectionsForDay(String yearLabel, String day, {String search = ''});
}

class SectionRemoteDataImpl implements SectionRemoteData {
  @override
  Future<List<SectionModel>> getSectionsForDay(String yearLabel, String day, {String search = ''}) async {
    try {
      final query = FirebaseFirestore.instance
        .collection('سكاشن')
        .doc(yearLabel)
        .collection('الأيام')
        .doc(day)
        .collection('سكاشن');

      final snapshot = search.isNotEmpty
        ? await query
            .where('المادة', isGreaterThanOrEqualTo: search)
            .where('المادة', isLessThanOrEqualTo: '$search\uf8ff')
            .get()
        : await query.get();

      final sections = snapshot.docs.map((doc) => SectionModel.fromMap(doc.data() as Map<String, dynamic>, day)).toList();
      await Hive.box('sectionsBox').put(day, sections.map((e) => e.toMap()).toList());

      return sections;
    } catch (e) {
      throw NetworkFailure('فشل جلب السكاشن: $e');
    }
  }
}
