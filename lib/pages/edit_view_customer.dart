import 'package:flutter/material.dart';
import 'package:mysys/l10n/app_localizations.dart';
import 'package:mysys/data/myappsettings.dart';
import "../theme/theme_provider.dart";
import 'package:provider/provider.dart';
import 'package:mysys/database/app_database.dart';
import '../models/textsection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:mysys/data/mapdrawhelper.dart';
import 'package:mysys/data/freemapwidget.dart';

class EditViewCustomer extends StatefulWidget {
  final int? customerId;
  const EditViewCustomer({super.key, this.customerId});
  @override
  State<EditViewCustomer> createState() => _EditViewCustomerState();
}

class _EditViewCustomerState extends State<EditViewCustomer> {
  final _formKey = GlobalKey<FormState>();

  // Customer  
  final nameCtrl = TextEditingController();
  final name2Ctrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final taxCtrl = TextEditingController();
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

  String currentAddress=""; 
  double currentLat=0.0;
  double currentLng=0.0;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.customerId != null) {
      _loadCustomer();
    }
  }

  Future<LatLngResult> addressToLatLng(String address) async {
  List<Location> locations = await locationFromAddress(address);

  final location = locations.first;

  return LatLngResult(
    latitude: location.latitude.toDouble(),
    longitude: location.longitude.toDouble(),
  );
}

  Future<void> _loadCustomer() async {
    final db = await AppDatabase().database;
    final customers = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [widget.customerId],
    );
    
    if (customers.isNotEmpty) {
      final customer = customers.first;
      setState(() {        
        nameCtrl.text = (customer['name'] as String?) ?? '';
        name2Ctrl.text = (customer['name2'] as String?) ?? '';
        phoneCtrl.text = (customer['phone'] as String?) ?? '';
        emailCtrl.text = (customer['email'] as String?) ?? '';
        taxCtrl.text = (customer['tax_number'] as String?) ?? '';
        creditCtrl.text = (customer['credit_limit'] ?? 0).toString();
        notesCtrl.text = (customer['notes'] as String?) ?? '';
        isActive = (customer['is_active'] as int?) == 1;
      });
      _loadAddresses();
      _loadContacts();
    }
  }

  Future<void> _loadAddresses() async {
    final db = await AppDatabase().database;
    final addresses = await db.query(
      'customer_addresses',
      where: 'customer_id = ? AND is_default = ?',
      whereArgs: [widget.customerId, 1],
    );
    
    if (addresses.isNotEmpty) {
      final address = addresses.first;
      final addressLine = (address['address_line'] as String?) ?? '';
      final city = (address['city'] as String?) ?? '';
      final state = (address['state'] as String?) ?? '';
      final country = (address['country'] as String?) ?? '';
      
      currentLng = (address['longitude'] as num?)?.toDouble() ?? 0.0;
      currentLat = (address['latitude'] as num?)?.toDouble() ?? 0.0;
      
      final fullAddress = '$addressLine, $city, $state, $country';
      final result = await addressToLatLng(fullAddress);
      
      if (mounted) {
        setState(() {
          addressCtrl.text = addressLine;
          cityCtrl.text = city;
          stateCtrl.text = state;
          countryCtrl.text = country;
          if (currentLat < -90 && currentLat > 90 && currentLat == 0.0) 
          {
            currentLat = (result.latitude is num) ? result.latitude.toDouble() : result.latitude;
          }
          
          if(currentLng < -180 && currentLng > 180 && currentLng == 0.0)
          {
            currentLng = (result.longitude is num) ? result.longitude.toDouble() : result.longitude;
          }          
        });
        print('Lat: ${currentLat}');
        print('Lng: ${currentLng}');
      }
    }
  }

  Future<void> _loadContacts() async {
    final db = await AppDatabase().database;
    final contacts = await db.query(
      'customer_contacts',
      where: 'customer_id = ?',
      whereArgs: [widget.customerId],
    );
    
    if (contacts.isNotEmpty) {
      final contact = contacts.first;
      setState(() {
        contactNameCtrl.text = (contact['name'] as String?) ?? '';
        contactPhoneCtrl.text = (contact['phone'] as String?) ?? '';
        contactEmailCtrl.text = (contact['email'] as String?) ?? '';
      });
    }
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

  Future<void> _updateCustomer() async {
    if (!_formKey.currentState!.validate()) return;
    
    final db = await AppDatabase().database;
    final now = DateTime.now().toIso8601String();
    
    await db.transaction((txn) async {
      if (widget.customerId != null && widget.customerId.toString().trim().isNotEmpty) {
        // Update existing customer
        await txn.update(
          'customers',
          {            
            'name': nameCtrl.text,
            'name2': name2Ctrl.text,
            'phone': phoneCtrl.text,
            'email': emailCtrl.text,
            'tax_number': taxCtrl.text,
            'credit_limit': double.tryParse(creditCtrl.text) ?? 0,
            'notes': notesCtrl.text,
            'is_active': isActive ? 1 : 0,
            'updated_at': now,
          },
          where: 'id = ?',
          whereArgs: [widget.customerId],
        );
        
        // Update address
        if (addressCtrl.text.isNotEmpty) {
          final existingAddresses = await txn.query(
            'customer_addresses',
            where: 'customer_id = ? AND is_default = ?',
            whereArgs: [widget.customerId, 1],
          );
          
          if (existingAddresses.isNotEmpty) {
            await txn.update(
              'customer_addresses',
              {
                'address_line': addressCtrl.text,
                'city': cityCtrl.text,
                'state': stateCtrl.text,
                'country': countryCtrl.text,
              },
              where: 'customer_id = ? AND is_default = ?',
              whereArgs: [widget.customerId, 1],
            );
          } else {
            await txn.insert('customer_addresses', {
              'customer_id': widget.customerId,
              'address_line': addressCtrl.text,
              'city': cityCtrl.text,
              'state': stateCtrl.text,
              'country': countryCtrl.text,
              'is_default': 1,
            });
          }
        }
        
        // Update contact
        if (contactNameCtrl.text.isNotEmpty) {
          final existingContacts = await txn.query(
            'customer_contacts',
            where: 'customer_id = ?',
            whereArgs: [widget.customerId],
          );
          
          if (existingContacts.isNotEmpty) {
            await txn.update(
              'customer_contacts',
              {
                'name': contactNameCtrl.text,
                'phone': contactPhoneCtrl.text,
                'email': contactEmailCtrl.text,
              },
              where: 'customer_id = ?',
              whereArgs: [widget.customerId],
            );
          } else {
            await txn.insert('customer_contacts', {
              'customer_id': widget.customerId,
              'name': contactNameCtrl.text,
              'phone': contactPhoneCtrl.text,
              'email': contactEmailCtrl.text,
            });
          }
        }
      } else {
        // Create new customer
        final customerId = await txn.insert('customers', {          
          'name': nameCtrl.text,
          'name2': name2Ctrl.text,
          'phone': phoneCtrl.text,
          'email': emailCtrl.text,
          'tax_number': taxCtrl.text,
          'credit_limit': double.tryParse(creditCtrl.text) ?? 0,
          'notes': notesCtrl.text,
          'is_active': isActive ? 1 : 0,
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
          AppLocalizations.of(context)!.viewEditCustomer,
          style: TextStyle(fontWeight: FontWeight.bold,color: allcolors.onPrimary,fontSize: 15),
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
                _input(name2Ctrl, allcolors, AppLocalizations.of(context)!.customerName2),
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
                _input(taxCtrl, allcolors, AppLocalizations.of(context)!.taxNumber),
                
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

                _input(notesCtrl, allcolors, AppLocalizations.of(context)!.notes),
                
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
                    FreeMapWidget(
                      latitude: currentLat,
                      longitude: currentLng,
                      zoom: 16.0,
                      markerLabel: AppLocalizations.of(context)!.customerLocation,
                    ),
                  ],
                ),
                
                ExpansionTile(
                  title: _sectionTitle(AppLocalizations.of(context)!.contactName,allcolors),
                  iconColor: allcolors.primaryContainer,
                  collapsedIconColor: allcolors.onPrimary,
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
                  onPressed: _updateCustomer,
                  child:TextSection(
                    description: AppLocalizations.of(context)!.updateCustomer,
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
