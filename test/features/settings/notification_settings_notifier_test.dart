import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plant_care/core/notifications/notification_service.dart';
import 'package:plant_care/data/repositories/repository_providers.dart';
import 'package:plant_care/features/settings/application/notification_settings_notifier.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  late ProviderContainer container;
  late MockNotificationService mockService;
  late Box settingsBox;

  setUpAll(() async {
    Hive.init('.');
  });

  setUp(() async {
    settingsBox = await Hive.openBox('test_settings');
    mockService = MockNotificationService();

    when(() => mockService.requestPermissions()).thenAnswer((_) async => true);
    when(() => mockService.scheduleDailyReminder(
          hour: any(named: 'hour'),
          minute: any(named: 'minute'),
        )).thenAnswer((_) async {});
    when(() => mockService.cancel()).thenAnswer((_) async {});

    container = ProviderContainer(
      overrides: [
        settingsBoxProvider.overrideWithValue(settingsBox),
        notificationServiceProvider.overrideWithValue(mockService),
      ],
    );
  });

  tearDown(() async {
    await settingsBox.clear();
    container.dispose();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('initialer Zustand: Benachrichtigungen deaktiviert', () async {
    final settings = await container.read(notificationSettingsProvider.future);

    expect(settings.isEnabled, false);
    expect(settings.hour, 8);
    expect(settings.minute, 0);
  });

  test('setEnabled(true) aktiviert Benachrichtigungen und plant Reminder',
      () async {
    await container.read(notificationSettingsProvider.future);
    await container
        .read(notificationSettingsProvider.notifier)
        .setEnabled(true);

    final settings = await container.read(notificationSettingsProvider.future);
    expect(settings.isEnabled, true);
    verify(() => mockService.requestPermissions()).called(1);
    verify(() => mockService.scheduleDailyReminder(hour: 8, minute: 0))
        .called(1);
  });

  test('setEnabled(false) deaktiviert Benachrichtigungen und cancelt Reminder',
      () async {
    await settingsBox.put('notifications_enabled', true);
    await container.read(notificationSettingsProvider.future);

    await container
        .read(notificationSettingsProvider.notifier)
        .setEnabled(false);

    final settings = await container.read(notificationSettingsProvider.future);
    expect(settings.isEnabled, false);
    verify(() => mockService.cancel()).called(1);
  });

  test('setEnabled(true) bleibt deaktiviert wenn Permission verweigert',
      () async {
    when(() => mockService.requestPermissions()).thenAnswer((_) async => false);

    await container.read(notificationSettingsProvider.future);
    await container
        .read(notificationSettingsProvider.notifier)
        .setEnabled(true);

    final settings = await container.read(notificationSettingsProvider.future);
    expect(settings.isEnabled, false);
    verifyNever(() => mockService.scheduleDailyReminder(
          hour: any(named: 'hour'),
          minute: any(named: 'minute'),
        ));
  });
}
