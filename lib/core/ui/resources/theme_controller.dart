import 'package:flutter/material.dart';

class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier(super.initialTheme);

  bool get isDarkMode => value == ThemeMode.dark;

  void toggleTheme() {
    value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }
}
