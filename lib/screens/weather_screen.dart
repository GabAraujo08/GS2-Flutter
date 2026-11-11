import 'package:flutter/material.dart';
import 'package:presente/app/routes.dart';
import 'package:presente/models/city.dart';
import 'package:presente/models/daily_forecast.dart';
import 'package:presente/models/forecast_filter.dart';
import 'package:presente/models/load_status.dart';
import 'package:presente/screens/forecast_detail_screen.dart';
import 'package:presente/services/storage_service.dart';
import 'package:presente/services/weather_service.dart';
import 'package:presente/widgets/error_state.dart';
import 'package:presente/widgets/forecast_tile.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weather = WeatherService();
  final StorageService _storage = StorageService();

  LoadStatus _status = LoadStatus.initial;
  City _city = City.capitals.first;
  List<DailyForecast> _week = <DailyForecast>[];
  ForecastFilter _filter = ForecastFilter.all;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final city = await _storage.loadCity();
    if (!mounted) return;
    setState(() => _city = city);
    await _load();
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() => _status = LoadStatus.loading);
    }
    try {
      final week = await _weather.fetchWeek(_city);
      if (!mounted) return;
      setState(() {
        _week = week;
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

  Future<void> _changeCity(City? city) async {
    if (city == null) return;
    setState(() => _city = city);
    await _storage.saveCity(city);
    await _load();
  }

  void _openDetail(DailyForecast forecast) {
    Navigator.pushNamed(
      context,
      Routes.forecastDetail,
      arguments: ForecastDetailArguments(city: _city, forecast: forecast),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: DropdownButton<City>(
            value: _city,
            isExpanded: true,
            style: const TextStyle(fontSize: 20, color: Colors.black87),
            items: City.capitals
                .map(
                  (city) => DropdownMenuItem<City>(
                    value: city,
                    child: Text(city.label),
                  ),
                )
                .toList(),
            onChanged: _changeCity,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            children: ForecastFilter.values.map((filter) {
              return ChoiceChip(
                label: Text(
                  filter.label,
                  style: const TextStyle(fontSize: 16),
                ),
                selected: _filter == filter,
                onSelected: (_) => setState(() => _filter = filter),
              );
            }).toList(),
          ),
        ),
        Expanded(child: _buildContent()),
      ],
    );
  }

  Widget _buildContent() {
    switch (_status) {
      case LoadStatus.initial:
        return const Center(
          child: Text(
            'Preparando a previsão...',
            style: TextStyle(fontSize: 20),
          ),
        );
      case LoadStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadStatus.error:
        return ErrorState(message: _error, onRetry: _load);
      case LoadStatus.success:
        return _buildList();
    }
  }

  Widget _buildList() {
    final days = _week.where((forecast) => _filter.matches(forecast)).toList();
    if (days.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Nenhum dia da semana combina com esse filtro.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => _load(silent: true),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: days.length,
        itemBuilder: (context, index) {
          final forecast = days[index];
          return ForecastTile(
            forecast: forecast,
            onTap: () => _openDetail(forecast),
          );
        },
      ),
    );
  }
}
