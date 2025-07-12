import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edutrack/Splash/Domain/splashRepo.dart';

class SplashUsecase {
  final SplashRepo MysplashRepo;

  SplashUsecase({required this.MysplashRepo});
  Future<bool> checkUserLoginBefore() {
    return MysplashRepo.checkUserLoginBefore();
  }

  Future<List<ConnectivityResult>> checkUserIntenetConnectivity() {
    return MysplashRepo.checkUserIntenetConnectivity();
  }
}
