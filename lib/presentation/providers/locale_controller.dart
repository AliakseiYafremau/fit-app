import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  LocaleController(this._preferences, Locale? initialLocale)
      : _locale = initialLocale;

  static const _localePrefKey = 'preferred_locale';

  final SharedPreferences _preferences;
  Locale? _locale;

  Locale? get locale => _locale;

  Future<void> setLocale(Locale? locale) async {
    if (_locale == locale) return;
    _locale = locale;
    if (locale == null) {
      await _preferences.remove(_localePrefKey);
    } else {
      await _preferences.setString(_localePrefKey, locale.languageCode);
    }
    notifyListeners();
  }
}
