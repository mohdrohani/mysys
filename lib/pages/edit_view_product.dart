import 'package:flutter/material.dart';
import 'package:mysys/l10n/app_localizations.dart';
import 'package:mysys/data/myappsettings.dart';
import "../theme/theme_provider.dart";
import 'package:provider/provider.dart';
import 'package:mysys/database/app_database.dart';
import '../models/textsection.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:mysys/database/warehouse_data.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class EditViewProduct extends StatefulWidget {
  final int? productId;
  const EditViewProduct({super.key, this.productId});
  @override
  State<EditViewProduct> createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  final _formKey = GlobalKey<FormState>();
  //warehouses list
  List<Warehouse> warehouses = [];

  // Product
  final nameCtrl = TextEditingController();
  final skuCtrl = TextEditingController();
  //final descriptionCtrl = TextEditingController();
  final costPriceCtrl = TextEditingController();
  final sellingPriceCtrl = TextEditingController();
  //final categoryCtrl = TextEditingController();
  //final brandCtrl = TextEditingController();
  final stockCtrl = TextEditingController();

  bool isActive = true;
  bool stockTracking = true;

  // Options
  bool hasVariants = false;
  int? categoryId;
  int? brandId;
  Warehouse? selectedTable;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProduct();
    }
  }

  Future<void> _loadProduct() async {
    final db = await AppDatabase().database;
    final products = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [widget.productId],
    );
    
    if (products.isNotEmpty) {
      final product = products.first;
      setState(() {
        nameCtrl.text = (product['name'] as String?) ?? '';
        skuCtrl.text = (product['sku'] as String?) ?? '';
        //descriptionCtrl.text = (product['description'] as String?) ?? '';
        costPriceCtrl.text = (product['cost_price'] ?? 0).toString();
        sellingPriceCtrl.text = (product['selling_price'] ?? 0).toString();
        //categoryCtrl.text = (product['category_id'] ?? '').toString();
        //brandCtrl.text = (product['brand_id'] ?? '').toString();
        isActive = (product['is_active'] as int?) == 1;
        stockTracking = (product['stock_tracking'] as int?) == 1;
      });
    }
  }

  void _showMsg(String msg, ColorScheme allcolors) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: allcolors.primaryContainer,
      textColor: allcolors.onPrimaryContainer,
      fontSize: 16.0,
    );
  }

  Widget _sectionTitle(String title, ColorScheme colors) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: colors.onPrimary,
        ),
      ),
    );
  }

  Future<void> _updateProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await AppDatabase().database;
    final now = DateTime.now().toIso8601String();

    await db.transaction((txn) async {
      if (widget.productId != null &&
          widget.productId.toString().trim().isNotEmpty) {
        // Update existing product
        await txn.update(
          'products',
          {
            'name': nameCtrl.text,
            'sku': skuCtrl.text,
            //'description': descriptionCtrl.text,
            'cost_price': double.tryParse(costPriceCtrl.text) ?? 0,
            'selling_price': double.tryParse(sellingPriceCtrl.text) ?? 0,
            //'category_id':
            //    int.tryParse(categoryCtrl.text) ?? 0,
            //'brand_id': int.tryParse(brandCtrl.text) ?? 0,
            //'is_active': isActive ? 1 : 0,
            //'stock_tracking': stockTracking ? 1 : 0,
            'updated_at': now,
          },
          where: 'id = ?',
          whereArgs: [widget.productId],
        );
      } else {
        // Create new product
        await txn.insert('products', {
          'name': nameCtrl.text,
          'sku': skuCtrl.text,
          //'description': descriptionCtrl.text,
          'cost_price': double.tryParse(costPriceCtrl.text) ?? 0,
          'selling_price': double.tryParse(sellingPriceCtrl.text) ?? 0,
          //'category_id': int.tryParse(categoryCtrl.text) ?? 0,
          //'brand_id': int.tryParse(brandCtrl.text) ?? 0,
          //'is_active': isActive ? 1 : 0,
          //'stock_tracking': stockTracking ? 1 : 0,
          'created_at': now,
          'updated_at': now,
        });
      }
    });
    _showMsg(AppLocalizations.of(context)!.productSavedMsg ??
        'Product saved successfully',
        Theme.of(context).colorScheme);
    Navigator.pop(context, true);
  }

  Widget _input(
    TextEditingController controller,
    ColorScheme colors,
    String label, {
    bool required = false,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
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
              borderSide: BorderSide(color: colors.primaryContainer, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: colors.primaryContainer.withAlpha(150), width: 3),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.error, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: colors.error.withAlpha(150), width: 3),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.primaryContainer.withAlpha(50)),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    skuCtrl.dispose();
    //descriptionCtrl.dispose();
    costPriceCtrl.dispose();
    sellingPriceCtrl.dispose();
    //categoryCtrl.dispose();
    //brandCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allcolors = Theme.of(context).colorScheme;
    final tProvider = context.read<ThemeProvider>();
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
          color: allcolors.onPrimary,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.viewEditProduct,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: allcolors.onPrimary, fontSize: 15),
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
            color: allcolors.primary,
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _sectionTitle(AppLocalizations.of(context)!.basicInfo, allcolors),
                  _input(nameCtrl, allcolors,
                      AppLocalizations.of(context)!.productName,
                      required: true, keyboard: TextInputType.name),
                  _input(
                    skuCtrl,
                    allcolors,
                    AppLocalizations.of(context)!.sku,
                    keyboard: TextInputType.text,
                  ),
                  /*_input(
                    descriptionCtrl,
                    allcolors,
                    AppLocalizations.of(context)!.description,
                    keyboard: TextInputType.multiline,
                  ),*/                  
                  _input(
                    costPriceCtrl,
                    allcolors,
                    AppLocalizations.of(context)!.costPrice,
                    keyboard: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  _input(
                    sellingPriceCtrl,
                    allcolors,
                    AppLocalizations.of(context)!.sellingPrice,
                    keyboard: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  /*_sectionTitle(AppLocalizations.of(context)!.classification, allcolors),
                  _input(
                    categoryCtrl,
                    allcolors,
                    AppLocalizations.of(context)!.category,
                    keyboard: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  _input(
                    brandCtrl,
                    allcolors,
                    AppLocalizations.of(context)!.brand,
                    keyboard: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  SwitchListTile(
                    title: isActive
                        ? _sectionTitle(
                            AppLocalizations.of(context)!.active, allcolors)
                        : _sectionTitle(
                            AppLocalizations.of(context)!.inactive, allcolors),
                    value: isActive,
                    onChanged: (v) => setState(() => isActive = v),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 8),
                    tileColor: isActive
                        ? allcolors.secondary.withAlpha(50)
                        : allcolors.primaryContainer.withAlpha(30),
                    selectedTileColor: allcolors.secondary.withAlpha(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isActive
                            ? allcolors.secondary
                            : allcolors.primaryContainer,
                        width: isActive ? 2 : 1,
                      ),
                    ),
                    activeColor: allcolors.onPrimary,
                    inactiveThumbColor: allcolors.onPrimaryContainer,
                    inactiveTrackColor:
                        allcolors.primaryContainer.withAlpha(100),
                    hoverColor: allcolors.secondaryContainer.withAlpha(50),
                  ),
                  SwitchListTile(
                    title: stockTracking
                        ? _sectionTitle(
                            AppLocalizations.of(context)!.stockTracking ?? 'Stock Tracking',
                            allcolors)
                        : _sectionTitle(
                            AppLocalizations.of(context)!.stockTracking ?? 'Stock Tracking',
                            allcolors),
                    value: stockTracking,
                    onChanged: (v) => setState(() => stockTracking = v),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 8),
                    tileColor: stockTracking
                        ? allcolors.secondary.withAlpha(50)
                        : allcolors.primaryContainer.withAlpha(30),
                    selectedTileColor: allcolors.secondary.withAlpha(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: stockTracking
                            ? allcolors.secondary
                            : allcolors.primaryContainer,
                        width: stockTracking ? 2 : 1,
                      ),
                    ),
                    activeColor: allcolors.onPrimary,
                    inactiveThumbColor: allcolors.onPrimaryContainer,
                    inactiveTrackColor:
                        allcolors.primaryContainer.withAlpha(100),
                    hoverColor: allcolors.secondaryContainer.withAlpha(50),
                  ),*/

                  _sectionTitle(AppLocalizations.of(context)!.warehouses,allcolors),              
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
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: _updateProduct,
                    child: TextSection(
                      description:
                          AppLocalizations.of(context)!.updateProduct,
                      textFontSize: 16,
                      textColor: allcolors.onSecondary,
                      textFontWeight: FontWeight.w800,
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
