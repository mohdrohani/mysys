//import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import "../theme/theme_provider.dart";

class AppLocaleObserver extends WidgetsBindingObserver {
  final BuildContext context;

  AppLocaleObserver(this.context);

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null && locales.isNotEmpty) {
      context.read<ThemeProvider>().updateFromSystem(locales.first);
    }
  }
}