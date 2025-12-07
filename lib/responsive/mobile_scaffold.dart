import 'package:flutter/material.dart';
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
import 'package:mysys/models/main_menu.dart';
import 'package:mysys/data/myappsettings.dart';
import 'package:mysys/l10n/app_localizations.dart';

var cax=crossAxisCountGlobalGetter;
final List<Map<String, dynamic>>items=myItems;  
final List<Color> colors=myColors;
final VoidCallback? onPressed = myOnPressed;

class MobileScaffold extends StatefulWidget {
  
  const MobileScaffold({super.key});
  // Create a list of 10 data items (e.g., image paths and labels)
  
  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {

  @override
  Widget build(BuildContext context) {    
    final t = AppLocalizations.of(context)!;
    final myItemsName = [    
      {'name': t.newOrder},
      {'name': t.visits},        
      {'name': t.qoutation},
      {'name': t.customers},
      {'name': t.returnInvoice},
      {'name': t.casheir},
      {'name': t.invoices},
      {'name': t.warehouse},
      {'name': t.synchronization},
      {'name': t.settings},    
    ];
    
    
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child:GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cax, // Number of columns in the grid
            crossAxisSpacing: 10, // Spacing between columns
            mainAxisSpacing: 10, // Spacing between rows
            childAspectRatio: 1.0, // Aspect ratio of each grid item
          ),
          itemCount: items.length, // Total number of items (10)
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: Card(
                // Use a Card for a Material Design look
                elevation: 2.0,
                color: colors[index % colors.length],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Icon(
                        items[index]['image'],
                        size: 32,
                        color: const Color.fromARGB(255, 248, 247, 247),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        myItemsName[index]["name"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 248, 247, 247),
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            onTap: () {
              switch (index) {
                case 0:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Neworder(),
                    ),
                  );
                }
                break;
                case 1:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Visit(),
                    ),
                  );
                }
                break;
                case 2:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Qoute(),
                    ),
                  );
                }
                break;
                case 3:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Customers(),
                    ),
                  );
                }
                break;
                case 4:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Returninvoice(),
                    ),
                  );
                }
                break;
                case 5:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Mysafe(),
                    ),
                  );
                }
                break;
                case 6:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Invoices(),
                    ),
                  );
                }
                break;
                case 7:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Warehouse(),
                    ),
                  );
                }
                break;
                case 8:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Synchronize(),
                    ),
                  );
                }
                break;
                case 9:
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => const Mysettings(),
                    ),
                  );
                }
                break;
                default:
                break;
                }
              onPressed?.call();
            },
          );
        },
      ),
    ),
  );
}
}
