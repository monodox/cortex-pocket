import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/routes.dart';
import 'theme/app_theme.dart';
import 'services/llm_service.dart';

void main() {
  runApp(const CortexApp());
}

class CortexApp extends StatelessWidget {
  const CortexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LLMService(),
      child: MaterialApp(
        title: 'Cortex Pocket',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: Routes.splash,
        routes: Routes.routes,
      ),
    );
  }
}