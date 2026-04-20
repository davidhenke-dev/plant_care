import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  static const int _dailyReminderId = 0;

  Future<void> initialize() async {
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(const InitializationSettings(iOS: iosSettings));
  }

  Future<bool> requestPermissions() async {
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    return await ios?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        ) ??
        false;
  }

  Future<void> scheduleDailyReminder({int hour = 8, int minute = 0}) async {
    await _plugin.zonedSchedule(
      _dailyReminderId,
      'Zeit zum Gießen! 💧',
      'Deine Pflanzen warten auf dich.',
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancel() async {
    await _plugin.cancel(_dailyReminderId);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
