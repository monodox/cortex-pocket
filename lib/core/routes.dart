import 'package:flutter/material.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/model_selection_screen.dart';
import '../ui/screens/chat_screen.dart';
import '../ui/screens/persona_selector_screen.dart';
import '../ui/screens/file_reasoning_screen.dart';
import '../ui/screens/benchmark_screen.dart';
import '../ui/screens/history_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/about_screen.dart';

class Routes {
  static const String splash = '/';
  static const String home = '/home';
  static const String models = '/models';
  static const String chat = '/chat';
  static const String personas = '/personas';
  static const String fileReasoning = '/file-reasoning';
  static const String benchmark = '/benchmark';
  static const String history = '/history';
  static const String settings = '/settings';
  static const String about = '/about';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    models: (context) => const ModelSelectionScreen(),
    chat: (context) => const ChatScreen(),
    personas: (context) => const PersonaSelectorScreen(),
    fileReasoning: (context) => const FileReasoningScreen(),
    benchmark: (context) => const BenchmarkScreen(),
    history: (context) => const HistoryScreen(),
    settings: (context) => const SettingsScreen(),
    about: (context) => const AboutScreen(),
  };
}