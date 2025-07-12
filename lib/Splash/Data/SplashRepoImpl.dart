import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edutrack/Splash/Domain/splashRepo.dart';
import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:edutrack/core/Server/localuserdata.dart';

class SplashRepoImpl extends SplashRepo {
  Future<bool> checkUserLoginBefore() async {
    try {
      UserModel userData = await LocalUserData().getUserData();
      return userData != null && userData.name.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ConnectivityResult>> checkUserIntenetConnectivity() {
    var internet = Connectivity().checkConnectivity();
    return internet;
  }
}
