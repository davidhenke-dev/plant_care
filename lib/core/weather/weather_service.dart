import 'dart:convert';
import 'package:http/http.dart' as http;
import 'weather_data.dart';

class WeatherService {
  static const _base = 'https://api.open-meteo.com/v1/forecast';

  Future<WeatherData> fetch(double lat, double lon) async {
    final uri = Uri.parse(_base).replace(queryParameters: {
      'latitude': lat.toString(),
      'longitude': lon.toString(),
      'current': 'temperature_2m,weather_code,is_day',
      'hourly': 'temperature_2m,weather_code',
      'forecast_days': '2',
      'timezone': 'auto',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Wetter-API Fehler: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final current = json['current'] as Map<String, dynamic>;
    final hourly = json['hourly'] as Map<String, dynamic>;

    final currentTemp = (current['temperature_2m'] as num).toDouble();
    final weatherCode = current['weather_code'] as int;
    final hour = DateTime.now().hour;
    final isDay = hour >= 7 && hour < 19;

    final times = List<String>.from(hourly['time'] as List);
    final temps = List<double>.from(
      (hourly['temperature_2m'] as List).map((e) => (e as num).toDouble()),
    );
    final codes = List<int>.from(
      (hourly['weather_code'] as List).map((e) => e as int),
    );

    final now = DateTime.now();
    final targetHour = isDay ? 22 : 13;
    final targetDate = isDay ? now : now.add(const Duration(days: 1));
    final targetStr =
        '${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}T${targetHour.toString().padLeft(2, '0')}:00';

    final idx = times.indexOf(targetStr);
    final forecastTemp = idx >= 0 ? temps[idx] : temps.last;
    final forecastCode = idx >= 0 ? codes[idx] : codes.last;

    return WeatherData(
      currentTemp: currentTemp,
      weatherCode: weatherCode,
      isDay: isDay,
      forecastTemp: forecastTemp,
      forecastCode: forecastCode,
    );
  }
}
