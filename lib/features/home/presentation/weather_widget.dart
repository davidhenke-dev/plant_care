import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/weather_notifier.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import 'weather_settings_screen.dart';

class WeatherWidget extends ConsumerWidget {
  const WeatherWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);

    return weatherAsync.when(
      loading: () => const _WeatherSkeleton(),
      error: (e, _) => const SizedBox.shrink(),
      data: (w) {
        final l = AppLocalizations.of(context);
        final forecastLabel =
            w.isDay ? l.homeWeatherTonight : l.homeWeatherTomorrow;

        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => const WeatherSettingsScreen(),
            ),
          ),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: w.isDay
                    ? [const Color(0xFF81C784), const Color(0xFF4CAF50)]
                    : [const Color(0xFF4CAF50), const Color(0xFF388E3C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
            children: [
              // Aktuell
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      w.isDay ? l.homeWeatherNow : l.homeWeatherNowNight,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xAAFFFFFF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${w.currentTemp.round()}°',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w300,
                            color: CupertinoColors.white,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          w.weatherEmoji,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Trennlinie
              Container(
                width: 0.5,
                height: 50,
                color: const Color(0x44FFFFFF),
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),

              // Prognose
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    forecastLabel,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xAAFFFFFF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        w.forecastEmoji,
                        style: const TextStyle(fontSize: 22),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${w.forecastTemp.round()}°',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w300,
                          color: CupertinoColors.white,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
            ),
          ),
        );
      },
    );
  }
}

class _WeatherSkeleton extends StatelessWidget {
  const _WeatherSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      height: 80,
      decoration: BoxDecoration(
        color: kCardBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: CupertinoActivityIndicator()),
    );
  }
}
