import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plant_care/core/notifications/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MockFlutterLocalNotificationsPlugin extends Mock
    implements FlutterLocalNotificationsPlugin {}

void main() {
  late MockFlutterLocalNotificationsPlugin mockPlugin;
  late NotificationService service;

  setUpAll(() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.UTC);
    registerFallbackValue(const InitializationSettings());
    registerFallbackValue(tz.TZDateTime.now(tz.UTC));
    registerFallbackValue(const NotificationDetails());
    registerFallbackValue(AndroidScheduleMode.exactAllowWhileIdle);
    registerFallbackValue(
        UILocalNotificationDateInterpretation.absoluteTime);
    registerFallbackValue(DateTimeComponents.time);
  });

  setUp(() {
    mockPlugin = MockFlutterLocalNotificationsPlugin();
    service = NotificationService(plugin: mockPlugin);
  });

  test('initialize ruft plugin.initialize auf', () async {
    when(() => mockPlugin.initialize(any())).thenAnswer((_) async => true);

    await service.initialize();

    verify(() => mockPlugin.initialize(any())).called(1);
  });

  test('scheduleDailyReminder ruft zonedSchedule mit korrekter ID auf',
      () async {
    when(() => mockPlugin.zonedSchedule(
          any(),
          any(),
          any(),
          any(),
          any(),
          androidScheduleMode: any(named: 'androidScheduleMode'),
          uiLocalNotificationDateInterpretation:
              any(named: 'uiLocalNotificationDateInterpretation'),
          matchDateTimeComponents: any(named: 'matchDateTimeComponents'),
        )).thenAnswer((_) async {});

    await service.scheduleDailyReminder(hour: 8, minute: 0);

    verify(() => mockPlugin.zonedSchedule(
          0,
          'Zeit zum Gießen! 💧',
          'Deine Pflanzen warten auf dich.',
          any(),
          any(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        )).called(1);
  });

  test('cancel ruft plugin.cancel mit ID 0 auf', () async {
    when(() => mockPlugin.cancel(0)).thenAnswer((_) async {});

    await service.cancel();

    verify(() => mockPlugin.cancel(0)).called(1);
  });
}
