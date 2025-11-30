import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const CortexApp());
}

class CortexApp extends StatelessWidget {
  const CortexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cortex Pocket',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: Routes.splash,
      routes: Routes.routes,
    );
  }
}