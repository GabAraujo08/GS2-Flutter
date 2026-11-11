import 'package:flutter/material.dart';
import 'package:presente/app/theme.dart';
import 'package:presente/models/city.dart';
import 'package:presente/models/daily_forecast.dart';
import 'package:presente/services/care_advisor.dart';
import 'package:presente/utils/formatters.dart';
import 'package:presente/widgets/big_button.dart';
import 'package:presente/widgets/weather_icon.dart';

class ForecastDetailArguments {
  const ForecastDetailArguments({required this.city, required this.forecast});

  final City city;
  final DailyForecast forecast;
}

class ForecastDetailScreen extends StatelessWidget {
  const ForecastDetailScreen({super.key, required this.args});

  final ForecastDetailArguments args;

  @override
  Widget build(BuildContext context) {
    final forecast = args.forecast;
    final tips = const CareAdvisor().tipsFor(forecast);

    return Scaffold(
      appBar: AppBar(title: Text(args.city.name)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Center(child: WeatherIcon(kind: forecast.kind, size: 110)),
            const SizedBox(height: 12),
            Text(
              '${weekdayName(forecast.date)}, ${formatShortDate(forecast.date)}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              forecast.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _Metric(
                      icon: Icons.arrow_upward,
                      label: 'Máxima',
                      value: '${forecast.maxTemp.round()}°',
                    ),
                    _Metric(
                      icon: Icons.arrow_downward,
                      label: 'Mínima',
                      value: '${forecast.minTemp.round()}°',
                    ),
                    _Metric(
                      icon: Icons.water_drop,
                      label: 'Chuva',
                      value: '${forecast.precipitation.toStringAsFixed(1)} mm',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Cuidados para o dia',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ...tips.map(_buildTip),
            const SizedBox(height: 20),
            BigButton(
              label: 'Voltar',
              icon: Icons.arrow_back,
              color: AppColors.primary,
              height: 72,
              fontSize: 24,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTip(String tip) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: AppColors.warning, size: 30),
            const SizedBox(width: 12),
            Expanded(
              child: Text(tip, style: const TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: AppColors.primary),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
