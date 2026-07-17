import 'package:flutter/material.dart';
import 'package:tasky/core/theme/dark_theme.dart';
import 'package:tasky/core/theme/light_theme.dart';
import 'package:tasky/core/theme/theme_controller.dart';

import 'package:tasky/screens/main_screen.dart';

import 'package:tasky/screens/welcome_screen.dart';

import 'core/services/preferences_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferencesManager().init();
  ThemeController().init();

  String? name = PreferencesManager().getString("username");

  runApp(MyApp(username: name));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.username});

  final String? username;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeNotifier,
      builder: (context, ThemeMode themeMode, Widget? child) {
        return MaterialApp(
          title: "Tasky App",
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeMode,
          home: username == null ? WelcomeScreen() : MainScreen(),
        );
      },
    );
  }
}
