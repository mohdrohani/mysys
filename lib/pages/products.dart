import 'package:flutter/material.dart';
import 'package:mysys/pages/addproduct.dart';
import 'package:mysys/database/app_database.dart';
import 'package:mysys/l10n/app_localizations.dart';
import "../theme/theme_provider.dart";
import 'package:provider/provider.dart';
import 'package:mysys/data/myappsettings.dart';
import '../models/textsection.dart';
import 'package:mysys/pages/edit_view_product.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];
  bool isSelected = false;
  String? selectedProductId;  

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterProducts);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final db = await AppDatabase().database;
    final products = await db.query('products', orderBy: 'is_active DESC, name ASC');
    setState(() {
      allProducts = products;
      filteredProducts = products;
    });
  }

  void _filterProducts() {
    setState(() {
      if (searchController.text.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((product) => product['name']
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

  Widget _buildProductDropdown(BuildContext context, ThemeProvider provider) {
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
              hintText: AppLocalizations.of(context)!.searchProduct,
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
        // Product List
        Expanded(
          child: filteredProducts.isEmpty
          ? Center(
            child: Column(                            
              children: [
                Text(
                  '${AppLocalizations.of(context)!.noProductAdded}! 😞',
                  style: TextStyle(
                    color: allcolors.error, 
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: allcolors.shadow.withOpacity(0.8),
                        blurRadius: 15,
                        ),
                      ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: allcolors.secondary,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Change the curve here
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute<bool>(
                        builder: (context) => const AddProductPage(),
                      ),
                    );
                    // Reload products if a new one was added
                    if (result == true) {
                      _loadProducts();
                    }
                  },
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
          )
          : ListView.builder(
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              isSelected = selectedProductId == product['id'].toString();
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
                      Icons.category,
                      color: isSelected
                      ? allcolors.secondary
                      : allcolors.secondaryContainer,
                      size: 20,
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            product['name'] ?? 'Unknown',
                            style: TextStyle(
                              color: allcolors.onPrimaryContainer,
                              fontSize: 18,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                        if ((product['is_active'] as int?) == 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: allcolors.error.withAlpha(100),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: allcolors.error, width: 1),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.inactive,
                              style: TextStyle(
                                color: allcolors.error,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: product['cost_price'] != null && product['cost_price'].toString().trim().isNotEmpty
                    ? InkWell(
                      onTap: () async {
                        // Implement edit product price functionality here
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.attach_money,
                              size: 18,
                              color: allcolors.secondaryContainer.withAlpha(150),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              product['cost_price'].toString(),
                              style: TextStyle(
                              color: allcolors.secondaryContainer.withAlpha(150),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                    :Text(
                      '${AppLocalizations.of(context)!.noCostPriceFound}! 😞 ${AppLocalizations.of(context)!.tapToEdit}',
                      style: TextStyle(
                        color: allcolors.error, 
                        fontSize: 14, 
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: allcolors.shadow.withOpacity(0.8),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                    ),
                    trailing: isSelected
                    ? Icon(Icons.check_circle, color: allcolors.secondary)
                    : null,
                    onTap: () async {
                      setState(() {
                        selectedProductId = product['id'].toString();
                      });
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute<bool>(
                          builder: 
                          (context) => EditViewProduct(productId: product['id'] as int),
                          //(context) => AddProductPage(),
                        ),
                      );
                      if (result == true) {
                        await _loadProducts();
                      }
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
          AppLocalizations.of(context)!.products,
          style: TextStyle(fontWeight: FontWeight.bold,color: allcolors.onPrimary),
        ),
        actions: [          
          IconButton(
            icon: Icon(Icons.add),
            color: allcolors.onPrimary,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute<bool>(
                  builder: (context) => const AddProductPage(),
                ),
              );
              // Reload products if a new one was added
              if (result == true) {
                _loadProducts();
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
        child: _buildProductDropdown(context,tProvider)
      ),
    );
  }
}
