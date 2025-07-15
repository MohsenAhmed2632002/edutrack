import 'package:connectivity_plus/connectivity_plus.dart';

abstract class SplashRepo {
  Future<bool> checkUserLoginBefore();
   Future<List<ConnectivityResult>> checkUserIntenetConnectivity();
}
