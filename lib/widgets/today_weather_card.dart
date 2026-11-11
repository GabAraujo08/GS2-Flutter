import 'package:flutter/material.dart';
import 'package:presente/app/theme.dart';
import 'package:presente/models/city.dart';
import 'package:presente/models/daily_forecast.dart';
import 'package:presente/models/load_status.dart';
import 'package:presente/services/care_advisor.dart';
import 'package:presente/services/storage_service.dart';
import 'package:presente/services/weather_service.dart';
import 'package:presente/widgets/weather_icon.dart';

class TodayWeatherCard extends StatefulWidget {
  const TodayWeatherCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<TodayWeatherCard> createState() => _TodayWeatherCardState();
}

class _TodayWeatherCardState extends State<TodayWeatherCard> {
  final WeatherService _weather = WeatherService();
  final StorageService _storage = StorageService();
  final CareAdvisor _advisor = const CareAdvisor();

  LoadStatus _status = LoadStatus.initial;
  City? _city;
  DailyForecast? _today;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _status = LoadStatus.loading);
    try {
      final city = await _storage.loadCity();
      final week = await _weather.fetchWeek(city);
      if (!mounted) return;
      setState(() {
        _city = city;
        _today = week.first;
        _status = LoadStatus.success;
      });
    } on WeatherException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _status = LoadStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    switch (_status) {
      case LoadStatus.initial:
      case LoadStatus.loading:
        return const Row(
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                'Carregando o clima de hoje...',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      case LoadStatus.error:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_error, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        );
      case LoadStatus.success:
        return _buildSummary(_today!, _city!);
    }
  }

  Widget _buildSummary(DailyForecast today, City city) {
    final level = _advisor.levelFor(today);
    final headlineColor =
        level == CareLevel.calm ? AppColors.success : AppColors.warning;
    return InkWell(
      onTap: widget.onTap,
      child: Row(
        children: [
          WeatherIcon(kind: today.kind, size: 52),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoje em ${city.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${today.maxTemp.round()}° / ${today.minTemp.round()}° · ${today.description}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  _advisor.headlineFor(today),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: headlineColor,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 32),
        ],
      ),
    );
  }
}
