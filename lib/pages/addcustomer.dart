import 'package:flutter/material.dart';
import 'package:mysys/l10n/app_localizations.dart';
import 'package:mysys/data/myappsettings.dart';
import "../theme/theme_provider.dart";
import 'package:provider/provider.dart';
import 'package:mysys/database/app_database.dart';
import '../models/textsection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import '../data/mygeolocator.dart';
import 'package:geocoding/geocoding.dart';


class AddCustomer extends StatefulWidget  {
  const AddCustomer({super.key});
  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _formKey = GlobalKey<FormState>();
  double? latitude;
  double? longitude;
  bool _name2ManuallyEdited = false;

  // Customer
  final name2Ctrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final taxCtrl = TextEditingController();
  //final mapCtrl = TextEditingController();
  final creditCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  // Address
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final countryCtrl = TextEditingController();

   // Contact
  final contactNameCtrl = TextEditingController();
  final contactPhoneCtrl = TextEditingController();
  final contactEmailCtrl = TextEditingController(); 
  
  bool isActive = true;

  @override
  void initState() {
    super.initState();    
    getAddress();    
  }  

  void _showMsg(String msg, ColorScheme allcolors)
  {
    Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT, // or Toast.LENGTH_LONG
    gravity: ToastGravity.CENTER, // or TOP, BOTTOM, etc.
    timeInSecForIosWeb: 1, // duration for iOS/web
    backgroundColor: allcolors.primaryContainer,
    textColor: allcolors.onPrimaryContainer,
    fontSize: 16.0);
  }

  Widget _sectionTitle(String title, ColorScheme colors) {    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color:colors.onPrimary,
        ),
      ),
    );
  }

  Future<void> _saveCustomer() async {
    if (!_formKey.currentState!.validate()) return;
    
    final db = await AppDatabase().database;
    final now = DateTime.now().toIso8601String();
    
    await db.transaction((txn) async {
      final customerId = await txn.insert('customers', {        
        'name': nameCtrl.text,
        'name2': name2Ctrl.text.isEmpty ? nameCtrl.text : name2Ctrl.text,
        'phone': phoneCtrl.text,
        'email': emailCtrl.text,
        'tax_number': taxCtrl.text,
        'credit_limit': double.tryParse(creditCtrl.text) ?? 0,
        'is_active': isActive ? 1 : 0,
        'notes': notesCtrl.text,        
        'created_at': now,
        'updated_at': now,
      });
      
      if (addressCtrl.text.isNotEmpty) {
        await txn.insert('customer_addresses', {
          'customer_id': customerId,
          'address_line': addressCtrl.text,
          'city': cityCtrl.text,
          'state': stateCtrl.text,
          'country': countryCtrl.text,
          'latitude': latitude,
          'longitude': longitude,
          'is_default': 1,
        });
      }
      
      if (contactNameCtrl.text.isNotEmpty) {
        await txn.insert('customer_contacts', {
          'customer_id': customerId,
          'name': contactNameCtrl.text,
          'phone': contactPhoneCtrl.text,
          'email': contactEmailCtrl.text,
        });
      }
    });
    _showMsg(AppLocalizations.of(context)!.custSavedMsg, Theme.of(context).colorScheme);
    Navigator.pop(context, true);
  }

  Widget _input(    
    TextEditingController controller,
    ColorScheme colors,
    String label, {
      bool required = false,
      TextInputType keyboard = TextInputType.text,
      List<TextInputFormatter>? inputFormatters,
    }
  ){
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextSelectionTheme(
        data: TextSelectionThemeData(
          selectionColor: colors.secondaryContainer.withAlpha(50),
          selectionHandleColor: colors.secondaryContainer.withAlpha(100),
          cursorColor: colors.secondaryContainer.withAlpha(200),
        ),
        child: TextFormField(
          style: TextStyle(
            color: colors.onPrimaryContainer,
            fontSize: 14,
          ),
          controller: controller,
          keyboardType: keyboard,
          inputFormatters: inputFormatters,
          validator: required
          ? (v) => v == null || v.isEmpty ? 'Required' : null
          : null,
          decoration: InputDecoration(
            labelText: label,                    
            labelStyle: TextStyle(
              fontSize: 14,
              color: colors.primaryContainer,
            ),
            floatingLabelStyle: TextStyle(
              fontSize: 14,
              color: colors.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
            hintStyle: TextStyle(
              fontSize: 13,
              color: colors.tertiary.withAlpha(150),
            ),
            errorStyle: TextStyle(
              fontSize: 12,
              color: colors.error,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color:colors.primaryContainer, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color:colors.primaryContainer.withAlpha(150), width: 3),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.error,width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.error.withAlpha(150), width: 3),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color:colors.primaryContainer.withAlpha(50)),
            ),
          ),
        ),
      ),
    );
  }
  
  Future<void> getAddress() async {
    final pos = await getCurrentLocation();
    latitude=pos.latitude;
    longitude=pos.longitude;
    final placemarks =
    await placemarkFromCoordinates(pos.latitude, pos.longitude);
    final place = placemarks.first;     
    setState(() {  
      String addr='';    
      if(place.street!=null && place.street!.isNotEmpty)
      {
        addr='${place.street}';
      }    
      if(place.postalCode!=null && place.postalCode!.isNotEmpty)
      {
        addr+=', ${place.postalCode}';
      }
      if(place.thoroughfare!=null && place.thoroughfare!.isNotEmpty)
      {
        addr+=', ${place.thoroughfare}';
      }
      if(place.subThoroughfare!=null && place.subThoroughfare!.isNotEmpty)
      {
        addr+=', ${place.subThoroughfare}';
      }
      if(place.name!=null && place.name!.isNotEmpty)
      {
        addr+=', ${place.name}';
      }
      if(place.subLocality!=null && place.subLocality!.isNotEmpty)
      {
        addr+=', ${place.subLocality}';
      }
      addressCtrl.text=addr;
      cityCtrl.text='${place.locality}';
      stateCtrl.text='${place.administrativeArea}';
      countryCtrl.text='${place.country}';      
      print(addressCtrl.text+","+cityCtrl.text+","+stateCtrl.text+","+countryCtrl.text);
    });    
  }

  @override
  Widget build(BuildContext context) {  
    final allcolors = Theme.of(context).colorScheme; 
    final tProvider=context.read<ThemeProvider>();   
    themeProviderGlobal = tProvider;     
    //getAddress();    
    return Scaffold(
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
          AppLocalizations.of(context)!.addCustomer,
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
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color:allcolors.primary,
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                _sectionTitle(AppLocalizations.of(context)!.basicInfo,allcolors),
                _input(nameCtrl,allcolors, AppLocalizations.of(context)!.customerName, required: true, keyboard: TextInputType.name),
                _input(name2Ctrl, allcolors, AppLocalizations.of(context)!.customerName2, keyboard: TextInputType.name),
                _input(
                  phoneCtrl, 
                  allcolors, 
                  AppLocalizations.of(context)!.phone, 
                  keyboard: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                _input(emailCtrl, allcolors, AppLocalizations.of(context)!.email, keyboard: TextInputType.emailAddress),
                _input(taxCtrl, allcolors, AppLocalizations.of(context)!.taxNumber, keyboard: TextInputType.text),
                _input(notesCtrl, allcolors, AppLocalizations.of(context)!.notes),
                
                _sectionTitle(AppLocalizations.of(context)!.financial,allcolors),
                _input(
                  creditCtrl, 
                  allcolors, 
                  AppLocalizations.of(context)!.creditLimit, 
                  keyboard: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),

                //_input(mapCtrl, allcolors, AppLocalizations.of(context)!.mapAddress),
                
                SwitchListTile(
                  title: isActive ? _sectionTitle(AppLocalizations.of(context)!.active,allcolors) : _sectionTitle(AppLocalizations.of(context)!.inactive,allcolors),
                  value: isActive,
                  onChanged: (v) => setState(() => isActive = v),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                  tileColor: isActive ? allcolors.secondary.withAlpha(50) : allcolors.primaryContainer.withAlpha(30),
                  selectedTileColor: allcolors.secondary.withAlpha(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                      color: isActive ? allcolors.secondary : allcolors.primaryContainer, 
                      width: isActive ? 2 : 1,
                    ),
                  ),                  
                  activeColor: allcolors.onPrimary,
                  inactiveThumbColor: allcolors.onPrimaryContainer,
                  inactiveTrackColor: allcolors.primaryContainer.withAlpha(100),
                  hoverColor: allcolors.secondaryContainer.withAlpha(50),
                ),
                
                ExpansionTile(
                  title: _sectionTitle(AppLocalizations.of(context)!.address,allcolors),
                  iconColor: allcolors.primaryContainer,
                  collapsedIconColor: allcolors.onPrimary,
                  children: [
                    _input(addressCtrl, allcolors, AppLocalizations.of(context)!.addressStreet, keyboard: TextInputType.streetAddress),
                    _input(cityCtrl, allcolors, AppLocalizations.of(context)!.city),
                    _input(stateCtrl, allcolors, AppLocalizations.of(context)!.state),
                    _input(countryCtrl, allcolors, AppLocalizations.of(context)!.country),
                  ],
                ),
                
                ExpansionTile(
                  title: _sectionTitle(AppLocalizations.of(context)!.contactName,allcolors),
                  iconColor: allcolors.primaryContainer,
                  collapsedIconColor: allcolors.onPrimary,
                  children: [
                    _input(contactNameCtrl,allcolors, AppLocalizations.of(context)!.contactPerson, keyboard: TextInputType.name),
                    _input(contactPhoneCtrl, allcolors, AppLocalizations.of(context)!.phone, keyboard: TextInputType.phone),
                    _input(contactEmailCtrl, allcolors, AppLocalizations.of(context)!.email, keyboard: TextInputType.emailAddress),
                  ],
                ),
                
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allcolors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Change the curve here
                    ),
                  ),
                  onPressed: _saveCustomer,
                  child:TextSection(
                    description: AppLocalizations.of(context)!.saveCustomer,
                    textFontSize: 16,
                    textColor:allcolors.onSecondary,
                    textFontWeight: FontWeight.w800
                  ),
                  
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }
}
