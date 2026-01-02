import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:mysys/l10n/app_localizations.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'package:mysys/theme/theme_provider.dart';
import 'package:mysys/responsive/mobile_scaffold.dart';
import 'package:mysys/responsive/desktop_scaffold.dart';
import 'package:mysys/responsive/responsive_layout.dart';
import 'package:mysys/responsive/tablet_scaffold.dart';
import 'package:mysys/data/myappsettings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mysys/data/app_lifecycle_observer.dart';

//import 'package:fluttertoast/fluttertoast.dart';

//int selectedPageGlobal=0;
//ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));
void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  final localeProvider = ThemeProvider(); 
  themeProviderGlobal = localeProvider; 

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
  runApp(
    ChangeNotifierProvider(
      create: (_) =>  localeProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

   @override
  State<MyApp> createState() => _MyAppState();
}
  
class _MyAppState extends State<MyApp> {
  late AppLocaleObserver _observer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _observer = AppLocaleObserver(context);
    WidgetsBinding.instance.addObserver(_observer);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(_observer);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    final themeProvider = context.watch<ThemeProvider>();    
    themeProviderGlobal=themeProvider;
    Locale systemLang = WidgetsBinding.instance.platformDispatcher.locale;
    systemLangGlobal=systemLang.languageCode;
    langListGlobalSetter = AppLocalizations.supportedLocales;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale:themeProvider.locale,
      themeMode: themeProviderGlobal.themeMode, // <-- controlled by provider
      theme: themeProvider.theme,
      darkTheme: themeProvider.theme,     
      
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      
      supportedLocales: AppLocalizations.supportedLocales,
      
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        themeProvider.updateFromSystem(
          deviceLocale ?? supportedLocales.first,
        );

         return themeProvider.locale ??
            supportedLocales.first;
      },
      
      /*onGenerateTitle: (context) {
        return AppLocalizations.of(context)!.appTitle;
      },*/
      
      home: const ResponsiveLayout(        
        mobileScaffold: MobileScaffold(),
        tabletScaffold: TabletScaffold(),
        desktopScaffold: DesktopScaffold(),
      ),
    );    
  }
}
