import 'package:flutter/material.dart';
import 'package:presente/app/app_router.dart';
import 'package:presente/app/routes.dart';
import 'package:presente/app/theme.dart';

class PresenteApp extends StatelessWidget {
  const PresenteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Presente',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      builder: (context, child) {
        return ColoredBox(
          color: const Color(0xFFE8E6DF),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: child,
            ),
          ),
        );
      },
      initialRoute: Routes.splash,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
