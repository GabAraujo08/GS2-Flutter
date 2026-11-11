import 'package:flutter/material.dart';
import 'package:presente/models/daily_forecast.dart';

IconData weatherIconData(WeatherKind kind) {
  switch (kind) {
    case WeatherKind.clear:
      return Icons.wb_sunny;
    case WeatherKind.cloudy:
      return Icons.wb_cloudy;
    case WeatherKind.fog:
      return Icons.cloud_queue;
    case WeatherKind.rain:
      return Icons.umbrella;
    case WeatherKind.storm:
      return Icons.thunderstorm;
  }
}

Color weatherColor(WeatherKind kind) {
  switch (kind) {
    case WeatherKind.clear:
      return const Color(0xFFF9A825);
    case WeatherKind.cloudy:
      return const Color(0xFF78909C);
    case WeatherKind.fog:
      return const Color(0xFF90A4AE);
    case WeatherKind.rain:
      return const Color(0xFF1E88E5);
    case WeatherKind.storm:
      return const Color(0xFF5E35B1);
  }
}

class WeatherIcon extends StatelessWidget {
  const WeatherIcon({super.key, required this.kind, this.size = 40});

  final WeatherKind kind;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(weatherIconData(kind), size: size, color: weatherColor(kind));
  }
}
