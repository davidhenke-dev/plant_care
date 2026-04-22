import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/ai_chat_settings_notifier.dart';
import '../application/calendar_settings_notifier.dart';
import '../application/language_notifier.dart';
import '../application/notification_settings_notifier.dart';
import '../application/seasonal_reminder_notifier.dart';
import '../application/theme_notifier.dart';
import '../../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final notifAsync = ref.watch(notificationSettingsProvider);
    final calendarEnabled =
        ref.watch(calendarSettingsProvider).valueOrNull ?? false;
    final seasonalEnabled =
        ref.watch(seasonalReminderProvider).valueOrNull ?? false;
    final aiChatEnabled =
        ref.watch(aiChatSettingsProvider).valueOrNull ?? true;
    final themeMode = ref.watch(themeProvider);
    final currentLocale = ref.watch(languageProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l.settingsTitle),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // ── Appearance ────────────────────────────────────────────────────
            CupertinoListSection.insetGrouped(
              header: Text(l.settingsAppearance.toUpperCase()),
              children: [
                CupertinoListTile(
                  leading: _iconBox(
                    CupertinoIcons.moon_fill,
                    CupertinoColors.systemIndigo,
                  ),
                  title: Text(l.settingsDesign),
                  trailing: CupertinoSlidingSegmentedControl<AppThemeMode>(
                    groupValue: themeMode,
                    children: {
                      AppThemeMode.system: _segLabel(l.settingsThemeSystem),
                      AppThemeMode.light: _segLabel(l.settingsThemeLight),
                      AppThemeMode.dark: _segLabel(l.settingsThemeDark),
                    },
                    onValueChanged: (v) {
                      if (v != null) ref.read(themeProvider.notifier).setMode(v);
                    },
                  ),
                ),
              ],
            ),

            // ── Language ──────────────────────────────────────────────────────
            CupertinoListSection.insetGrouped(
              header: Text(l.settingsLanguage.toUpperCase()),
              children: [
                for (final locale in supportedLocales)
                  CupertinoListTile(
                    leading: Text(
                      locale.languageCode == 'de'
                          ? '🇩🇪'
                          : locale.languageCode == 'en'
                              ? '🇬🇧'
                              : '🇫🇷',
                      style: const TextStyle(fontSize: 22),
                    ),
                    title: Text(locale.label),
                    trailing: currentLocale.languageCode == locale.languageCode
                        ? const Icon(
                            CupertinoIcons.checkmark_alt,
                            color: Color(0xFF4CAF50),
                            size: 20,
                          )
                        : null,
                    onTap: () =>
                        ref.read(languageProvider.notifier).setLocale(locale),
                  ),
              ],
            ),

            // ── Reminders ─────────────────────────────────────────────────────
            CupertinoListSection.insetGrouped(
              header: Text(l.settingsReminders.toUpperCase()),
              children: [
                CupertinoListTile(
                  leading: _iconBox(
                    CupertinoIcons.bell_fill,
                    const Color(0xFF4CAF50),
                  ),
                  title: Text(l.settingsPushNotifications),
                  subtitle: Text(l.settingsPushSubtitle),
                  trailing: notifAsync.maybeWhen(
                    data: (s) => CupertinoSwitch(
                      value: s.isEnabled,
                      activeTrackColor: const Color(0xFF4CAF50),
                      onChanged: (v) => ref
                          .read(notificationSettingsProvider.notifier)
                          .setEnabled(v),
                    ),
                    orElse: () => const CupertinoActivityIndicator(),
                  ),
                ),
                CupertinoListTile(
                  leading: _iconBox(
                    CupertinoIcons.sun_max_fill,
                    CupertinoColors.systemOrange,
                  ),
                  title: Text(l.settingsSeasonalReminders),
                  subtitle: Text(l.settingsSeasonalSubtitle),
                  trailing: CupertinoSwitch(
                    value: seasonalEnabled,
                    activeTrackColor: const Color(0xFF4CAF50),
                    onChanged: (v) => ref
                        .read(seasonalReminderProvider.notifier)
                        .setEnabled(v),
                  ),
                ),
                CupertinoListTile(
                  leading: _iconBox(
                    CupertinoIcons.calendar,
                    const Color(0xFF4CAF50),
                  ),
                  title: Text(l.settingsCalendar),
                  subtitle: Text(l.settingsCalendarSubtitle),
                  trailing: CupertinoSwitch(
                    value: calendarEnabled,
                    activeTrackColor: const Color(0xFF4CAF50),
                    onChanged: (v) => ref
                        .read(calendarSettingsProvider.notifier)
                        .setEnabled(v),
                  ),
                ),
              ],
            ),

            // ── Features ──────────────────────────────────────────────────────
            CupertinoListSection.insetGrouped(
              header: Text(l.settingsAiChat.toUpperCase()),
              children: [
                CupertinoListTile(
                  leading: _iconBox(
                    CupertinoIcons.chat_bubble_2_fill,
                    CupertinoColors.systemPurple,
                  ),
                  title: Text(l.settingsAiChat),
                  subtitle: Text(l.settingsAiChatSubtitle),
                  trailing: CupertinoSwitch(
                    value: aiChatEnabled,
                    activeTrackColor: CupertinoColors.systemPurple,
                    onChanged: (v) => ref
                        .read(aiChatSettingsProvider.notifier)
                        .setEnabled(v),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _segLabel(String text) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Text(text, style: const TextStyle(fontSize: 13)),
      );

  Widget _iconBox(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}
