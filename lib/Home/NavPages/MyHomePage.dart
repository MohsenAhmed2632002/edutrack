import 'dart:convert';

import 'package:edutrack/core/Routing/Routes.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:edutrack/core/Server/notification_scheduler.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHomePage extends StatelessWidget {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      notificationsPlugin; // من main.dart

  static Future<void> cleanupOldNotifications() async {
    final pending = await _notificationsPlugin.pendingNotificationRequests();
    for (var notification in pending) {
      if (notification.payload == null) continue;
      try {
        final payload = jsonDecode(notification.payload!);
        final day = payload['day'];
        final time = payload['time'];
        final classTime = getNextDateTime(day, time);
        if (classTime.isBefore(DateTime.now())) {
          await _notificationsPlugin.cancel(notification.id);
        }
      } catch (e) {
        print('خطأ في تنظيف الإشعارات: $e');
      }
    }
  }

  static Future<void> showTomorrowNotifications(BuildContext context) async {
    // عرض مؤشر تحميل أثناء جلب البيانات
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: AppColors.myBlue,
        ),
      ),
    );

    try {
      final pending = await _notificationsPlugin.pendingNotificationRequests();
      final tomorrowDay = getTomorrowDay();

      final tomorrowNotifications = pending.where((n) {
        if (n.payload == null) return false;
        try {
          final payload = jsonDecode(n.payload!);
          return payload['day'] == tomorrowDay;
        } catch (e) {
          print('خطأ في فك التشفير: ${e.toString()}');
          return false;
        }
      }).toList();

      final lectures = tomorrowNotifications.where((n) {
        final payload = jsonDecode(n.payload!);
        return payload['type'] == 'محاضرة';
      }).toList();

      final sections = tomorrowNotifications.where((n) {
        final payload = jsonDecode(n.payload!);
        return payload['type'] == 'سكشن';
      }).toList();

      // إغلاق مؤشر التحميل
      Navigator.of(context).pop();

      // عرض النتائج في BottomSheet
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (_) => Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'إشعارات اليوم ($tomorrowDay)',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // المحاضرات
                  if (lectures.isNotEmpty) ...[
                    const Text('📘 المحاضرات:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...lectures.map((n) {
                      final payload = jsonDecode(n.payload!);
                      return ListTile(
                        leading: const Icon(Icons.school, color: Colors.green),
                        title: Text(payload['subject'] ?? 'بدون عنوان'),
                        subtitle: Text(
                            'الوقت: ${payload['time']} \nالمكان: ${payload['location']} \nالدكتور: ${payload['doctor']}'),
                      );
                    }),
                    const Divider(),
                  ],

                  // السكاشن
                  if (sections.isNotEmpty) ...[
                    const Text('📗 السكاشن:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ...sections.map((n) {
                      final payload = jsonDecode(n.payload!);
                      return ListTile(
                        leading: const Icon(Icons.group, color: Colors.orange),
                        title: Text(payload['subject'] ?? 'بدون عنوان'),
                        subtitle: Text(
                            'الوقت: ${payload['time']} \nالمكان: ${payload['location']} \nالدكتور: ${payload['doctor']}'),
                      );
                    }),
                  ],

                  if (lectures.isEmpty && sections.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('لا توجد إشعارات مجدولة'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      // إغلاق مؤشر التحميل في حالة الخطأ
      Navigator.of(context).pop();

      // عرض رسالة خطأ
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('حدث خطأ'),
          content: Text('تعذر جلب الإشعارات: ${e.toString()}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً'),
            ),
          ],
        ),
      );
    }
  }

  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ContanierName(),
          Text(
            "...مرحبا ",
            style: getArabLightTextStyle(
              fontSize: 14.sp,
              context: context,
              color: AppColors.myBrightTurquoise,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, Routes.ProfileScreen),
            child: const PersonCircleAvatar(),
          ),
        ],
        leading: GestureDetector(
          onTap: () => showTomorrowNotifications(context),
          child: Icon(
            Icons.notifications_active,
            color: AppColors.myBlue,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const EDUContainerBlue(),
                const RowBooks3(),
                VerticalContainer(),
                const RowPlus(),
                HorizontalContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PersonCircleAvatar extends StatelessWidget {
  const PersonCircleAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 15.sp,
      backgroundColor: AppColors.myBlue,
      child: Icon(
        Icons.person,
        color: AppColors.mywhite,
      ),
    );
  }
}

class ContanierName extends StatelessWidget {
  ContanierName({
    super.key,
  });
  final LocalUserData localUserData = LocalUserData();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: localUserData.getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "جاري التحميل...",
            style: getArabLightTextStyle(
              fontSize: 14.sp,
              context: context,
              color: AppColors.mywhite,
            ),
            overflow: TextOverflow.ellipsis, // إضافة هذه السطر
          );
        }
        return Text(
          snapshot.data!.name,
          style: getArabLightTextStyle(
            fontSize: 14.sp,
            context: context,
            color: AppColors.myBlue,
          ),
          overflow: TextOverflow.ellipsis, // إضافة هذه السطر
        );
      },
    );
  }
}

