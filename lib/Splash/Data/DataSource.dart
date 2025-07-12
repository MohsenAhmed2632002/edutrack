import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
// import 'package:edutrack/core/repo/fire_base_auth.dart';

abstract class SplashDataSource {
  Future<bool> checkUserLoginBefore();
  Future<List<ConnectivityResult>> checkUserIntenetConnectivity();
}

class SplashDataSourceImpl extends SplashDataSource {
  // final FireBaseAuth fireBaseAuth;

  // SplashDataSourceImpl(this.fireBaseAuth);
  @override
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
