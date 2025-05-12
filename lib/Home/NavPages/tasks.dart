import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:edutrack/core/Routing/Routes.dart';
import 'package:edutrack/core/Server/NotifyServer.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
import 'package:edutrack/core/Theming/app_string.dart';
import 'package:edutrack/core/Theming/image.dart';
import 'package:edutrack/core/Widgets/Shared_Widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final NotifyServer _notifyServer = NotifyServer();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  DateTime selectDate = DateTime.now();
  TimeOfDay selectTime = TimeOfDay.now();
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notificationsJson = notifications.map((notif) {
      final notifCopy = Map<String, dynamic>.from(notif);
      notifCopy['date'] = notifCopy['date'].toIso8601String();
      return jsonEncode(notifCopy);
    }).toList();
    await prefs.setStringList('notifications', notificationsJson);
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? notificationsJson =
        prefs.getStringList('notifications');
    if (notificationsJson != null) {
      notifications = notificationsJson.map((notifString) {
        final Map<String, dynamic> notifMap = jsonDecode(notifString);
        notifMap['date'] = DateTime.parse(notifMap['date']);
        return notifMap;
      }).toList();
      notifications.sort((a, b) => a['date'].compareTo(b['date']));
    }
    setState(() {});
    await _rescheduleAllNotifications(); // ✨ جدولة كل الإشعارات
  }

  Future<void> _rescheduleAllNotifications() async {
    for (var notification in notifications) {
      DateTime scheduledDate = notification['date'];
      if (scheduledDate.isAfter(DateTime.now())) {
        await _notifyServer.scheduleNotification(
          scheduledDate: scheduledDate,
          title: notification['title'],
          body: notification['body'],
          payload: 'scheduled_notification',
          context: context,
        );
      }
    }
  }

  Future<void> _scheduleNotification({
    required String title,
    required String body,
  }) async {
    final DateTime scheduleDateTime = DateTime(
      selectDate.year,
      selectDate.month,
      selectDate.day,
      selectTime.hour,
      selectTime.minute,
    );

    if (scheduleDateTime.isBefore(DateTime.now())) {
      _showErrorSnackBar("الوقت المحدد أقل من الوقت الحالي");
      return;
    }

    await _notifyServer.scheduleNotification(
      scheduledDate: scheduleDateTime,
      title: title,
      body: body,
      payload: 'scheduled_notification',
      context: context,
    );

    setState(() {
      notifications.add({
        'id': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'title': title,
        'body': body,
        'date': scheduleDateTime,
      });
    });
    await _saveNotifications();
    _showSuccessSnackBar("تم تحديد اليوم والساعة");
  }

  void _updateDateTime(DateTime date, TimeOfDay time) {
    setState(() {
      selectDate = date;
      selectTime = time;
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectTime,
    );
    if (picked != null) {
      _updateDateTime(selectDate, picked);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      _updateDateTime(picked, selectTime);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: getArabLightTextStyle(
            context: context,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: getArabLightTextStyle(
            context: context,
            color: Colors.white,
            fontSize: 12,
          ),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          EduTrackContainer(),
          LinesImage(),
          Positioned(
            left: 0,
            right: 0,
            height: 600.h,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 600.h,
                    child: ListView.builder(
                      itemCount: notifications.length,
                      itemBuilder: (context, index) {
                        final notification = notifications[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.mywhite,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      notification['title'],
                                      style: getArabBoldItalicTextStyle(
                                        context: context,
                                        color: AppColors.myBlue,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    notification['body'],
                                    style: getArabLightTextStyle(
                                      context: context,
                                      color: AppColors.myBlue,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      ":موعد الإشعار\n${DateFormat('yyyy-MM-dd\nHH:mm').format(notification['date'])}",
                                      style: getArabLightTextStyle(
                                        context: context,
                                        color: AppColors.myBlue,
                                        fontSize: 14,
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () async {
                                        await _notifyServer.cancelNotification(
                                            notification['id']);
                                        setState(() {
                                          notifications.removeAt(index);
                                        });
                                        await _saveNotifications();
                                      },
                                      child: Text(
                                        "فعلت",
                                        style: getArabLightTextStyle(
                                          context: context,
                                          fontSize: 14,
                                          color: AppColors.myBlue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          HomeRowNameAndImage(
            myImage: AppImages.task_2,
            myWidget: FadeInRight(
              child: Text(
                "المهمات",
                style: getArabBoldItalicTextStyle(
                  context: context,
                  color: AppColors.mywhite,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        backgroundColor: AppColors.myBlue,
        foregroundColor: AppColors.mywhite,
        overlayColor: AppColors.mywhite.withOpacity(.3),
        spacing: 10,
        children: [
          SpeedDialChild(
            backgroundColor: AppColors.myBlue,
            child: const Icon(Icons.delete_forever, color: Colors.white),
            label: "حذف الكل",
            labelStyle: getArabLightTextStyle(
              context: context,
              color: AppColors.myBlue,
              fontSize: 12,
            ),
            onTap: () async {
              await _notifyServer.cancelAllNotifications();
              setState(() {
                notifications.clear();
              });
              await _saveNotifications();
            },
          ),
          SpeedDialChild(
            backgroundColor: AppColors.myBlue,
            child: const Icon(Icons.details_outlined, color: Colors.white),
            label: "ثالثا البيانات",
            labelStyle: getArabLightTextStyle(
              context: context,
              color: AppColors.myBlue,
              fontSize: 12,
            ),
            onTap: () {
              showBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                builder: (context) {
                  return Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: 350.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "اختر العنوان و المهمة",
                            style: getArabLightTextStyle(
                              context: context,
                              color: AppColors.myBlue,
                              fontSize: 20,
                            ),
                          ),
                          TextFormField(
                            controller: _bodyController,
                            textAlign: TextAlign.right,
                            validator: (value) => (value == null ||
                                    value.isEmpty ||
                                    value.length <= 5)
                                ? "برجاء ادخال عنوان المهمة بشكل سليم"
                                : null,
                            decoration: const InputDecoration(
                              hintText: "اسم عنوان المهمة",
                              labelText: ".....برجاء ادخال عنوان المهمة",
                            ),
                          ),
                          TextFormField(
                            controller: _titleController,
                            textAlign: TextAlign.right,
                            validator: (value) => (value == null ||
                                    value.isEmpty ||
                                    value.length <= 5)
                                ? "برجاء ادخال المهمة بشكل سليم"
                                : null,
                            decoration: const InputDecoration(
                              hintText: "اسم المهمة",
                              labelText: ".....برجاء ادخال اسم المهمة",
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.myBlue,
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await _scheduleNotification(
                                  title: _bodyController.text,
                                  body: _titleController.text,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: Text(
                              "اضافة مهمة جديدة",
                              style: getArabLightTextStyle(
                                context: context,
                                color: AppColors.mywhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: AppColors.myBlue,
            child: const Icon(Icons.date_range, color: Colors.white),
            label: "ثانيا التاريخ",
            labelStyle: getArabLightTextStyle(
              context: context,
              color: AppColors.myBlue,
              fontSize: 12,
            ),
            onTap: () {
              _selectDate(context);
            },
          ),
          SpeedDialChild(
            backgroundColor: AppColors.myBlue,
            child: const Icon(Icons.timer, color: Colors.white),
            label: "اولا الوقت",
            labelStyle: getArabLightTextStyle(
              context: context,
              color: AppColors.myBlue,
              fontSize: 12,
            ),
            onTap: () {
              _selectTime(context);
            },
          ),
        ],
      ),
    );
  }
}
