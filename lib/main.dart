import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // أضف هذا
import 'package:edutrack/core/Models/lecture_model.dart';
import 'package:edutrack/core/Models/section_model.dart';
import 'package:edutrack/core/Server/NotifyServer.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Theming/theming.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'core/Routing/Routes.dart';
import "package:timezone/data/latest.dart" as tz_data;

bool userisLoggedin = false;
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ تهيئة Hive هنا
  await Hive.initFlutter();

  Hive.registerAdapter(LectureModelAdapter());
  Hive.registerAdapter(SectionModelAdapter());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  tz_data.initializeTimeZones();
  await LocalUserData.init();

  // تهيئة الإشعارات أولاً
  await NotifyServer().initNotification();

  userisLoggedin = await checkUserIsLoggedIn();

  // تهيئة connectivity
  Connectivity().checkConnectivity();

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
      child: Directionality(
        textDirection: TextDirection.rtl,
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
      ),
    );
  }
}
