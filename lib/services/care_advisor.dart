import 'package:presente/models/daily_forecast.dart';

enum CareLevel { calm, attention, alert }

class CareAdvisor {
  const CareAdvisor();

  CareLevel levelFor(DailyForecast forecast) {
    if (forecast.maxTemp >= 35 || forecast.kind == WeatherKind.storm) {
      return CareLevel.alert;
    }
    if (forecast.maxTemp >= 30 || forecast.isRainy || forecast.minTemp <= 12) {
      return CareLevel.attention;
    }
    return CareLevel.calm;
  }

  String headlineFor(DailyForecast forecast) {
    if (forecast.kind == WeatherKind.storm) {
      return 'Tempestade prevista: fique em casa';
    }
    if (forecast.maxTemp >= 35) {
      return 'Calor extremo: beba bastante água';
    }
    if (forecast.maxTemp >= 30) {
      return 'Dia quente: mantenha-se hidratado';
    }
    if (forecast.isRainy) {
      return 'Vai chover: cuidado com o piso molhado';
    }
    if (forecast.minTemp <= 12) {
      return 'Dia frio: agasalhe-se bem';
    }
    return 'Tempo tranquilo hoje';
  }

  List<String> tipsFor(DailyForecast forecast) {
    final tips = <String>[];

    if (forecast.maxTemp >= 35) {
      tips.add('Beba água mesmo sem sentir sede e evite sair entre 10h e 16h.');
      tips.add('Mantenha a casa ventilada e use roupas leves e claras.');
    } else if (forecast.maxTemp >= 30) {
      tips.add('Beba água ao longo do dia e prefira sair de manhã cedo ou à noite.');
    }

    if (forecast.kind == WeatherKind.storm) {
      tips.add('Fique em casa e afaste-se de janelas durante a tempestade.');
      tips.add('Deixe o celular carregado e a lanterna por perto.');
    } else if (forecast.isRainy) {
      tips.add('Piso molhado escorrega: use calçado fechado com sola antiderrapante.');
      tips.add('Se possível, deixe as compras e saídas para outro dia.');
    }

    if (forecast.minTemp <= 12) {
      tips.add('Agasalhe-se bem, principalmente mãos, pés e pescoço.');
    }

    if (tips.isEmpty) {
      tips.add('Dia bom para uma caminhada leve e para arejar a casa.');
      tips.add('Aproveite para ligar para alguém da família.');
    }

    return tips;
  }
}
