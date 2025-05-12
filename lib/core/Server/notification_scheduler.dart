import 'dart:convert';

import 'package:edutrack/Home/NavPages/MyHomePage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutrack/core/Server/NotifyServer.dart';
import 'package:edutrack/core/Server/localuserdata.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
Future<void> scheduleAllClassesNotifications(BuildContext context) async {
  await NotifyServer().initNotification();
  await MyHomePage.cleanupOldNotifications(); // <-- التعديل هنا
//s 
  // 1. حذف جميع الإشعارات الحالية
    final int deletedCount = await NotifyServer().cancelAllNotifications();
    print('🗑️ تم حذف $deletedCount إشعار قديم');
 final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final pendingNotifications =
      await flutterLocalNotificationsPlugin.pendingNotificationRequests();
  
  print('🔵 عدد الإشعارات المجدولة حاليًا: ${pendingNotifications.length}');

  Future<void> scheduleClassesForType({
    required bool isSection,
  }) async {
    try {
      final localUserData = LocalUserData();
      final user = await localUserData.getUserData();

      String yearLabel = user.study_Group.trim();
      if (yearLabel == 'الفرقة الثالثة' || yearLabel == 'الفرقة الرابعة') {
        yearLabel = '$yearLabel - ${user.specialization.trim()}';
      }

      final collectionName = isSection ? 'سكاشن' : 'محاضرات';
      final classType = isSection ? 'سكشن' : 'محاضرة';
      final tomorrowDay = getTomorrowDay();

      final classesSnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(yearLabel)
          .collection('الأيام')
          .doc(tomorrowDay)
          .collection(collectionName)
          .get();

      if (classesSnapshot.docs.isEmpty) return;

      for (var doc in classesSnapshot.docs) {
        final data = doc.data();
        final subject = data['المادة'] ?? 'بدون عنوان';
        final startTime = data['من'] ?? '00:00';
        final endTime = data['إلى'] ?? '00:00';
        final doctor = data['الدكتور'] ?? 'غير معروف';
        final location = data['المكان'] ?? 'غير معروف';

        if (subject.isEmpty || startTime.isEmpty) continue;

        final classTime = getNextDateTime(tomorrowDay, startTime);
        final notificationTime = classTime.subtract(const Duration(minutes: 10));

        final uniqueId = _generateNotificationId(subject, startTime, tomorrowDay);
        final isAlreadyScheduled = pendingNotifications.any((n) => n.id == uniqueId);

        if (!isAlreadyScheduled && notificationTime.isAfter(DateTime.now())) {
          await NotifyServer().scheduleWeeklyNotification(
            notificationId: uniqueId,
            scheduledDate: notificationTime,
            title: 'تذكير: $classType $subject',
            body: 'المحاضر: $doctor\nالوقت: $startTime - $endTime\nالمكان: $location',
            payload: jsonEncode({
              'day': tomorrowDay,
              'subject': subject,
              'time': startTime,
              'doctor': doctor,
              'location': location,
              'type': classType,
            }),
          );
        }
      }
    } catch (e) {
      print('❌ خطأ في الجدولة: ${e.toString()}');
    }
  }

  await scheduleClassesForType(isSection: false);
  await scheduleClassesForType(isSection: true);
}
// توليد معرّف فريد بناءً على البيانات
int _generateNotificationId(String subject, String time, String day) {
  return '${subject}_${time}_${day}'.hashCode;
}
DateTime getNextDateTime(String dayName, String timeString) {
  final days = {
    'الأحد': DateTime.sunday,
    'الإثنين': DateTime.monday,
    'الثلاثاء': DateTime.tuesday,
    'الأربعاء': DateTime.wednesday,
    'الخميس': DateTime.thursday,
    'الجمعة': DateTime.friday,
    'السبت': DateTime.saturday,
  };

  final timeParts = timeString.split(':');
  final hour = int.parse(timeParts[0]);
  final minute = int.parse(timeParts[1]);

  DateTime scheduledDate = DateTime.now();
  int daysToAdd = (days[dayName]! - scheduledDate.weekday + 7) % 7;
  daysToAdd = daysToAdd == 0 ? 7 : daysToAdd;

  scheduledDate = scheduledDate.add(Duration(days: daysToAdd));
  scheduledDate = DateTime(scheduledDate.year, scheduledDate.month, scheduledDate.day, hour, minute);

  // إضافة أسبوع إذا كان الوقت في الماضي
  if (scheduledDate.isBefore(DateTime.now())) {
    scheduledDate = scheduledDate.add(const Duration(days: 7));
  }

  return scheduledDate;
}
String getTomorrowDay() {
  final days = {
    1: 'الإثنين',
    2: 'الثلاثاء',
    3: 'الأربعاء',
    4: 'الخميس',
    5: 'الجمعة',
    6: 'السبت',
    7: 'الأحد',
  };
  return days[DateTime.now()
          .add(const Duration(
            days: 0,
          ))
          .weekday] ??
      'الأحد';
}
