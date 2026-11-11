import 'package:flutter/material.dart';
import 'package:presente/app/routes.dart';
import 'package:presente/screens/forecast_detail_screen.dart';
import 'package:presente/screens/help_screen.dart';
import 'package:presente/screens/home_shell.dart';
import 'package:presente/screens/onboarding_screen.dart';
import 'package:presente/screens/splash_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.onboarding:
        return _page(const OnboardingScreen(), settings);
      case Routes.home:
        return _page(const HomeShell(), settings);
      case Routes.help:
        {
          final args = settings.arguments as HelpArguments;
          return _page(HelpScreen(args: args), settings);
        }
      case Routes.forecastDetail:
        {
          final args = settings.arguments as ForecastDetailArguments;
          return _page(ForecastDetailScreen(args: args), settings);
        }
      default:
        return _page(const SplashScreen(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _page(Widget child, RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => child,
      settings: settings,
    );
  }
}
