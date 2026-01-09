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
import 'package:mysys/pages/addcustomer.dart';
import 'package:url_launcher/url_launcher.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});
  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allCustomers = [];
  List<Map<String, dynamic>> filteredCustomers = [];
  String? selectedCustomerId;
  bool _isCustomerExpanded = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterCustomers);
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final db = await AppDatabase().database;
    final customers = await db.query('customers', where: 'is_active = ?', whereArgs: [1]);
    setState(() {
      allCustomers = customers;
      filteredCustomers = customers;
    });
  }

  void _filterCustomers() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredCustomers = allCustomers;
      } else {
        filteredCustomers = allCustomers
            .where((customer) => customer['name']
                .toString()
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _buildCustomerDropdown(BuildContext context, ThemeProvider provider) {
    final allcolors = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        // Search TextField
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: searchController,
            style: TextStyle(
              color: allcolors.onPrimaryContainer,
              fontSize: 14
            ),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchCustomer,
              hintStyle: TextStyle(color: allcolors.secondaryContainer.withAlpha(150)),
              prefixIcon: Icon(Icons.search, color: allcolors.secondaryContainer),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: allcolors.primaryContainer),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: allcolors.secondary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
        // Customer List
        Expanded(
          child: filteredCustomers.isEmpty
          ? Center(
            child: Text(
              AppLocalizations.of(context)!.noCustomersFound,
              style: TextStyle(color: allcolors.error, fontSize: 14),
            ),
          )
          : ListView.builder(
            itemCount: filteredCustomers.length,
            itemBuilder: (context, index) {
              final customer = filteredCustomers[index];
              final isSelected = selectedCustomerId == customer['id'].toString();
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: isSelected
                    ? allcolors.primaryContainer.withAlpha(150)
                    : allcolors.primaryContainer.withAlpha(30),
                    border: Border.all(
                      color: isSelected
                      ? allcolors.secondary
                      : allcolors.primaryContainer,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    leading: Icon(
                      Icons.corporate_fare,
                      color: isSelected
                      ? allcolors.secondary
                      : allcolors.secondaryContainer,
                      size: 20,
                    ),
                    title: Text(
                      customer['name'] ?? 'Unknown',
                      style: TextStyle(
                        color: allcolors.onPrimaryContainer,
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: customer['phone'] != null
                    ? InkWell(
                      onTap: () async {
                        final phoneNumber = customer['phone'];
                        final uri = Uri(scheme: 'tel', path: phoneNumber);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: allcolors.secondaryContainer.withAlpha(150),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            customer['phone'],
                            style: TextStyle(
                              color: allcolors.secondaryContainer.withAlpha(150),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    )
                    : null,
                    trailing: isSelected
                    ? Icon(Icons.check_circle, color: allcolors.secondary)
                    : null,
                    onTap: () {
                      setState(() {
                        selectedCustomerId = customer['id'].toString();
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
          AppLocalizations.of(context)!.customers,
          style: TextStyle(fontWeight: FontWeight.bold,color: allcolors.onPrimary),
        ),
        actions: [          
          IconButton(
            icon: Icon(Icons.group_add),
            color: allcolors.onPrimary,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute<bool>(
                  builder: (context) => const AddCustomer(),
                ),
              );
              // Reload customers if a new one was added
              if (result == true) {
                _loadCustomers();
              }
            },
          ),
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
      body: Container(
        color:allcolors.primary,
        child: _buildCustomerDropdown(context,tProvider)
      ),
    );
  }
}
