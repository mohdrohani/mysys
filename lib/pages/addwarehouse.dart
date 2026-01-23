import 'package:flutter/material.dart';
import 'package:mysys/database/app_database.dart';
import 'package:mysys/l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddWarehouse extends StatefulWidget {
  const AddWarehouse({super.key});

  @override
  State<AddWarehouse> createState() => _AddWarehouseState();
}

class _AddWarehouseState extends State<AddWarehouse> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final locationCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose();
    locationCtrl.dispose();
    super.dispose();
  }

  void _showMsg(String msg, ColorScheme colors) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: colors.primaryContainer,
      textColor: colors.onPrimaryContainer,
      fontSize: 16.0,
    );
  }

  Future<void> _saveWarehouse() async {
    if (!_formKey.currentState!.validate()) return;

    final db = await AppDatabase().database;

    try {
      await db.insert('warehouses', {
        'name': nameCtrl.text,
        'location': locationCtrl.text,
      });

      _showMsg(
        AppLocalizations.of(context)!.warehouseSavedMsg ??
            'Warehouse saved successfully',
        Theme.of(context).colorScheme,
      );

      // Clear fields
      nameCtrl.clear();
      locationCtrl.clear();

      // Go back to previous page
      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showMsg(
        'Error: $e',
        Theme.of(context).colorScheme,
      );
    }
  }

  Widget _section(String title, ColorScheme colors) {
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

  Widget _input(
    TextEditingController controller,
    ColorScheme colors,
    String label, {
    bool required = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: required
            ? (v) => v == null || v.isEmpty ? 'Required' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 14,
            color: colors.primaryContainer,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                BorderSide(color: colors.primaryContainer, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: colors.primaryContainer.withAlpha(150),
              width: 3,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colors.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: colors.error.withAlpha(150), width: 3),
          ),
        ),
        style: TextStyle(
          color: colors.onPrimaryContainer,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allcolors = Theme.of(context).colorScheme;

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
          AppLocalizations.of(context)!.addWarehouse ?? 'Add Warehouse',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: allcolors.onPrimary,
          ),
        ),
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
                  _section(
                    AppLocalizations.of(context)!.warehouseInfo ?? 'Warehouse Info',
                    allcolors,
                  ),
                  _input(
                    nameCtrl,
                    allcolors,
                    AppLocalizations.of(context)!.warehouseName ?? 'Warehouse Name',
                    required: true,
                  ),
                  _input(
                    locationCtrl,
                    allcolors,
                    AppLocalizations.of(context)!.warehouseLocation ?? 'Warehouse Location',
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
                    onPressed: _saveWarehouse,
                    child: Text(
                      AppLocalizations.of(context)!.saveWarehouse ??
                          'Save Warehouse',
                      style: TextStyle(
                        color: allcolors.onSecondary,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
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
