import 'package:edutrack/core/Models/section_model.dart';
import 'package:hive/hive.dart';

abstract class SectionLocalData {
  List<SectionModel> getSectionsForDay(String day, {String search = ''});
}

class SectionLocalDataImpl implements SectionLocalData {
  @override
  List<SectionModel> getSectionsForDay(String day, {String search = ''}) {
    final raw = Hive.box('sectionsBox').get(day, defaultValue: []) as List;
    final all = raw
        .map((e) => SectionModel.fromMap(Map<String, dynamic>.from(e), day))
        .toList();

    if (search.isNotEmpty) {
      return all
          .where(
              (sec) => sec.subject.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    return all;
  }
}
