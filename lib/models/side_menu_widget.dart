import 'package:flutter/material.dart';
import 'package:mysys/data/myappsettings.dart';
import 'package:mysys/models/main_menu.dart';
import 'package:mysys/l10n/app_localizations.dart';

int selectedIndex=0;
final List<Map<String, dynamic>>items=myItems;  
final List<Color> colors=myColors;

class SideMenuWidget extends StatefulWidget{
  final VoidCallback? onPageChanged;
  const SideMenuWidget({super.key, this.onPageChanged});

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget>{
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 00.0,horizontal: 00.0), 
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => buildMenuEntry(index),
      ),
    );
  }
  Widget buildMenuEntry(int index){
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
    final isSelected=selectedIndex==index;
    return DecoratedBox(
      decoration: BoxDecoration(        
        color:colors[index % colors.length]
        ),
      child: InkWell(
        onTap: (){
          selectedIndex=index;
          selectedPageGlobal=selectedIndex;
          widget.onPageChanged?.call();           
        },
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Row(
                    
            children: [
              Expanded(
                child: Padding(
                  //:data.menu[index].mycolor,
                  padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 14.0),
                  child: Icon(
                    items[index]['image'],
                    color: isSelected?Colors.grey[300] : Colors.white,
                  ),
                ),
              ),        
              Expanded(
                child: Text(
                  myItemsName[index]["name"]!,
                  style: TextStyle(
                    color: isSelected?Colors.grey[300] : Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 16,          
                  ),
                ),
              ),          
            ],
          ),
        ),        
      ),
    );
  }
}
