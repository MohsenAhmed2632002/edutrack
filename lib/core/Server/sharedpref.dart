// import 'package:shared_preferences/shared_preferences.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// class SharedPrefHelperKeys {
//   // Singleton pattern لضمان وجود نسخة واحدة فقط
//   static final SharedPrefHelperKeys _instance =
//       SharedPrefHelperKeys._internal();
//   factory SharedPrefHelperKeys() => _instance;
//   SharedPrefHelperKeys._internal();

//   static SharedPreferences? _prefs;

//   // تهيئة SharedPreferences
//   static Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

//   // مفاتيح التخزين
//   static const String _userNameKey = 'user_name';

//   static Future<bool> setUserName(String name) async {
//     await init();
//     return await _prefs!.setString(_userNameKey, name);
//   }

//   static Future<String?> getUserName() async {
//     await init();
//     return _prefs!.getString(_userNameKey);
//   }
//   static Future<bool> removeUserName() async {
//     await init();
//     return await _prefs!.remove(_userNameKey);
//   }

// }
