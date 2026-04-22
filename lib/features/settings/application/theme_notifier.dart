import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/repository_providers.dart';

enum AppThemeMode { system, light, dark }

class ThemeNotifier extends Notifier<AppThemeMode> {
  static const _key = 'app_theme_mode';

  @override
  AppThemeMode build() {
    final box = ref.read(settingsBoxProvider);
    final stored = box.get(_key, defaultValue: 'system') as String;
    return AppThemeMode.values.firstWhere(
      (e) => e.name == stored,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> setMode(AppThemeMode mode) async {
    await ref.read(settingsBoxProvider).put(_key, mode.name);
    state = mode;
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, AppThemeMode>(
  ThemeNotifier.new,
);

extension AppThemeModeX on AppThemeMode {
  Brightness? toBrightness(Brightness platformBrightness) => switch (this) {
        AppThemeMode.light => Brightness.light,
        AppThemeMode.dark => Brightness.dark,
        AppThemeMode.system => null,
      };

  String get label => switch (this) {
        AppThemeMode.system => 'System',
        AppThemeMode.light => 'Hell',
        AppThemeMode.dark => 'Dunkel',
      };
}
