import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:presente/models/city.dart';
import 'package:presente/models/daily_forecast.dart';

class WeatherException implements Exception {
  WeatherException(this.message);

  final String message;

  @override
  String toString() => message;
}

class WeatherService {
  WeatherService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<DailyForecast>> fetchWeek(City city) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': city.latitude.toString(),
      'longitude': city.longitude.toString(),
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min,precipitation_sum',
      'timezone': 'auto',
      'forecast_days': '7',
    });

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 12));
      if (response.statusCode != 200) {
        throw WeatherException(
          'O serviço de clima não respondeu (código ${response.statusCode}). Tente novamente em instantes.',
        );
      }
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final daily = body['daily'] as Map<String, dynamic>?;
      if (daily == null) {
        throw WeatherException('A previsão veio vazia. Tente novamente.');
      }
      final week = DailyForecast.listFromDaily(daily);
      if (week.isEmpty) {
        throw WeatherException('A previsão veio vazia. Tente novamente.');
      }
      return week;
    } on WeatherException {
      rethrow;
    } on TimeoutException {
      throw WeatherException(
        'A conexão demorou demais. Verifique a internet e tente novamente.',
      );
    } on http.ClientException {
      throw WeatherException(
        'Sem conexão com a internet. Verifique a rede e tente novamente.',
      );
    } catch (_) {
      throw WeatherException(
        'Não foi possível carregar o clima agora. Tente novamente.',
      );
    }
  }
}
