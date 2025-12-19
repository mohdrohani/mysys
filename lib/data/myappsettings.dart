import 'package:mysys/models/theme_provider.dart';
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


ThemeProvider themeProviderGlobal =ThemeProvider();
ThemeProvider get themeProviderGlobalGetter => themeProviderGlobal;
set themeProviderGlobalSetter(ThemeProvider value) {
  themeProviderGlobal = value;
}