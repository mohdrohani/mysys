import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:mysys/l10n/app_localizations.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';


import 'package:mysys/responsive/mobile_scaffold.dart';
import 'package:mysys/responsive/desktop_scaffold.dart';
import 'package:mysys/responsive/responsive_layout.dart';
import 'package:mysys/responsive/tablet_scaffold.dart';
//int selectedPageGlobal=0;
//ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));
void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb &&
  (defaultTargetPlatform == TargetPlatform.windows || 
  defaultTargetPlatform == TargetPlatform.linux || 
  defaultTargetPlatform == TargetPlatform.macOS)) {
    await windowManager.ensureInitialized();

    WindowOptions options = const WindowOptions(
      size: Size(1900, 900),
      minimumSize: Size(1100, 600),
      center: true,
      skipTaskbar: false,      
      fullScreen: false,
      alwaysOnTop: false,
    );

    windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {    
    //const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      
      supportedLocales: AppLocalizations.supportedLocales,
      
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      
      /*onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },*/
      

      
      
      home: ResponsiveLayout(        
        mobileScaffold: const MobileScaffold(),
        tabletScaffold: const TabletScaffold(),
        desktopScaffold: const DesktopScaffold(),
      ),
    );
  }
}
