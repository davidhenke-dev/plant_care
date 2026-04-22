import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/repository_providers.dart';

class LanguageNotifier extends Notifier<Locale> {
  static const _key = 'app_language';

  @override
  Locale build() {
    final stored = ref.read(settingsBoxProvider).get(_key, defaultValue: 'de') as String;
    return Locale(stored);
  }

  Future<void> setLocale(Locale locale) async {
    await ref.read(settingsBoxProvider).put(_key, locale.languageCode);
    state = locale;
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(
  LanguageNotifier.new,
);

const supportedLocales = [
  Locale('de'),
  Locale('en'),
  Locale('fr'),
];

extension LocaleLabel on Locale {
  String get label => switch (languageCode) {
        'de' => '🇩🇪 Deutsch',
        'en' => '🇬🇧 English',
        'fr' => '🇫🇷 Français',
        _ => languageCode,
      };
}
