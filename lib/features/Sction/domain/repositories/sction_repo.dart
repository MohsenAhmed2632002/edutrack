import 'package:dartz/dartz.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/core/Models/section_model.dart';

abstract class SectionRepo {
  Future<Either<Failure, List<SectionModel>>> getSectionsForDay(String yearLabel, String day, {String search = ''});
}
