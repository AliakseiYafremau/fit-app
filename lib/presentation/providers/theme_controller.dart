import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeController({bool isDark = false}) : _isDark = isDark;

  bool _isDark;

  bool get isDark => _isDark;

  void toggleTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
