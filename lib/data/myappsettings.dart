import 'package:mysys/theme/theme_provider.dart';
//import 'package:mysys/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
var crossAxisCountGlobal = 2;
int get crossAxisCountGlobalGetter => crossAxisCountGlobal;
set crossAxisCountGlobalSetter(int value) => crossAxisCountGlobal = value;

double myMaxWidthGlobal = 0;
double get myMaxWidthGlobalGetter => myMaxWidthGlobal;
set myMaxWidthGlobalSetter(double value) => myMaxWidthGlobal = value;

double myMaxHeightGlobal = 0;
double get myMaxHeightGlobalGetter => myMaxHeightGlobal;
set myMaxHeightGlobalSetter(double value) => myMaxHeightGlobal = value;

int selectedPageGlobal=0;
int get selectedPageGlobalGetter => selectedPageGlobal;
set selectedPageGlobalSetter(int value) {
  selectedPageGlobal = value;
}

String systemLangGlobal="";
String get systemLangGlobalGetter => systemLangGlobal;
set systemLangGlobalSetter(String value) {
  systemLangGlobal = value;
}

List<Locale> langListGlobal = [];
List<Locale> get langListGlobalGetter => langListGlobal;
set langListGlobalSetter(List<Locale> value) {
  langListGlobal = value;
}

ThemeProvider themeProviderGlobal =ThemeProvider();
ThemeProvider get themeProviderGlobalGetter => themeProviderGlobal;
set themeProviderGlobalSetter(ThemeProvider value) {
  themeProviderGlobal = value;
}