import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/notifications/notification_service.dart';
import '../../../data/repositories/repository_providers.dart';

class NotificationSettings {
  const NotificationSettings({
    required this.isEnabled,
    required this.hour,
    required this.minute,
  });

  final bool isEnabled;
  final int hour;
  final int minute;
}

class NotificationSettingsNotifier
    extends AsyncNotifier<NotificationSettings> {
  static const _keyEnabled = 'notifications_enabled';
  static const _keyHour = 'notifications_hour';
  static const _keyMinute = 'notifications_minute';

  @override
  Future<NotificationSettings> build() async {
    final box = ref.read(settingsBoxProvider);
    return NotificationSettings(
      isEnabled: box.get(_keyEnabled, defaultValue: false) as bool,
      hour: box.get(_keyHour, defaultValue: 8) as int,
      minute: box.get(_keyMinute, defaultValue: 0) as int,
    );
  }

  Future<void> setEnabled(bool enabled) async {
    final box = ref.read(settingsBoxProvider);
    final current = state.valueOrNull ??
        const NotificationSettings(isEnabled: false, hour: 8, minute: 0);
    final service = ref.read(notificationServiceProvider);

    if (enabled) {
      final granted = await service.requestPermissions();
      if (!granted) return;
      await service.scheduleDailyReminder(
        hour: current.hour,
        minute: current.minute,
      );
    } else {
      await service.cancel();
    }

    await box.put(_keyEnabled, enabled);
    state = AsyncData(NotificationSettings(
      isEnabled: enabled,
      hour: current.hour,
      minute: current.minute,
    ));
  }
}

final notificationSettingsProvider =
    AsyncNotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);
