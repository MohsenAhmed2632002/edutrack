import 'package:dartz/dartz.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/core/Models/lecture_model.dart';

abstract class LectureRepo {
  Future<Either<Failure, List<LectureModel>>> getLecturesForDay(
    String yearLabel,
    String day, {
    String search = '',
  });
}
