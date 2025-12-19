import 'package:flutter/material.dart';


class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  
  void setLight() {
    themeMode = ThemeMode.light;
    notifyListeners();
  }

  void setDark() {
    themeMode = ThemeMode.dark;
    notifyListeners();
  }


  void toggleTheme() {
    themeMode =
        themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;        
    notifyListeners();
  }
}