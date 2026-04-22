class WeatherData {
  final double currentTemp;
  final int weatherCode;
  final bool isDay;
  final double forecastTemp;
  final int forecastCode;

  const WeatherData({
    required this.currentTemp,
    required this.weatherCode,
    required this.isDay,
    required this.forecastTemp,
    required this.forecastCode,
  });

  String get weatherEmoji => _emoji(weatherCode);
  String get forecastEmoji => _emoji(forecastCode);

  static String _emoji(int code) {
    if (code == 0) return '☀️';
    if (code <= 3) return '⛅';
    if (code <= 48) return '🌫️';
    if (code <= 55) return '🌦️';
    if (code <= 65) return '🌧️';
    if (code <= 77) return '❄️';
    if (code <= 82) return '🌧️';
    return '⛈️';
  }
}
