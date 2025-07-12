import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:edutrack/core/Server/NotifyServer.dart';
import 'package:edutrack/core/Theming/Font.dart';
import 'package:edutrack/core/Theming/app_colors.dart';
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

  // ... (Keep your existing _showErrorSnackBar and _showSuccessSnackBar methods) ...

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
                                // ... (Keep your existing notification item UI) ...
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
                                    Text(
                                      ":موعد الإشعار\n${DateFormat('yyyy-MM-dd\nHH:mm').format(notification['date'])}",
                                      style: getArabLightTextStyle(
                                        context: context,
                                        color: AppColors.myBlue,
                                        fontSize: 14,
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
            child: const Icon(Icons.add_task, color: Colors.white),
            label: "إضافة مهمة جديدة",
            labelStyle: getArabLightTextStyle(
              context: context,
              color: AppColors.myBlue,
              fontSize: 12,
            ),
            onTap: () {
              _showTaskCreationSheet(context);
            },
          ),
        ],
      ),
    );
  }

  void _showTaskCreationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          height: 500.h,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "إضافة مهمة جديدة",
                    style: getArabLightTextStyle(
                      context: context,
                      color: AppColors.myBlue,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    controller: _titleController,
                    textAlign: TextAlign.right,
                    decoration: const InputDecoration(
                      labelText: "عنوان المهمة",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء إدخال عنوان المهمة";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15.h),
                  TextFormField(
                    controller: _bodyController,
                    textAlign: TextAlign.right,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "تفاصيل المهمة",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الرجاء إدخال تفاصيل المهمة";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.myBlue,
                          ),
                          onPressed: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectDate,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              setState(() => selectDate = pickedDate);
                            }
                          },
                          child: Text(
                            "اختر التاريخ",
                            style: getArabLightTextStyle(
                              context: context,
                              color: AppColors.mywhite,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.myBlue,
                          ),
                          onPressed: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectTime,
                            );
                            if (pickedTime != null) {
                              setState(() => selectTime = pickedTime);
                            }
                          },
                          child: Text(
                            "اختر الوقت",
                            style: getArabLightTextStyle(
                              context: context,
                              color: AppColors.mywhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "التاريخ المحدد: ${DateFormat('yyyy-MM-dd').format(selectDate)}",
                    style: getArabLightTextStyle(
                      context: context,
                      color: AppColors.myBlue,
                    ),
                  ),
                  Text(
                    "الوقت المحدد: ${selectTime.format(context)}",
                    style: getArabLightTextStyle(
                      context: context,
                      color: AppColors.myBlue,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.myBlue,
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _scheduleNotification(
                          title: _titleController.text,
                          body: _bodyController.text,
                        );
                        Navigator.pop(context);
                        _titleController.clear();
                        _bodyController.clear();
                      }
                    },
                    child: Text(
                      "حفظ المهمة",
                      style: getArabLightTextStyle(
                        context: context,
                        color: AppColors.mywhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
