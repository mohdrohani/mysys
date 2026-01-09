import 'package:flutter/material.dart';
import 'package:mysys/l10n/app_localizations.dart';
//import 'package:mysys/models/main_menu.dart';
import 'package:mysys/data/myappsettings.dart';
//import '../models/textsection.dart';
//import '../models/titledcontainer.dart';
import "../theme/theme_provider.dart";
import 'package:provider/provider.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:mysys/theme/app_color_scheme.dart';
import 'package:mysys/database/app_database.dart';
class Mysettings extends StatefulWidget {
  const Mysettings({super.key});
  @override
  State<Mysettings> createState() => _MysettingsState();
}

class _MysettingsState extends State<Mysettings> {
  String lang=systemLangGlobalGetter;
  TextEditingController searchController = TextEditingController();
  List<Locale> filteredLanguages = [];  
  String? _dbPath;   
  bool _isLangExpanded = false;
  bool _isThemeExpanded = false;
  bool _isDatabaseExpanded = false;
  
  @override
  void initState() {
    super.initState();
    _loadDatabasePath();
    filteredLanguages = langListGlobalGetter;
    searchController.addListener(_filterLanguages);
  }

  Future<void> _loadDatabasePath() async {
  final path = await AppDatabase.getDatabasePath();
  setState(() {
    _dbPath = path;
  });
}

