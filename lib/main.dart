import 'package:edutrack/core/Models/UserdataModel.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // أضف هذا
import 'package:edutrack/core/Models/lecture_model.dart';
import 'package:edutrack/core/Models/section_model.dart';
import 'package:edutrack/core/Server/NotifyServer.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Server/work_Manger_service.dart';
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

  tz_data.initializeTimeZones();

  await LocalUserData.initSharedPreferences();
  await NotifyServer().initNotification();
  
  // تهيئة Workmanager
  final workManager = WorkManagerService();
  await workManager.initialize();
  await workManager.registerDailyTask();
  await Hive.initFlutter();
  await Hive.openBox('lecturesBox');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   Hive.registerAdapter(LectureModelAdapter());
   Hive.registerAdapter(SectionModelAdapter());

  runApp(const MyApp());
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
            ColorScheme.fromSeed(
              seedColor: AppColors.myBlue,
            ),
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
