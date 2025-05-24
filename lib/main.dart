import 'dart:io' show Platform;
import 'package:device_preview/device_preview.dart';
import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:edutrack/core/Server/NotifyServer.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/theming.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/core/Server/sharedpref.dart';
import 'package:edutrack/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/Routing/Routes.dart';
import "package:timezone/data/latest.dart" as tz_data;

bool userisLoggedin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة Firebase فقط إذا كان ليس Windows ولا Web
  if (!kIsWeb && !(Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  tz_data.initializeTimeZones();

  await LocalUserData.init();
  await NotifyServer().initNotification();
  checkUserIsLoggedIn();

  runApp(const MyApp());
}

Future<bool> checkUserIsLoggedIn() async {
  try {
    UserModel? userData = await LocalUserData().getUserData();
    return userData != null && userData.name.isNotEmpty;
  } catch (e) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        theme: getMyTheme(
          ColorScheme.fromSeed(seedColor: AppColors.myBlue),
          context,
        ),
        themeMode: ThemeMode.light,
        onGenerateRoute: RoutesGenerator.getRoutes,
        initialRoute: Routes.splashRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