  void _filterLanguages() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredLanguages = langListGlobalGetter;
      } else {
        filteredLanguages = langListGlobalGetter.where((locale) {
          String langName = langList(context, locale.languageCode).toLowerCase();
          return langName.contains(searchController.text.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  
  //function to get the current system language name
  String langFunc(BuildContext context) {    
    //String lang=systemLangGlobal;
    switch (lang) {
      case 'en':
        lang=AppLocalizations.of(context)!.english;
        break;
      case 'ar':
        lang=AppLocalizations.of(context)!.arabic;
        break;
      default:
    }
    return lang;
  }
  //function to get the languages List available
  String langList(BuildContext context,String lang) {        
    switch (lang) {
      case 'en':
        lang=AppLocalizations.of(context)!.english;
        break;
      case 'ar':
        lang=AppLocalizations.of(context)!.arabic;
        break;
      default:
    }
    return lang;
  }
  //function to get the theme app colors available
  String colorList(BuildContext context,String color) {        
    switch (color) {
      case 'blue':
        color=AppLocalizations.of(context)!.myBlue;
        break;
      case 'green':
        color=AppLocalizations.of(context)!.myGreen;
        break;
      case 'yellow':
        color=AppLocalizations.of(context)!.myYellow;
        break;
      case 'pink':
        color=AppLocalizations.of(context)!.myPink;
        break;
      case 'navy':
        color=AppLocalizations.of(context)!.myNavy;
        break;
      default:
    }
    return color;
  }
  
  @override
  Widget build(BuildContext context) {
    final allcolors = Theme.of(context).colorScheme;
    final tProvider=context.read<ThemeProvider>();   
    themeProviderGlobal = tProvider;    
    //List<Locale> availableLanguages = langListGlobalGetter;
    
    /*Fluttertoast.showToast(
    msg: "System Language=${langFunc(context)}",
    toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
    gravity: ToastGravity.CENTER, // or TOP, BOTTOM, etc.
    timeInSecForIosWeb: 1, // duration for iOS/web
    backgroundColor: allcolors.primaryContainer,
    textColor: allcolors.onPrimaryContainer,
    fontSize: 16.0);*/

    return Scaffold(
      backgroundColor: allcolors.primary,
      appBar: AppBar(        
        backgroundColor: allcolors.primary,
        centerTitle: true,
        iconTheme: IconThemeData(
          color: allcolors.onPrimary,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color:allcolors.onPrimary,
          onPressed: () 
          {
            Navigator.pop(context);
          },
        ),
        title: Text(
          //AppLocalizations.of(context)!.newOrder+"S:${Localizations.localeOf(context).toString()}C:${Localizations.localeOf(context).countryCode}L:${Localizations.localeOf(context).languageCode}",
          AppLocalizations.of(context)!.settingsTitle,
          style: TextStyle(fontWeight: FontWeight.bold,color: allcolors.onPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(
              context.watch<ThemeProvider>().themeMode == ThemeMode.dark
              ? Icons.dark_mode
              : Icons.light_mode,
            ),
            color: allcolors.onPrimary,
            onPressed: () {   

              themeProviderGlobal = context.read<ThemeProvider>();
              tProvider.toggleMode();              
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [            
            // ========== Language SECTION ==========
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.langSettings,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:allcolors.onPrimary,
                ),
              ),
              trailing: Icon(
                _isLangExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              iconColor: allcolors.onPrimary,
              onTap: () {
                setState(() {
                  _isLangExpanded = !_isLangExpanded;
                });
              },
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isLangExpanded ? 200 : 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSettingItem(
                      context,
                      icon: Icons.language,
                      title: AppLocalizations.of(context)!.language,
                      subtitle: langFunc(context),
                      onTap: () {
                        // Handle language change
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.translate,
                      title: AppLocalizations.of(context)!.changeLanguage,
                      //subtitle: 'Production',
                      onTap: () {
                        //_showLanguageDialog(context);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          //Icon(Icons.translate, color: allcolors.secondaryContainer),
                          ////const SizedBox(width: 16),
                          Expanded(
                            child: _buildLanguageDropdown(context,tProvider),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ========== End of Language SECTION ==========
            const Divider(height: 1),            
            // ========== Theme SECTION ==========
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.themeSettings,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:allcolors.onPrimary,
                ),
              ),
              trailing: Icon(
                _isThemeExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              iconColor: allcolors.onPrimary,
              onTap: () {
                setState(() {
                  _isThemeExpanded = !_isThemeExpanded;
                });
              },
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isThemeExpanded ? 200 : 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSettingItem(
                      context,
                      icon: Icons.color_lens,
                      title: AppLocalizations.of(context)!.changeTheme,              
                      onTap: () {
                        // Handle language change
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          //Icon(Icons.translate, color: allcolors.secondaryContainer),
                          //const SizedBox(width: 16),
                          Expanded(
                            child: _buildThemeDropdown(context,tProvider),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // ========== End of Theme SECTION ==========
            const Divider(height: 1),
            // ========== Database SECTION ==========
            ListTile(
              title: Text(
                AppLocalizations.of(context)!.appDatabase,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color:allcolors.onPrimary,
                ),
              ),
              trailing: Icon(
                _isDatabaseExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              iconColor: allcolors.onPrimary,
              onTap: () {
                setState(() {
                  _isDatabaseExpanded = !_isDatabaseExpanded;
                });
              },
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: _isDatabaseExpanded ? 200 : 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSettingItem(
                      context,
                      icon: Icons.maps_home_work,
                      title: _dbPath != null
                      ? _dbPath!
                      : AppLocalizations.of(context)!.loading,              
                      onTap: () {
                        // Handle language change
                      },
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.table_bar,
                      title: AppLocalizations.of(context)!.appTables,              
                      onTap: () {
                        // Handle language change
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          //Icon(Icons.translate, color: allcolors.secondaryContainer),
                          //const SizedBox(width: 16),
                          Expanded(
                            child: _buildDbTablesDropdown(context,tProvider),
                          ),
                        ],
                      ),
                    ),                    
                  ],
                ),
              ),
            ),
            // ========== End of Database SECTION ==========            
          ],
        ),
      ),
    );
  }

  // Helper method to build individual setting items
  Widget _buildSettingItem(    
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final allcolors = Theme.of(context).colorScheme;
    
    return ListTile(
      leading: Icon(
        icon,
        color: allcolors.secondaryContainer,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: allcolors.secondaryContainer,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: allcolors.secondaryContainer,
              ),
            )
          : null,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
    );
  }

  /*void _showLanguageDialog(BuildContext context) {
    List<Locale> languages = langListGlobalGetter;
    final allcolors = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text(AppLocalizations.of(context)!.changeLanguage),
          children: languages.map((locale) {
            return SimpleDialogOption(
              onPressed: () {
                systemLangGlobalSetter = locale.languageCode;
                Navigator.pop(context);
              },
              child: Text(
                langList(context,locale.languageCode),
              ),
            );
          }).toList(),
        );
      },
    );
  }*/
  Widget _buildLanguageDropdown(BuildContext context,ThemeProvider provider) {
    final allcolors = Theme.of(context).colorScheme;
    List<Locale> languages = langListGlobalGetter;
    return DropdownButton2<String>(
      isExpanded: true,
      hint: Text(
        AppLocalizations.of(context)!.searchLanguage,
        style: TextStyle(color: allcolors.secondaryContainer,fontSize: 12),
      ),
      value: provider.locale?.languageCode.toString(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          //systemLangGlobalSetter = newValue;
          provider.setLocale(languages.firstWhere((locale) => locale.languageCode == newValue)); 
          searchController.clear();          
        }
      },
      items: filteredLanguages.map((Locale locale) {
        String langName = langList(context, locale.languageCode);
        return DropdownMenuItem<String>(
          value: locale.languageCode,
          child: Text(langName, style: TextStyle(color: allcolors.secondaryContainer,fontSize: 12),),
        );
      }).toList(),
      buttonStyleData: ButtonStyleData(        
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: allcolors.secondaryContainer),
        ),
      ),  
      iconStyleData: IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        iconEnabledColor: allcolors.secondaryContainer,  // Change to your desired color
        iconDisabledColor:allcolors.onSecondaryContainer,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: allcolors.onSecondaryContainer,
        ),
        offset: const Offset(0, -5),
      ),
      dropdownSearchData: DropdownSearchData(
        searchController: searchController,
        searchInnerWidgetHeight: 50,
        searchInnerWidget: Container(
          height: 50,
          padding: const EdgeInsets.all(4),
          child: TextField(
            expands: true,
            maxLines: null,
            controller: searchController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              hintText: AppLocalizations.of(context)!.searchLanguage,
              hintStyle: TextStyle(color: allcolors.secondaryContainer),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: allcolors.tertiary),
              ),
              prefixIcon: Icon(Icons.search, color: allcolors.secondaryContainer),
            ),
          ),
        ),
        /*searchNoResultsWidget: Padding(
          padding: const EdgeInsets.all(8),
          child: Text('No languages found', style: TextStyle(color: allcolors.secondaryContainer)),
        ),*/
      ),      
    );    
  }

  Widget _buildThemeDropdown(BuildContext context,ThemeProvider provider) {
    final allcolors = Theme.of(context).colorScheme;    
    return DropdownButton2<AppColorScheme>(
      isExpanded: true,      
      value: context.watch<ThemeProvider>().currentScheme,
      onChanged: (scheme) {
        if (scheme != null) {
          //systemLangGlobalSetter = newValue;
          provider.changeScheme(scheme);                    
        }
      },
      items: AppColorScheme.values.map((scheme) {
        return DropdownMenuItem(
          value: scheme,
          child: Text(
            colorList(
              context, 
              scheme.name
            ),
            //scheme.name[0].toUpperCase() + scheme.name.substring(1)
            style: TextStyle(
              color: allcolors.secondaryContainer,
              fontSize: 12
            ),
          ),
        );
      }).toList(),
      buttonStyleData: ButtonStyleData(        
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: allcolors.secondaryContainer),
        ),
      ),  
      iconStyleData: IconStyleData(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        iconEnabledColor: allcolors.secondaryContainer,  // Change to your desired color
        iconDisabledColor:allcolors.onSecondaryContainer,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: allcolors.onSecondaryContainer,
        ),
        offset: const Offset(0, -5),
      ),      
    );    
  } 

  Widget _buildDbTablesDropdown(BuildContext context,ThemeProvider provider) {
    final allcolors = Theme.of(context).colorScheme;    
    return FutureBuilder<List<String>>(
      future: () async {
        final db = await AppDatabase().database; // your DB instance
        return AppDatabase.getTablesUsingPragma(db);
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No tables found');
        } else {
          final tables = snapshot.data!;
          String? selectedTable; // track selected table
          
          return StatefulBuilder(
            builder: (context, setState) {
              return DropdownButton2<String>(
                isExpanded: true,      
                value: selectedTable,   
                hint: Text(
                  AppLocalizations.of(context)!.selectTable,
                  style: TextStyle(
                    color: allcolors.secondaryContainer,
                    fontSize: 12
                  ),             
                ),
                items: tables.map((table) => DropdownMenuItem(
                  value: table,
                  child: Text(
                    table,
                    style: TextStyle(
                      color: allcolors.secondaryContainer,
                      fontSize: 12
                    ),
                  ),
                ))
                .toList(),
                buttonStyleData: ButtonStyleData(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: allcolors.secondaryContainer),
                  ),
                ),  
                iconStyleData: IconStyleData(
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  iconEnabledColor: allcolors.secondaryContainer,  // Change to your desired color
                  iconDisabledColor:allcolors.onSecondaryContainer,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: allcolors.onSecondaryContainer,
                  ),
                  offset: const Offset(0, -5),
                ),
                onChanged: (value) {
                  setState(() {
                    selectedTable = value;
                  });
                },
              );
            },
          );
        }
      },
    );
  }
}
