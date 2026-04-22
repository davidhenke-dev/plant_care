import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/repository_providers.dart';

class AiChatSettingsNotifier extends AsyncNotifier<bool> {
  static const _key = 'ai_chat_enabled';

  @override
  Future<bool> build() async {
    final box = ref.read(settingsBoxProvider);
    return box.get(_key, defaultValue: true) as bool;
  }

  Future<void> setEnabled(bool enabled) async {
    final box = ref.read(settingsBoxProvider);
    await box.put(_key, enabled);
    state = AsyncData(enabled);
  }
}

final aiChatSettingsProvider =
    AsyncNotifierProvider<AiChatSettingsNotifier, bool>(
  AiChatSettingsNotifier.new,
);
