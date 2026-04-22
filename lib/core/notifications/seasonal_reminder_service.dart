import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SeasonalReminderService {
  static const _winterId = 10;
  static const _summerId = 11;

  final FlutterLocalNotificationsPlugin _plugin;

  SeasonalReminderService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static String _season(DateTime date) {
    final m = date.month;
    if (m == 12 || m <= 2) return 'winter';
    if (m >= 6 && m <= 8) return 'summer';
    return 'other';
  }

  Future<void> checkAndNotify(String lastNotifiedSeason) async {
    final season = _season(DateTime.now());
    if (season == lastNotifiedSeason || season == 'other') return;

    final isWinter = season == 'winter';
    await _plugin.show(
      isWinter ? _winterId : _summerId,
      isWinter ? 'Winter-Tipps für deine Pflanzen ❄️' : 'Sommer-Tipps für deine Pflanzen ☀️',
      isWinter
          ? 'Stelle empfindliche Pflanzen von kalten Fensterbänken weg und gieße seltener.'
          : 'Bei Hitze öfter gießen und direkte Mittagssonne vermeiden.',
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
      ),
    );
  }

  static String currentSeason() => _season(DateTime.now());
}
