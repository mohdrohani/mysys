// ignore_for_file: unreachable_switch_default

import 'package:flutter/material.dart';
import 'schemes/blue_scheme.dart';
import 'schemes/green_scheme.dart';
import 'schemes/yellow_scheme.dart';
import 'schemes/pink_scheme.dart';
import 'schemes/navy_scheme.dart';
import 'app_color_scheme.dart';

enum AppThemeMode { light, dark }

ThemeData buildTheme({
  required AppColorScheme scheme,
  required AppThemeMode mode,
}) {
  final ColorScheme colorScheme;

  switch (scheme) {
    case AppColorScheme.green:
      colorScheme =
          mode == AppThemeMode.dark
              ? GreenScheme.dark
              : GreenScheme.light;
      break;
    case AppColorScheme.yellow:
      colorScheme =
          mode == AppThemeMode.dark
              ? YellowScheme.dark
              : YellowScheme.light;
      break;    
    case AppColorScheme.blue:
      colorScheme =
          mode == AppThemeMode.dark
              ? BlueScheme.dark
              : BlueScheme.light;
      break;    
    case AppColorScheme.pink:
      colorScheme =
          mode == AppThemeMode.dark
              ? PinkScheme.dark
              : PinkScheme.light;
      break;    
    case AppColorScheme.navy:
      colorScheme =
          mode == AppThemeMode.dark
              ? NavyScheme.dark
              : NavyScheme.light;
      break;
    default:
      colorScheme =
          mode == AppThemeMode.dark
              ? BlueScheme.dark
              : BlueScheme.light;
  }

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,    
  );
}
