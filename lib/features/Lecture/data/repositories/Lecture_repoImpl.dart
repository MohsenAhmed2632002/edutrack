// lib/features/lecture/data/repositories/lecture_repo_impl.dart
import 'package:dartz/dartz.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/core/Models/lecture_model.dart';
import 'package:edutrack/core/Server/netWorkInfo.dart';
import 'package:edutrack/features/Lecture/data/datasources/localdata.dart';
import 'package:edutrack/features/Lecture/data/datasources/remotedata.dart';
import 'package:edutrack/features/lecture/domain/repositories/lecture_repo.dart';
class LectureRepoImpl implements LectureRepo {
  final LectureRemoteData remoteData;
  final LectureLocalData localData;
  final NetworkInfo networkInfo;

  LectureRepoImpl({
    required this.remoteData,
    required this.localData,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<LectureModel>>> getLecturesForDay(
    String yearLabel,
    String day, {
    String search = '',
  }) async {
    try {
      final isOnline = await networkInfo.isConnected;
      List<LectureModel> lectures = [];

      if (isOnline) {
        try {
          lectures = await remoteData.getLecturesForDay(yearLabel, day, search: search);
          return Right(lectures);
        } catch (e) {
          // Fallback to cache if online fetch fails
          lectures = localData.getLecturesForDay(day, search: search);
          if (lectures.isEmpty) throw e;
          return Right(lectures);
        }
      } else {
        lectures = localData.getLecturesForDay(day, search: search);
        if (lectures.isEmpty) {
          return Left(CacheFailure('لا يوجد محاضرات مخزنة لهذا اليوم'));
        }
        return Right(lectures);
      }
    } on NetworkFailure catch (e) {
      return Left(e);
    } on CacheFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}