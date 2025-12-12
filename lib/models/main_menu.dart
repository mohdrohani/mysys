import 'package:flutter/material.dart';


var myDefaultBackgroundColor=Colors.grey[300];
var appBarColor= Colors.grey[900];
bool isVisible = true;

var myAppBar=AppBar(
  leading: IconButton(
          icon: Icon(
            isVisible
                ? Icons.navigate_before   // List visible → hide button
                : Icons.navigate_next, // List hidden → show button
          ),
          onPressed: () {
            isVisible = !isVisible;
            //print("isVisible: $isVisible");            
          },
        ),
  iconTheme: const IconThemeData(color: Colors.white),
  backgroundColor:appBarColor,
);

var menuItemSelected=false;
var menuTileColor=Colors.white;
VoidCallback? myOnPressed;   

List<Color> myColors = const [    
  Color(0xFF79A2B4),
  Color(0xFFA6C0CD),
  Color.fromARGB(255, 20, 49, 61),
  Color.fromARGB(255, 51, 99, 119),
  Color(0xFFAF3738),
  Color.fromARGB(255, 94, 179, 97),
  Color.fromARGB(255, 142, 235, 145),
  Color.fromARGB(255, 141, 221, 255),
  Color.fromARGB(255, 110, 174, 201),
  Color.fromARGB(255, 123, 123, 124),
];

/*final List<Widget> menuPage = const [
  Neworder(),Visit(),Qoute(),Customers(),Returninvoice(),Mysafe(),Invoices(),Warehouse(),Synchronize(),Mysettings()
  ];*/
  

List<Map<String, dynamic>> myItems = const [    
  {'image': Icons.plus_one},
  {'image': Icons.calendar_today},        
  {'image':Icons.badge},
  {'image': Icons.group},
  {'image': Icons.keyboard_return},
  {'image': Icons.monetization_on},
  {'image': Icons.qr_code},
  {'image': Icons.home},
  {'image': Icons.sync},
  {'image': Icons.settings},    
];


/*List<Map<String, dynamic>> myItems = const [    
  {'image': Icons.plus_one, 'name': 'طلب جديد'},
  {'image': Icons.calendar_today, 'name': 'الزيارات'},        
  {'image':Icons.badge, 'name': 'عرض سعر'},
  {'image': Icons.group, 'name': 'العملاء'},
  {'image': Icons.keyboard_return, 'name': 'المرتجع'},
  {'image': Icons.monetization_on, 'name': 'الصندوق'},
  {'image': Icons.qr_code, 'name': 'الفواتير'},
  {'image': Icons.home, 'name': 'المخزون'},
  {'image': Icons.sync,'name': 'المزامنة'},
  {'image': Icons.settings, 'name': 'الأعدادات'},    
];*/

/*getMyPage(int index)  
{
  return menuPage[0];
}*/
var myDrawer=Drawer(
  backgroundColor: Colors.grey[300],
  child:ListView.builder(
    itemCount: myItems.length,    
    itemBuilder: (context, index) {
      final item = myItems[index];
      appBarColor=myColors[index % myColors.length];
      return ListTile(
        selected: menuItemSelected,
        leading: Icon(item["image"]),
        title: Text(item["name"]),
        iconColor: Colors.white,
        textColor: Colors.white,
        tileColor: appBarColor,  
        onTap: () {
          menuItemSelected = true;
          appBarColor=myColors[index % myColors.length];
          myAppBar=AppBar(                      
            backgroundColor:appBarColor,
          );
          //print("${item["name"]} tapped, menuItemSelected: $menuItemSelected, appBarColor: $appBarColor");
        },
      );
    },
),
);