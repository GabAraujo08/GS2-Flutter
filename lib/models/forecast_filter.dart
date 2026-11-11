import 'package:presente/models/daily_forecast.dart';

enum ForecastFilter { all, hot, rain }

extension ForecastFilterRules on ForecastFilter {
  String get label {
    switch (this) {
      case ForecastFilter.all:
        return 'Todos os dias';
      case ForecastFilter.hot:
        return 'Dias quentes';
      case ForecastFilter.rain:
        return 'Dias de chuva';
    }
  }

  bool matches(DailyForecast forecast) {
    switch (this) {
      case ForecastFilter.all:
        return true;
      case ForecastFilter.hot:
        return forecast.isHot;
      case ForecastFilter.rain:
        return forecast.isRainy;
    }
  }
}
