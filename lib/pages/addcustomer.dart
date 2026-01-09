import 'package:flutter/material.dart';
import 'package:mysys/l10n/app_localizations.dart';
import 'package:mysys/data/myappsettings.dart';
import "../theme/theme_provider.dart";
import 'package:provider/provider.dart';
import 'package:mysys/database/app_database.dart';
import '../models/textsection.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCustomer extends StatefulWidget  {
  const AddCustomer({super.key});
  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _formKey = GlobalKey<FormState>();

  // Customer
  final codeCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final taxCtrl = TextEditingController();
  final creditCtrl = TextEditingController();
  final notesCtrl = TextEditingController();

  // Address
  final addressCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final countryCtrl = TextEditingController();

   // Contact
  final contactNameCtrl = TextEditingController();
  final contactPhoneCtrl = TextEditingController();
  final contactEmailCtrl = TextEditingController();

  bool isActive = true;

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
      padding: const EdgeInsets.symmetric(vertical: 10),
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
        'customer_code': codeCtrl.text,
        'name': nameCtrl.text,
        'phone': phoneCtrl.text,
        'email': emailCtrl.text,
        'tax_number': taxCtrl.text,
        'credit_limit': double.tryParse(creditCtrl.text) ?? 0,
        'is_active': isActive ? 1 : 0,
        'created_at': now,
        'updated_at': now,
      });
      
      if (addressCtrl.text.isNotEmpty) {
        await txn.insert('customer_addresses', {
          'customer_id': customerId,
          'address_line': addressCtrl.text,
          'city': cityCtrl.text,
          'country': countryCtrl.text,
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

  @override
  Widget build(BuildContext context) {  
    final allcolors = Theme.of(context).colorScheme; 
    final tProvider=context.read<ThemeProvider>();   
    themeProviderGlobal = tProvider;     
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
                _input(nameCtrl,allcolors, AppLocalizations.of(context)!.customerName, required: true),
                _input(codeCtrl, allcolors, AppLocalizations.of(context)!.customerCode),
                _input(phoneCtrl, allcolors, AppLocalizations.of(context)!.phone),
                _input(emailCtrl, allcolors, AppLocalizations.of(context)!.email),
                _input(taxCtrl, allcolors, AppLocalizations.of(context)!.taxNumber),
                
                _sectionTitle(AppLocalizations.of(context)!.financial,allcolors),
                _input(creditCtrl, allcolors, AppLocalizations.of(context)!.creditLimit, keyboard: TextInputType.number),
                
                SwitchListTile(
                  title: _sectionTitle(AppLocalizations.of(context)!.active,allcolors),
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
                  //backgroundColor: allcolors.primaryContainer.withAlpha(30),
                  //collapsedBackgroundColor: allcolors.primary,
                  /*shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: allcolors.primaryContainer, width: 0),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: allcolors.primaryContainer, width: 1),
                  ),*/
                  children: [
                    _input(addressCtrl, allcolors, AppLocalizations.of(context)!.addressStreet, keyboard: TextInputType.streetAddress),
                    _input(cityCtrl, allcolors, AppLocalizations.of(context)!.city),
                    _input(countryCtrl, allcolors, AppLocalizations.of(context)!.country),
                  ],
                ),
                
                ExpansionTile(
                  title: _sectionTitle(AppLocalizations.of(context)!.contactName,allcolors),
                  iconColor: allcolors.primaryContainer,
                  collapsedIconColor: allcolors.onPrimary,
                  //backgroundColor: allcolors.primaryContainer.withAlpha(30),
                  //collapsedBackgroundColor: allcolors.primary,
                  /*shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: allcolors.primaryContainer, width: 0),
                  ),
                  collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: allcolors.primaryContainer, width: 1),
                  ),*/
                  children: [
                    _input(contactNameCtrl,allcolors, AppLocalizations.of(context)!.contactPerson),
                    _input(contactPhoneCtrl, allcolors, AppLocalizations.of(context)!.phone),
                    _input(contactEmailCtrl, allcolors, AppLocalizations.of(context)!.email),
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
