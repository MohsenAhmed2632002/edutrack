import 'package:dartz/dartz.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/core/Models/section_model.dart';
import 'package:edutrack/features/Sction/data/repositories/SctionrepoImpl.dart';

class SectionUsecase {
  final SectionRepo repo;
  SectionUsecase(this.repo);

  Future<Either<Failure, List<SectionModel>>> getSectionsForDay(String yearLabel, String day, {String search = ''}) {
    return repo.getSectionsForDay(yearLabel, day, search: search);
  }
}
