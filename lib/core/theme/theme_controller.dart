import 'package:flutter/material.dart';

import '../services/preferences_manager.dart';

class ThemeController {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(
    ThemeMode.dark,
  );

  init() {
    bool result = PreferencesManager().getBool("theme") ?? true;
    themeNotifier.value = result ? ThemeMode.dark : ThemeMode.light;
  }

  static toggleTheme() async {
    if (themeNotifier.value == ThemeMode.dark) {
      themeNotifier.value = ThemeMode.light;
      await PreferencesManager().setBool("theme", false);
    } else {
      themeNotifier.value = ThemeMode.dark;
      await PreferencesManager().setBool("theme", true);
    }
  }

  // static Color borderColor() {
  //   if (themeNotifier.value == ThemeMode.dark) {
  //     return Colors.transparent;
  //   } else {
  //     return Color(0xFFD1DAD6);
  //   }
  // }
static bool isDark() => themeNotifier.value == ThemeMode.dark;
}
