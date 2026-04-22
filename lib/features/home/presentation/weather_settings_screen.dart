import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/weather/position_service.dart';
import '../../../l10n/app_localizations.dart';
import '../../settings/application/weather_location_notifier.dart';
import '../application/weather_notifier.dart';
import 'map_picker_screen.dart';

class WeatherSettingsScreen extends ConsumerWidget {
  const WeatherSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final settings = ref.watch(weatherLocationNotifierProvider);
    final notifier = ref.read(weatherLocationNotifierProvider.notifier);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l.weatherSettingsTitle),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          children: [
            // ── Mode toggle ─────────────────────────────────────────────────
            CupertinoSlidingSegmentedControl<bool>(
              groupValue: settings.isStatic,
              children: {
                false: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(l.weatherSettingsDynamic,
                      style: const TextStyle(fontSize: 13)),
                ),
                true: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(l.weatherSettingsStatic,
                      style: const TextStyle(fontSize: 13)),
                ),
              },
              onValueChanged: (v) async {
                if (v == false) {
                  await notifier.setDynamic();
                  ref.invalidate(weatherProvider);
                } else {
                  // Switch to static: open map picker immediately
                  await _openMapPicker(context, ref, settings);
                }
              },
            ),

            const SizedBox(height: 20),

            // ── Info card ───────────────────────────────────────────────────
            _infoCard(
              context: context,
              icon: settings.isStatic
                  ? CupertinoIcons.map_pin_ellipse
                  : CupertinoIcons.location,
              iconColor: const Color(0xFF4CAF50),
              title: settings.isStatic
                  ? l.weatherSettingsStatic
                  : l.weatherSettingsDynamic,
              subtitle: settings.isStatic
                  ? l.weatherSettingsStaticSubtitle
                  : l.weatherSettingsDynamicSubtitle,
            ),

            // ── Static location detail ───────────────────────────────────────
            if (settings.isStatic) ...[
              const SizedBox(height: 16),
              _locationCard(context, settings, l),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  color: kCardBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(14),
                  onPressed: () => _openMapPicker(context, ref, settings),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.map,
                          size: 18, color: Color(0xFF4CAF50)),
                      const SizedBox(width: 8),
                      Text(
                        l.weatherSettingsPickOnMap,
                        style: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _openMapPicker(
    BuildContext context,
    WidgetRef ref,
    WeatherLocationSettings settings,
  ) async {
    // Pre-fill with current static coords, or GPS, or fallback
    double? initialLat = settings.lat;
    double? initialLon = settings.lon;

    if (initialLat == null) {
      try {
        final pos = await PositionService().getCurrentPosition();
        initialLat = pos.latitude;
        initialLon = pos.longitude;
      } catch (_) {}
    }

    if (!context.mounted) return;

    final result = await Navigator.of(context).push<PickedLocation>(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (_) => MapPickerScreen(
          initialLat: initialLat,
          initialLon: initialLon,
        ),
      ),
    );

    if (result != null) {
      await ref.read(weatherLocationNotifierProvider.notifier).setStatic(
            result.lat,
            result.lon,
            result.cityName,
          );
      ref.invalidate(weatherProvider);
    }
  }
}

Widget _infoCard({
  required BuildContext context,
  required IconData icon,
  required Color iconColor,
  required String title,
  required String subtitle,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: kCardBackground.resolveFrom(context),
      borderRadius: BorderRadius.circular(14),
      border:
          Border.all(color: CupertinoColors.systemGrey4.resolveFrom(context)),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                    fontSize: 13, color: CupertinoColors.systemGrey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _locationCard(
  BuildContext context,
  WeatherLocationSettings settings,
  AppLocalizations l,
) {
  final hasLocation = settings.lat != null;
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: hasLocation
          ? const Color(0xFF4CAF50).withValues(alpha: 0.08)
          : kCardBackground.resolveFrom(context),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: hasLocation
            ? const Color(0xFF4CAF50).withValues(alpha: 0.3)
            : CupertinoColors.systemGrey4.resolveFrom(context),
      ),
    ),
    child: Row(
      children: [
        Icon(
          hasLocation ? CupertinoIcons.map_pin_ellipse : CupertinoIcons.map_pin,
          size: 20,
          color: hasLocation
              ? const Color(0xFF4CAF50)
              : CupertinoColors.systemGrey,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hasLocation
                    ? (settings.cityName?.isNotEmpty == true
                        ? settings.cityName!
                        : '${settings.lat!.toStringAsFixed(4)}, ${settings.lon!.toStringAsFixed(4)}')
                    : l.weatherSettingsNoLocationSet,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: hasLocation
                      ? const Color(0xFF4CAF50)
                      : CupertinoColors.systemGrey,
                ),
              ),
              if (hasLocation) ...[
                const SizedBox(height: 3),
                Text(
                  '${settings.lat!.toStringAsFixed(5)}, ${settings.lon!.toStringAsFixed(5)}',
                  style: const TextStyle(
                      fontSize: 12, color: CupertinoColors.systemGrey),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}
