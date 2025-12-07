import 'package:flutter/material.dart';
import 'package:mysys/models/main_menu.dart';
import 'package:mysys/models/side_menu_widget.dart';
import 'package:mysys/pages/visit.dart';
import 'package:mysys/pages/qoute.dart';
import 'package:mysys/pages/customers.dart';
import 'package:mysys/pages/returninvoice.dart';
import 'package:mysys/pages/mysafe.dart';
import 'package:mysys/pages/invoices.dart';
import 'package:mysys/pages/warehouse.dart';
import 'package:mysys/pages/neworder.dart';
import 'package:mysys/pages/synchronize.dart';
import 'package:mysys/pages/mysettings.dart';
import 'package:mysys/data/myappsettings.dart';
import 'package:window_manager/window_manager.dart';
import 'package:mysys/l10n/app_localizations.dart';



class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({super.key});
  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateWindowTitle(context);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body:Row(
        children: [          
          Expanded(
            flex: 2,
            child: SizedBox(
              child: Container( 
                color: Colors.grey[200],
                child: SideMenuWidget(
                  onPageChanged: () {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              color: myDefaultBackgroundColor,
              child: Center(
                child: Builder(builder: (_) {
                  final page = selectedPageGlobalGetter;
                  if (page == 0) return const Center(child: Neworder());
                  if (page == 1) return const Center(child: Visit());
                  if (page == 2) return const Center(child: Qoute());
                  if (page == 3) return const Center(child: Customers());
                  if (page == 4) return const Center(child: Returninvoice());
                  if (page == 5) return const Center(child: Mysafe());
                  if (page == 6) return const Center(child: Invoices());
                  if (page == 7) return const Center(child: Warehouse());
                  if (page == 8) return const Center(child: Synchronize());
                  if (page == 9) return const Center(child: Mysettings());                  
                  return const SizedBox.shrink();
                }),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.grey[400],
              child: const Center(
                child: Text(
                  'Additional Info / Ads',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
void updateWindowTitle(BuildContext context) async {
  final t = AppLocalizations.of(context)!;
  await windowManager.setTitle(t.appName);
}
