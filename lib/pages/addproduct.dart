import 'package:flutter/material.dart';
import 'package:mysys/database/app_database.dart';
import 'package:mysys/database/warehouse_data.dart';
import 'package:mysys/pages/addwarehouse.dart';
import 'package:mysys/data/myappsettings.dart';
import "../theme/theme_provider.dart";
import 'package:provider/provider.dart';
import 'package:mysys/l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import '../models/textsection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../widgets/barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}
class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  // Basic
  final nameCtrl = TextEditingController();
  final name2Ctrl = TextEditingController();
  final barCodeCtrl = TextEditingController();
  //final skuCtrl = TextEditingController();
  final costCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final totalPriceCtrl = TextEditingController();
  final productVatCtrl = TextEditingController(text:'15');
  bool isActive = true;
  
  // Flag to prevent listener loops
  bool _isUpdatingPrice = false;

  // Inventory
  final stockCtrl = TextEditingController();

  //warehouses list
  List<Warehouse> warehouses = [];
  
  // Options
  bool hasVariants = false;
  int? categoryId;
  int? brandId;
  Warehouse? selectedTable;

    @override
  void initState() {
    super.initState();
    _loadWarehouses();  // Call on page load
    
    // Add listeners to auto-calculate total price with tax
    priceCtrl.addListener(_calculateTotalWithTax);
    productVatCtrl.addListener(_calculateTotalWithTax);
    
    // Add listener to reverse-calculate selling price when total changes
    totalPriceCtrl.addListener(_calculateSellingPriceFromTotal);
  }
  
  @override
  void dispose() {
    priceCtrl.removeListener(_calculateTotalWithTax);
    productVatCtrl.removeListener(_calculateTotalWithTax);
    totalPriceCtrl.removeListener(_calculateSellingPriceFromTotal);
    nameCtrl.dispose();
    name2Ctrl.dispose();
    barCodeCtrl.dispose();
    costCtrl.dispose();
    priceCtrl.dispose();
    totalPriceCtrl.dispose();
    productVatCtrl.dispose();
    stockCtrl.dispose();
    super.dispose();
  }
  
  /// Calculate total price with tax
  /// Formula: totalPrice = sellingPrice + (sellingPrice * VAT/100)
  void _calculateTotalWithTax() {
    if (_isUpdatingPrice) return; // Prevent loop
    
    _isUpdatingPrice = true;
    final sellingPrice = double.tryParse(priceCtrl.text) ?? 0.0;
    final vatPercentage = double.tryParse(productVatCtrl.text) ?? 0.0;
    
    final totalWithTax = sellingPrice + (sellingPrice * vatPercentage / 100);
    
    // Update the totalPriceCtrl without triggering listener loop
    totalPriceCtrl.text = totalWithTax.toStringAsFixed(2);
    _isUpdatingPrice = false;
  }
  
  /// Reverse-calculate selling price from total price with tax
  /// Formula: sellingPrice = totalPrice / (1 + VAT/100)
  void _calculateSellingPriceFromTotal() {
    if (_isUpdatingPrice) return; // Prevent loop
    
    _isUpdatingPrice = true;
    final totalPrice = double.tryParse(totalPriceCtrl.text) ?? 0.0;
    final vatPercentage = double.tryParse(productVatCtrl.text) ?? 0.0;
    
    // Avoid division by zero
    final vatFactor = 1 + (vatPercentage / 100);
    if (vatFactor > 0) {
      final sellingPrice = totalPrice / vatFactor;
      priceCtrl.text = sellingPrice.toStringAsFixed(2);
    }
    _isUpdatingPrice = false;
  }
  
  /// Get total price with tax (returns double)
  double getTotalPriceWithTax() {
    final sellingPrice = double.tryParse(priceCtrl.text) ?? 0.0;
    final vatPercentage = double.tryParse(productVatCtrl.text) ?? 0.0;
    return sellingPrice + (sellingPrice * vatPercentage / 100);
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
          AppLocalizations.of(context)!.addProduct,
          style: TextStyle(fontWeight: FontWeight.bold,color: allcolors.onPrimary),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.warehouse),
            color: allcolors.onPrimary,
            onPressed: () async {
              _addWarehouses();
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
                  _section(AppLocalizations.of(context)!.basicInfo,allcolors),
                  _field(nameCtrl, allcolors, AppLocalizations.of(context)!.productName, required: true, keyboard: TextInputType.name),
                  _field(name2Ctrl, allcolors, AppLocalizations.of(context)!.productName2, keyboard: TextInputType.name),
                  _field(barCodeCtrl, allcolors, AppLocalizations.of(context)!.barcodeText, keyboard: TextInputType.text),                  
                  // Add a button to scan barcode
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: allcolors.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Change the curve here
                      ),
                    ),
                    onPressed: () async {
                      final barcode = await Navigator.push<String>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarcodeScanner(
                            onBarcodeDetected: (value) {                              
                            },
                            title: AppLocalizations.of(context)!.barcodeTitle,
                          ),
                        ),
                      );
                      
                      if (barcode != null) {
                        setState(() {
                          barCodeCtrl.text = barcode;
                        });
                      }
                    },
                    child:
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.qr_code_2, color: allcolors.onSecondary),
                          TextSection(
                            description: AppLocalizations.of(context)!.barcodeTitle,
                            textFontSize: 16,
                            textColor: allcolors.onSecondary,
                            textFontWeight: FontWeight.w800
                          ),
                        ],                    
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //_field(skuCtrl, allcolors, AppLocalizations.of(context)!.sku, keyboard: TextInputType.name),
                  _field(
                    costCtrl, 
                    allcolors, 
                    AppLocalizations.of(context)!.costPrice, 
                    keyboard: TextInputType.number,
                    /*inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],*/
                  ),
                  _field(
                    priceCtrl, 
                    allcolors, 
                    AppLocalizations.of(context)!.sellingPrice, 
                    keyboard: TextInputType.number,
                    /*inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],*/
                  ),
                  _field(
                    productVatCtrl, 
                    allcolors, 
                    AppLocalizations.of(context)!.productVat, 
                    keyboard: TextInputType.number,
                    /*inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],*/
                  ),
                  _field(
                    totalPriceCtrl, 
                    allcolors, 
                    AppLocalizations.of(context)!.totalWithTaxPrice, 
                    keyboard: TextInputType.number,
                    /*inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],*/
                  ),
                  _section(AppLocalizations.of(context)!.warehouses,allcolors),              
                  DropdownButton2<Warehouse>(
                    isExpanded: true,   
                    value: selectedTable,   
                    hint: Text(
                      AppLocalizations.of(context)!.selectWarehouse,
                      style: TextStyle(
                        color: allcolors.secondaryContainer,
                        fontSize: 12
                      ),
                    ),
                    items: warehouses.map((Warehouse warehouse) {
                      return DropdownMenuItem<Warehouse>(
                        value: warehouse,
                        child: Text(
                          warehouse.name,
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
                    onChanged: (Warehouse? value) {
                      setState(() {
                        selectedTable = value;
                      });
                    },
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
                    onPressed: _addWarehouses,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.warehouse, color: allcolors.onSecondary),                          
                          TextSection(
                            description: AppLocalizations.of(context)!.addWarehouse,
                            textFontSize: 16,
                            textColor: allcolors.onSecondary,
                            textFontWeight: FontWeight.w800
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile(
                  title: isActive ? _section(AppLocalizations.of(context)!.active,allcolors) : _section(AppLocalizations.of(context)!.inactive,allcolors),
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
                  /*_section(AppLocalizations.of(context)!.options,allcolors),
                  SwitchListTile(
                    title: const Text('Has Variants'),
                    value: hasVariants,
                    onChanged: (v) => setState(() => hasVariants = v),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    tileColor: hasVariants ? allcolors.secondary.withAlpha(50) : allcolors.primaryContainer.withAlpha(30),
                    selectedTileColor: allcolors.secondary.withAlpha(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: hasVariants ? allcolors.secondary : allcolors.primaryContainer, 
                        width: hasVariants ? 2 : 1,
                      ),
                    ),
                    activeColor: allcolors.onPrimary,
                    inactiveThumbColor: allcolors.onPrimaryContainer,
                    inactiveTrackColor: allcolors.primaryContainer.withAlpha(100),
                    hoverColor: allcolors.secondaryContainer.withAlpha(50),                     
                  ),*/

                  if (!hasVariants)
                    _section(AppLocalizations.of(context)!.inventory,allcolors),
                    _field(
                      stockCtrl, 
                      allcolors, 
                      AppLocalizations.of(context)!.openingStock, 
                      keyboard: TextInputType.number, 
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ]),
                  if (hasVariants)
                    ExpansionTile(
                      title: Text(AppLocalizations.of(context)!.variants),
                      iconColor: allcolors.primaryContainer,
                      collapsedIconColor: allcolors.onPrimary,
                      children: [
                        // dynamic variant rows
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
                    onPressed: _saveProduct,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: allcolors.onSecondary),
                        const SizedBox(width: 8), // Space between icon and text
                        TextSection(
                          description: AppLocalizations.of(context)!.addProduct,
                          textFontSize: 16,
                          textColor: allcolors.onSecondary,
                          textFontWeight: FontWeight.w800
                        ),
                      ],
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
  Widget _field(
    TextEditingController controller,
    ColorScheme colors,
      String label, {
        bool required = false,        
        TextInputType keyboard = TextInputType.text,
        List<TextInputFormatter>? inputFormatters,
      }
    ) {
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

  Widget _section(String title, ColorScheme colors) {
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

  Future<void> _loadWarehouses() async {
    final warehouseList = await AppDatabase().getWarehouses();
    if (warehouseList.isEmpty) {
      // Navigate to AddWarehouse page and wait for result
      if (mounted) {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (context) => const AddWarehouse()),
        );
        // If warehouse was added, reload the list
        if (result == true && mounted) {
          _loadWarehouses(); // Recursively reload
        }
      }
      return;
    }
    setState(() {
      warehouses = warehouseList;
    });    
  }

  Future<void> _addWarehouses() async {
    final warehouseList = await AppDatabase().getWarehouses();
    if (warehouseList.isNotEmpty) {
      // Navigate to AddWarehouse page and wait for result
      if (mounted) {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (context) => const AddWarehouse()),
        );
        // If warehouse was added, reload the list
        if (result == true && mounted) {
          _loadWarehouses(); // Recursively reload
        }
      }
      return;
    }
    setState(() {
      warehouses = warehouseList;
    });    
  }

  Future<void> _saveProduct() async {
    final warehouseList = await AppDatabase().getWarehouses();
    if (warehouseList.isEmpty) {
      // Navigate to AddWarehouse page and wait for result
      if (mounted) {
        final result = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (context) => const AddWarehouse()),
        );
        // If warehouse was added, reload the list
        if (result == true && mounted) {
          await _loadWarehouses();
        }
      }
      return;
    }
    
    if (!_formKey.currentState!.validate()) return;

    final db = await AppDatabase().database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      final productId = await txn.insert('products', {
        'name': nameCtrl.text,
        'name2': name2Ctrl.text,
        //'sku': skuCtrl.text,
        'cost_price': double.tryParse(costCtrl.text) ?? 0,
        'selling_price': double.tryParse(priceCtrl.text) ?? 0,
        'is_active': isActive ? 1 : 0,
        'created_at': now,
        'updated_at': now,
      });

      if (!hasVariants) {        
        await txn.insert('inventory', {
          'product_id': productId,
          'warehouse_id': warehouses.first.id,
          'quantity': double.tryParse(stockCtrl.text) ?? 0,
        });
      }

      if (barCodeCtrl.text.isNotEmpty) {        
        await txn.insert('product_barcodes', {
          'product_id': productId,
          'barcode': barCodeCtrl.text.trim(),
        });
      }

      // Variants saving logic here if enabled
    });
    _showMsg(AppLocalizations.of(context)!.productSavedMsg, Theme.of(context).colorScheme);
    Navigator.pop(context, true);
  }
 
}

