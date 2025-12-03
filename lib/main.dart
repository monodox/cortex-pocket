import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'core/routes.dart';
import 'theme/app_theme.dart';
import 'services/llm_service.dart';

void main() {
  if (kIsWeb) {
    // Web-specific configuration
    WidgetsFlutterBinding.ensureInitialized();
  }
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
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          // Web-specific fixes
          if (kIsWeb) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          }
          return child!;
        },
      ),
    );
  }
}