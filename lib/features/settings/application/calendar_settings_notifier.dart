import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/repository_providers.dart';

class CalendarSettingsNotifier extends AsyncNotifier<bool> {
  static const _key = 'calendar_sync_enabled';

  @override
  Future<bool> build() async {
    final box = ref.read(settingsBoxProvider);
    return box.get(_key, defaultValue: false) as bool;
  }

  Future<void> setEnabled(bool enabled) async {
    final box = ref.read(settingsBoxProvider);
    final service = ref.read(calendarServiceProvider);

    if (enabled) {
      final granted = await service.requestPermissions();
      if (!granted) return;
    }

    await box.put(_key, enabled);
    state = AsyncData(enabled);
  }
}

final calendarSettingsProvider =
    AsyncNotifierProvider<CalendarSettingsNotifier, bool>(
  CalendarSettingsNotifier.new,
);
