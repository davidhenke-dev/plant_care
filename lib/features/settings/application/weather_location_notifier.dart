import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/repository_providers.dart';

class WeatherLocationSettings {
  final bool isStatic;
  final double? lat;
  final double? lon;
  final String? cityName;

  const WeatherLocationSettings({
    this.isStatic = false,
    this.lat,
    this.lon,
    this.cityName,
  });
}

class WeatherLocationNotifier extends Notifier<WeatherLocationSettings> {
  static const _keyStatic = 'weather_location_static';
  static const _keyLat = 'weather_lat';
  static const _keyLon = 'weather_lon';
  static const _keyCity = 'weather_city';

  @override
  WeatherLocationSettings build() {
    final box = ref.read(settingsBoxProvider);
    return WeatherLocationSettings(
      isStatic: box.get(_keyStatic, defaultValue: false) as bool,
      lat: box.get(_keyLat) as double?,
      lon: box.get(_keyLon) as double?,
      cityName: box.get(_keyCity) as String?,
    );
  }

  Future<void> setDynamic() async {
    final box = ref.read(settingsBoxProvider);
    await box.put(_keyStatic, false);
    state = WeatherLocationSettings(
      isStatic: false,
      lat: state.lat,
      lon: state.lon,
      cityName: state.cityName,
    );
  }

  Future<void> setStatic(double lat, double lon, String? cityName) async {
    final box = ref.read(settingsBoxProvider);
    await box.put(_keyStatic, true);
    await box.put(_keyLat, lat);
    await box.put(_keyLon, lon);
    await box.put(_keyCity, cityName ?? '');
    state = WeatherLocationSettings(
      isStatic: true,
      lat: lat,
      lon: lon,
      cityName: cityName,
    );
  }
}

final weatherLocationNotifierProvider =
    NotifierProvider<WeatherLocationNotifier, WeatherLocationSettings>(
  WeatherLocationNotifier.new,
);
