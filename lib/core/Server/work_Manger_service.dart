import 'package:workmanager/workmanager.dart';
import 'package:edutrack/core/Server/notification_scheduler.dart';

class WorkManagerService {
  @pragma('vm:entry-point')
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      print("بدء المهمة الخلفية: $task");
      
      if (task == "daily_notification_task") {
        try {
          // تنظيف الإشعارات القديمة
          await NotificationScheduler.cleanupOldNotifications();
          
          // جدولة إشعارات الغد
          await NotificationScheduler.scheduleTomorrowsClasses();
          
          print("✅ تم تحديث إشعارات الغد بنجاح");
          return true;
        } catch (e) {
          print("❌ فشل تحديث إشعارات الغد: $e");
          return false;
        }
      }
      return true;
    });
  }

  Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  Future<void> registerDailyTask() async {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final initialDelay = nextMidnight.difference(now);
    
    await Workmanager().registerOneOffTask(
      "daily_notification_task",
      "daily_notification_task",
      initialDelay: initialDelay,
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }
  
  Future<void> rescheduleDailyTask() async {
    await Workmanager().cancelByTag("daily_notification_task");
    await registerDailyTask();
  }
}