import "package:flutter/material.dart";
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:timezone/timezone.dart" as tz;
import "package:flutter_timezone/flutter_timezone.dart";

class NotifyServer {
  static final NotifyServer _instance = NotifyServer._internal();
  factory NotifyServer() => _instance;
  NotifyServer._internal();

  final FlutterLocalNotificationsPlugin notifyPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInit = false;
  bool get isInit => _isInit;
  List<Map<String, dynamic>> scheduledNotifications = [];

  Future<void> initNotification() async {
    if (_isInit) return;

    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iosSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      await notifyPlugin.initialize(
        const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
        onDidReceiveNotificationResponse: (response) {
          // التعامل مع النقر على الإشعار
        },
      );

      await _createNotificationChannel();
      _isInit = true;
    } catch (e) {
      print('Error initializing notifications: $e');
      _isInit = false;
    }
  }

  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'edutrack_channel',
      'Edu Track Notifications',
      description: 'Channel for educational notifications',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    await notifyPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_isInit) await initNotification();

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'edutrack_channel',
        'Edu Track Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        autoCancel: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await notifyPlugin.show(id, title, body, details, payload: payload);
  }

  Future<void> scheduleNotification({
    required DateTime scheduledDate,
    required String title,
    required String body,
    required String payload,
    required BuildContext context,
  }) async {
    if (!_isInit) await initNotification();

    // تحقق إن التاريخ مش في الماضي
    if (scheduledDate.isBefore(DateTime.now())) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ لا يمكن جدولة إشعار في الماضي'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    // التحقق من التكرار
    bool duplicateExists = scheduledNotifications
        .any((n) => n['date'] == scheduledDate && n['title'] == title);

    if (duplicateExists) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ هذا الإشعار مسجل مسبقاً'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'edutrack_channel',
        'Edu Track Notifications',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        autoCancel: true,
        sound: RawResourceAndroidNotificationSound('notification'),
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await notifyPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      details,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );

    // إضافة الإشعار إلى القائمة
    scheduledNotifications.add({
      'id': id,
      'title': title,
      'body': body,
      'date': scheduledDate,
      'payload': payload,
    });
  }

  List<Map<String, dynamic>> getAllNotifications() {
    return scheduledNotifications;
  }

  Future<void> cancelNotification(int id) async {
    await notifyPlugin.cancel(id);
    scheduledNotifications
        .removeWhere((notification) => notification['id'] == id);
  }

  Future<int> cancelAllNotifications() async {
    final pending = await notifyPlugin.pendingNotificationRequests();
    await notifyPlugin.cancelAll();
    scheduledNotifications.clear();
    return pending.length; // إرجاع عدد الإشعارات المحذوفة
  }Future<void> scheduleWeeklyNotification({
  required int notificationId, // جعل الـ ID مطلوبًا من الخارج
  required DateTime scheduledDate,
  required String title,
  required String body,
  required String payload,
}) async {
  if (!_isInit) await initNotification();

  // التأكد من أن الوقت في المستقبل
  if (scheduledDate.isBefore(DateTime.now())) {
    throw Exception('الوقت المحدد يجب أن يكون في المستقبل');
  }

  const details = NotificationDetails(
    android: AndroidNotificationDetails(
      'edutrack_channel',
      'Edu Track Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      autoCancel: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      colorized: true,
      color: Colors.blue,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      threadIdentifier: 'edu_track_notifications',
    ),
  );

  // تحويل الوقت إلى المنطقة الزمنية المحلية
  final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

  // إضافة الإشعار مع التحقق من التكرار
  await notifyPlugin.zonedSchedule(
    notificationId, // استخدام الـ ID الممرر من الخارج
    title,
    body,
    tzDate,
    details,
    payload: payload,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  );

  // تحديث القائمة مع التحقق من التكرار
  if (!scheduledNotifications.any((n) => n['id'] == notificationId)) {
    scheduledNotifications.add({
      'id': notificationId,
      'title': title,
      'body': body,
      'date': scheduledDate.toIso8601String(),
      'payload': payload,
    });
  }
}}
