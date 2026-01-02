import 'package:flutter/material.dart';
import 'app_color_scheme.dart';
import 'theme_factory.dart';
class ThemeController extends ChangeNotifier 
{
  
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
}