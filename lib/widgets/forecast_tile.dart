import 'package:flutter/material.dart';
import 'package:presente/models/daily_forecast.dart';
import 'package:presente/utils/formatters.dart';
import 'package:presente/widgets/weather_icon.dart';

class ForecastTile extends StatelessWidget {
  const ForecastTile({
    super.key,
    required this.forecast,
    required this.onTap,
  });

  final DailyForecast forecast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              WeatherIcon(kind: forecast.kind, size: 44),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weekdayName(forecast.date),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${formatShortDate(forecast.date)} · ${forecast.description}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Text(
                '${forecast.maxTemp.round()}° / ${forecast.minTemp.round()}°',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const Icon(Icons.chevron_right, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}
