import 'dart:convert';

import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalUserData {

  static SharedPreferences? prefs;
  static const String userDataKey = 'UserData';
  // تهيئة SharedPreferences
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<UserModel> getUserData() async {
    dynamic value = prefs!.get(userDataKey);
    return UserModel.fromJson(jsonDecode(value));
  }

  setUserData(UserModel userModel) async {
    await prefs!.setString(userDataKey, jsonEncode(userModel.toJson()));
    print("setUserData: $userModel");
  }

  deleteUser() async {
    await prefs!.clear();
  }
}
