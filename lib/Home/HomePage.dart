import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:edutrack/Home/NavPages/MaterialRecording.dart';
import 'package:edutrack/Home/NavPages/MyHomePage.dart';
import 'package:edutrack/Home/NavPages/Nots.dart';
import 'package:edutrack/Home/NavPages/aboutas.dart';
import 'package:edutrack/Home/NavPages/tasks.dart';
import 'package:edutrack/core/Server/notification_scheduler.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 4;
@override
void initState() {
  super.initState();
  scheduleAllClassesNotifications(context);
  Timer.periodic(const Duration(hours: 1), (_) {
    if (DateTime.now().hour == 0) { // عند منتصف الليل
      scheduleAllClassesNotifications(context);
    }
  });
}

  List pages = [
    AboutAs(),
    MaterialRecording(),
    Nots(),
    Tasks(),
    MyHomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBarTheme(
        data: BottomNavigationBarThemeData(
          backgroundColor: AppColors.myBlue,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed,
        
        ),
        child: FadeInUp(
          child: Container(
            margin: EdgeInsets.all(
              10,
            ),
            decoration: BoxDecoration(
              color: Colors.transparent,
              boxShadow: [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 8,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                20,
              ),
              child: BottomNavigationBar(
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    label: "من نحن؟",
                    icon: Image.asset(
                      height: currentIndex == 0 ? 40.h : 20.h,
                      // width: 30.w,
                      AppImages.about_as,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "تسجيل المواد",
                    icon: Image.asset(
                      height: currentIndex == 1 ? 40.h : 20.h, // width: 30.w,
                      AppImages.materialrecording,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "ملاحظات",
                    icon: Image.asset(
                      height: currentIndex == 2 ? 40.h : 20.h, // width: 30.w,
                      AppImages.nots,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "المهمات",
                    icon: Image.asset(
                      height: currentIndex == 3 ? 40.h : 20.h,
                      // width: 30.w,
                      AppImages.tasks,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: "الرئيسية",
                    icon: Image.asset(
                      height: currentIndex == 4 ? 40.h : 20.h,
                      // width: 30.w,
                      AppImages.home,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