class EDUContainerBlue extends StatelessWidget {
  const EDUContainerBlue({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 25,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 150.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: AppColors.myBlue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Positioned(
            bottom: -10,
            left: -20,
            height: 200.h,
            width: 200.w,
            child: Image.asset(
              // height: MediaQuery.of(context).size.height / 2.5,
              // width: MediaQuery.of(context).size.width,
              AppImages.books,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return AnimatedOpacity(
                  child: child,
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(seconds: 1),
                  curve: Curves.easeOut,
                );
              },
            ),
          ),
          Positioned(
            right: 10,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "استمتع بتجربة  ",
                  style: getArabLightTextStyle(
                    context: context,
                    color: AppColors.mywhite,
                  ),
                ),
                Text(
                  "تعليمية ممتعة مع",
                  style: getArabBoldItalicTextStyle(
                    context: context,
                    color: AppColors.mywhite,
                  ),
                ),
                Text(
                  AppStrings.appName,
                  style: getArabRegulerTextStyle(
                    context: context,
                    color: AppColors.myBrightTurquoise,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RowBooks3 extends StatelessWidget {
  const RowBooks3({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "الاقسام",
            style: getArabBoldItalicTextStyle(
              context: context,
              color: AppColors.myBlue,
              fontSize: 14,
            ),
          ),
          Image.asset(
            AppImages.books3,
            height: 20.h,
            width: 20.w,
          ),
        ],
      ),
    );
  }
}

class VerticalContainer extends StatelessWidget {
  VerticalContainer({
    super.key,
  });
  final LocalUserData _localUserData = LocalUserData();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.decisionsRoute,
                  );
                },
                child: SimpleMore(
                  myImage: AppImages.twobooks,
                  text: "المقرارات الخاصة بك",
                  backGroundColor: AppColors.myBlue,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.InformationAboutRoute,
                  );
                },
                child: SimpleMore(
                  myImage: AppImages.information,
                  text: "معلومات عن قسم\nتكنولوجيا التعليم",
                  backGroundColor: AppColors.myBrightTurquoise,
                ),
              ),
            ],
          ),
          FutureBuilder(
              future: _localUserData.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.data!.study_Group == "الفرقة الثالثة" ||
                    snapshot.data!.study_Group == "الفرقة الرابعة")
                  // نمسح الاختيار السابق إذا تغيرت الفرقة
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.GraduationProjectRoute,
                          );
                        },
                        child: SimpleMore(
                          myImage: AppImages.grad,
                          text: "مشروع التخرج",
                          backGroundColor: AppColors.myBlue,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Routes.FieldeducationRoute,
                          );
                        },
                        child: SimpleMore(
                          myImage: AppImages.light_book,
                          text: "التربية الميدانية",
                          backGroundColor: AppColors.myBrightTurquoise,
                        ),
                      ),
                    ],
                  );
                return SizedBox();
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.SectionSchedulePage,
                  );
                },
                child: SimpleMore(
                  myImage: AppImages.time2,
                  text: "مواعيد السكاشن",
                  backGroundColor: AppColors.myBlue,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.LectureSchedulePage,
                  );
                },
                child: SimpleMore(
                  myImage: AppImages.time,
                  text: "مواعيد المحاضرات",
                  backGroundColor: AppColors.myBrightTurquoise,
                ),
              ),
              // ),
            ],
          ),
        ],
      ),
      //
    );
  }
}

class RowPlus extends StatelessWidget {
  const RowPlus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "المزيد",
            style: getArabBoldItalicTextStyle(
              context: context,
              color: AppColors.myBlue,
              fontSize: 14,
            ),
          ),
          Image.asset(
            AppImages.plus,
            height: 20.h,
            width: 20.w,
          ),
        ],
      ),
    );
  }
}

class HorizontalContainer extends StatelessWidget {
  HorizontalContainer({
    super.key,
  });
  final LocalUserData _localUserData = LocalUserData();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        reverse: true,
        clipBehavior: Clip.none,
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.WebsiteRoute,
                );
              },
              child: Hero(
                tag: "Website",
                child: SimpleMore(
                  myImage: AppImages.internet,
                  text: "الموقع الرسمي \nلجامعة عين شمس",
                  backGroundColor: AppColors.myBrightTurquoise,
                ),
              ),
            ),
            FutureBuilder(
                future: _localUserData.getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.data!.study_Group == "الفرقة الاولي")
                    // نمسح الاختيار السابق إذا تغيرت الفرقة
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          Routes.RegulationsRoute,
                        );
                      },
                      child: SimpleMore(
                        myImage: AppImages.regulations,
                        text: "اللائحة ",
                        backGroundColor: AppColors.myBlue,
                      ),
                    );

                  return SizedBox();
                }),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.HowToGetRoute,
                );
              },
              child: Hero(
                tag: "How",
                child: SimpleMore(
                  myImage: AppImages.map,
                  text: "كيف تصل الي ؟",
                  backGroundColor: AppColors.myBrightTurquoise,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.AskedQuestionsRoute,
                );
              },
              child: Hero(
                tag: "Asked",
                child: SimpleMore(
                  myImage: AppImages.frequently,
                  text: "أسئلة شائعة",
                  backGroundColor: AppColors.myBrightTurquoise,
                ),
              ),
            ),
          ],
        ),
      ),
      //
    );
  }
}

// class TheTextFormField extends StatelessWidget {
//   const TheTextFormField({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: TextFormField(
//         textAlign: TextAlign.right,
//         // validator: (value) {},
//         decoration: InputDecoration(
//           prefixIcon: Icon(
//             Icons.search,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(
//                 50,
//               ),
//             ),
//           ),
//           label: Text(
//             "بحث ",
//           ),
//           hintText: "بحث",
//         ),
//       ),
//     );
//   }
// }
