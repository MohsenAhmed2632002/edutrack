// lib/features/lecture/domain/usecases/lecture_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/core/Models/lecture_model.dart';
import 'package:edutrack/features/lecture/domain/repositories/lecture_repo.dart';

class LectureUsecase {
  final LectureRepo repo;
  LectureUsecase(this.repo);

  Future<Either<Failure, List<LectureModel>>> getLecturesForDay(
    String yearLabel,
    String day, {
    String search = '',
  }) {
    return repo.getLecturesForDay(yearLabel, day, search: search);
  }
}
