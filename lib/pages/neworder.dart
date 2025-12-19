import 'package:flutter/material.dart';
import 'package:mysys/l10n/app_localizations.dart';
import 'package:mysys/models/main_menu.dart';
import 'package:mysys/data/myappsettings.dart';
import '../models/textsection.dart';
import '../models/titledcontainer.dart';
import "../models/theme_provider.dart";
import 'package:provider/provider.dart';
//import 'package:fluttertoast/fluttertoast.dart';


final List<Color> colors=myColors;

class Neworder extends StatelessWidget {
  const Neworder({super.key});

  @override
  Widget build(BuildContext context) {    
    final allcolors = Theme.of(context).colorScheme;
    themeProviderGlobal = context.watch<ThemeProvider>();
    
    /*Fluttertoast.showToast(
    msg: "${themeProviderGlobal.themeMode.name} dark mode=${themeProviderGlobal.themeMode==ThemeMode.dark}",
    toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
    gravity: ToastGravity.CENTER, // or TOP, BOTTOM, etc.
    timeInSecForIosWeb: 1, // duration for iOS/web
    backgroundColor: allcolors.primaryContainer,
    textColor: allcolors.onPrimaryContainer,
    fontSize: 16.0);*/
    return Scaffold(      
      backgroundColor: allcolors.primary,
      appBar: AppBar(
        backgroundColor: allcolors.secondaryContainer,
        iconTheme: IconThemeData(
          color: allcolors.onSecondaryContainer,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color:allcolors.onSecondaryContainer,
          onPressed: () 
          {
            Navigator.pop(context);
          },
        ),
        title: Text(
          //AppLocalizations.of(context)!.newOrder+"S:${Localizations.localeOf(context).toString()}C:${Localizations.localeOf(context).countryCode}L:${Localizations.localeOf(context).languageCode}",
          AppLocalizations.of(context)!.newOrder,
          style: TextStyle(fontWeight: FontWeight.bold,color: allcolors.onSecondaryContainer),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().themeMode == ThemeMode.dark
              ? Icons.dark_mode
              : Icons.light_mode,
            ),
            color: allcolors.onSecondaryContainer,
            onPressed: () {              
              themeProviderGlobal = context.read<ThemeProvider>();
              themeProviderGlobal.toggleTheme();              
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(        
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: allcolors.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.qr_code, color: allcolors.onPrimaryContainer),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextSection(description: AppLocalizations.of(context)!.qrReadingText,textColor: allcolors.onPrimaryContainer),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: allcolors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.camera_alt, color: allcolors.onPrimaryContainer),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: allcolors.primaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.search, color: allcolors.onPrimaryContainer),
                  ),
                ],
              ),
            ),
                      
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child:
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: allcolors.secondary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: TitledContainer(
                        title: AppLocalizations.of(context)!.customer,
                        titleBackgroundColor: allcolors.secondary,
                        titleColor: allcolors.secondaryContainer,
                        borderColor: allcolors.secondaryContainer,
                        child: Text(
                          "العملاء",
                          style: TextStyle(
                            color: allcolors.secondaryFixed, fontSize: 14),
                        )
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Center(
                      child: TitledContainer(
                        title: AppLocalizations.of(context)!.salesMan,
                        titleBackgroundColor: allcolors.secondary,
                        titleColor: allcolors.secondaryContainer,
                        borderColor: allcolors.secondaryContainer,
                        child: Text(
                          "المبيعات",
                          style: TextStyle(
                            color:allcolors.secondaryFixed, fontSize: 14),
                        )
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children:[
                  Expanded(
                    child: SizedBox(
                      width:150,
                      height: 20,
                      child: TextSection(description: AppLocalizations.of(context)!.addDiscount,textFontSize: 14.00,textColor:allcolors.secondaryContainer,textFontWeight: FontWeight.bold),                          
                    ),
                  ),
                  SizedBox(
                    width:50,
                    height: 20,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: allcolors.secondaryContainer)
                          )
                        )
                    ),   
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SizedBox(
                      width:40,
                      height: 20,
                      child: TextSection(description: AppLocalizations.of(context)!.saudiCurrancy,textFontSize: 14.00,textColor: allcolors.secondaryContainer),                          
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children:[
                  Expanded(
                    child: SizedBox(
                      width:150,
                      height: 20,
                      child: TextSection(description: AppLocalizations.of(context)!.total,textFontSize: 14.00,textColor: allcolors.secondaryContainer,textFontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width:50,
                    height: 20,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: allcolors.secondaryContainer)
                          )
                        )
                    ),                    
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: SizedBox(
                      width:40,
                      height: 20,
                      child: TextSection(description: AppLocalizations.of(context)!.saudiCurrancy,textFontSize: 14.00,textColor: allcolors.secondaryContainer),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: allcolors.tertiary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Change the curve here
                        ),
                      ),
                      child: TextSection(description: AppLocalizations.of(context)!.payment,textFontSize: 16,textColor:allcolors.onTertiary,textFontWeight: FontWeight.bold),
                      onPressed: () {},                            
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: allcolors.tertiary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Change the curve here
                        ),
                      ),
                      child: TextSection(description: AppLocalizations.of(context)!.note,textFontSize: 16,textColor:allcolors.onTertiary,textFontWeight: FontWeight.bold),
                      onPressed: () {},                            
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),     
      ),
    );
  }
}
