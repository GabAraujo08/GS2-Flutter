enum WeatherKind { clear, cloudy, fog, rain, storm }

class DailyForecast {
  const DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitation,
    required this.weatherCode,
  });

  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final double precipitation;
  final int weatherCode;

  WeatherKind get kind {
    if (weatherCode <= 1) return WeatherKind.clear;
    if (weatherCode <= 3) return WeatherKind.cloudy;
    if (weatherCode == 45 || weatherCode == 48) return WeatherKind.fog;
    if (weatherCode >= 95) return WeatherKind.storm;
    if ((weatherCode >= 51 && weatherCode <= 67) ||
        (weatherCode >= 80 && weatherCode <= 82)) {
      return WeatherKind.rain;
    }
    return WeatherKind.cloudy;
  }

  bool get isHot => maxTemp >= 30;

  bool get isRainy {
    return precipitation >= 1 ||
        kind == WeatherKind.rain ||
        kind == WeatherKind.storm;
  }

  String get description {
    switch (kind) {
      case WeatherKind.clear:
        return 'Céu limpo';
      case WeatherKind.cloudy:
        return 'Nublado';
      case WeatherKind.fog:
        return 'Neblina';
      case WeatherKind.rain:
        return 'Chuva';
      case WeatherKind.storm:
        return 'Tempestade';
    }
  }

  static List<DailyForecast> listFromDaily(Map<String, dynamic> daily) {
    final times = daily['time'] as List<dynamic>;
    final maxes = daily['temperature_2m_max'] as List<dynamic>;
    final mins = daily['temperature_2m_min'] as List<dynamic>;
    final rains = daily['precipitation_sum'] as List<dynamic>;
    final codes = daily['weather_code'] as List<dynamic>;

    return List<DailyForecast>.generate(times.length, (i) {
      return DailyForecast(
        date: DateTime.parse(times[i] as String),
        maxTemp: _toDouble(maxes[i]),
        minTemp: _toDouble(mins[i]),
        precipitation: _toDouble(rains[i]),
        weatherCode: (codes[i] as num?)?.toInt() ?? 0,
      );
    });
  }

  static double _toDouble(dynamic value) {
    return (value as num?)?.toDouble() ?? 0;
  }
}
