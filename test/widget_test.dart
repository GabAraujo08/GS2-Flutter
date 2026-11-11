import 'package:flutter_test/flutter_test.dart';
import 'package:presente/models/daily_forecast.dart';
import 'package:presente/models/forecast_filter.dart';
import 'package:presente/services/care_advisor.dart';

DailyForecast _forecast({
  double max = 25,
  double min = 18,
  double rain = 0,
  int code = 0,
}) {
  return DailyForecast(
    date: DateTime(2026, 11, 9),
    maxTemp: max,
    minTemp: min,
    precipitation: rain,
    weatherCode: code,
  );
}

void main() {
  const advisor = CareAdvisor();

  test('calor extremo gera nivel de alerta', () {
    expect(advisor.levelFor(_forecast(max: 37)), CareLevel.alert);
  });

  test('dia quente gera nivel de atencao', () {
    expect(advisor.levelFor(_forecast(max: 31)), CareLevel.attention);
  });

  test('tempo ameno gera nivel calmo', () {
    expect(advisor.levelFor(_forecast()), CareLevel.calm);
  });

  test('tempestade gera nivel de alerta', () {
    expect(advisor.levelFor(_forecast(code: 95)), CareLevel.alert);
  });

  test('filtros separam dias quentes e dias de chuva', () {
    final hot = _forecast(max: 33);
    final rainy = _forecast(rain: 6, code: 63);

    expect(ForecastFilter.hot.matches(hot), isTrue);
    expect(ForecastFilter.hot.matches(rainy), isFalse);
    expect(ForecastFilter.rain.matches(rainy), isTrue);
    expect(ForecastFilter.all.matches(hot), isTrue);
  });

  test('converte o bloco daily da API em previsoes', () {
    final week = DailyForecast.listFromDaily({
      'time': ['2026-11-09', '2026-11-10'],
      'temperature_2m_max': [30.5, 22],
      'temperature_2m_min': [20.1, 15],
      'precipitation_sum': [0.0, 4.2],
      'weather_code': [1, 63],
    });

    expect(week.length, 2);
    expect(week.first.maxTemp, 30.5);
    expect(week.first.isHot, isTrue);
    expect(week.last.kind, WeatherKind.rain);
  });
}
