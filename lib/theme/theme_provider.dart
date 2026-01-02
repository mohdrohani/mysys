import 'package:flutter/material.dart';
import 'app_color_scheme.dart';
import 'theme_factory.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isManual = false;
  ThemeMode themeMode = ThemeMode.system;
  Locale? _locale;
  Locale? get locale => _locale;
  ThemeMode get myThemeMode => themeMode;
  AppColorScheme _scheme = AppColorScheme.blue;
  AppThemeMode _mode = AppThemeMode.light;

  ThemeData get theme =>
      buildTheme(scheme: _scheme, mode: _mode);

  AppColorScheme get currentScheme => _scheme;
  AppThemeMode get currentMode => _mode;

  void changeScheme(AppColorScheme scheme) {
    _scheme = scheme;
    notifyListeners();
  }

  void toggleMode() {
    _mode = _mode == AppThemeMode.light
        ? AppThemeMode.dark
        : AppThemeMode.light;
    notifyListeners();
  }

  void updateFromSystem(Locale systemLocale) {
    if (!_isManual) {
      _locale = systemLocale;
      notifyListeners();
    }
  }  

   /// Called automatically when system language changes
  /// Reset to system language
  void useSystem() {
    _isManual = false;
    _locale = null;
    notifyListeners();
  }

  /// Manual language selection
  /// Manual language selection
  void setLocale(Locale locale) {
    _locale = locale;
    _isManual = true;
    notifyListeners();
  } 

  void setLight() {
    themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setDark() {
    themeMode = ThemeMode.dark;
    notifyListeners();
  }  
}