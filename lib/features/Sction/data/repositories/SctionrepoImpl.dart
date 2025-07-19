import 'package:dartz/dartz.dart';
import 'package:edutrack/core/Models/section_model.dart';
import 'package:edutrack/core/Erorr.dart';
import 'package:edutrack/core/Server/netWorkInfo.dart';
import 'package:edutrack/features/Sction/data/datasources/localdata.dart';
import 'package:edutrack/features/Sction/data/datasources/remotedata.dart';

abstract class SectionRepo {
  Future<Either<Failure, List<SectionModel>>> getSectionsForDay(String yearLabel, String day, {String search = ''});
}

class SectionRepoImpl implements SectionRepo {
  final SectionRemoteData remote;
  final SectionLocalData local;
  final NetworkInfo net;

  SectionRepoImpl({ required this.remote, required this.local, required this.net });

  @override
  Future<Either<Failure, List<SectionModel>>> getSectionsForDay(String yearLabel, String day, {String search = ''}) async {
    try {
      final online = await net.isConnected;

      if (online) {
        final remoteList = await remote.getSectionsForDay(yearLabel, day, search: search);
        return Right(remoteList);
      }

      final cacheList = local.getSectionsForDay(day, search: search);
      if (cacheList.isEmpty) return Left(CacheFailure('لا توجد سكاشن مخزنة لهذا اليوم'));
      return Right(cacheList);

    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
