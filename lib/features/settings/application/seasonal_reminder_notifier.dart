import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../core/notifications/seasonal_reminder_service.dart';

class SeasonalReminderNotifier extends AsyncNotifier<bool> {
  static const _keyEnabled = 'seasonal_reminders_enabled';
  static const _keyLastSeason = 'seasonal_reminders_last_season';

  @override
  Future<bool> build() async {
    final box = ref.read(settingsBoxProvider);
    return box.get(_keyEnabled, defaultValue: false) as bool;
  }

  Future<void> setEnabled(bool enabled) async {
    final box = ref.read(settingsBoxProvider);
    if (enabled) {
      final granted =
          await ref.read(notificationServiceProvider).requestPermissions();
      if (!granted) return;
    }
    await box.put(_keyEnabled, enabled);
    state = AsyncData(enabled);

    if (enabled) await _checkSeason();
  }

  Future<void> checkIfNeeded() async {
    final enabled = state.valueOrNull ?? false;
    if (!enabled) return;
    await _checkSeason();
  }

  Future<void> _checkSeason() async {
    final box = ref.read(settingsBoxProvider);
    final lastSeason = box.get(_keyLastSeason, defaultValue: '') as String;
    final service = SeasonalReminderService();
    await service.checkAndNotify(lastSeason);
    final current = SeasonalReminderService.currentSeason();
    if (current != 'other') {
      await box.put(_keyLastSeason, current);
    }
  }
}

final seasonalReminderProvider =
    AsyncNotifierProvider<SeasonalReminderNotifier, bool>(
  SeasonalReminderNotifier.new,
);
