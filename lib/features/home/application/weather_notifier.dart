import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/weather/position_service.dart';
import '../../../core/weather/weather_data.dart';
import '../../../core/weather/weather_service.dart';
import '../../settings/application/weather_location_notifier.dart';

class WeatherNotifier extends AsyncNotifier<WeatherData> {
  Timer? _timer;

  @override
  Future<WeatherData> build() async {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 30), (_) => refresh());
    ref.onDispose(() => _timer?.cancel());

    // Re-fetch whenever the location setting changes
    ref.listen(weatherLocationNotifierProvider, (_, __) => refresh());

    return _fetch();
  }

  Future<WeatherData> _fetch() async {
    final settings = ref.read(weatherLocationNotifierProvider);
    if (settings.isStatic && settings.lat != null && settings.lon != null) {
      return WeatherService().fetch(settings.lat!, settings.lon!);
    }
    final position = await PositionService().getCurrentPosition();
    return WeatherService().fetch(position.latitude, position.longitude);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

final weatherProvider =
    AsyncNotifierProvider<WeatherNotifier, WeatherData>(WeatherNotifier.new);
