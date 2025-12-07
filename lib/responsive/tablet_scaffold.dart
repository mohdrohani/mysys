import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


var myDefaultBackgroundColor=Colors.grey[300];
var appBarColor= Colors.grey[900];
bool isVisible = true;
var menuItemSelected=false;
var menuTileColor=Colors.white;
final VoidCallback? myOnPressed = null;   
final List<Color> myColors = const [
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
final List<Map<String, dynamic>> myItems = const [
    {'image': CupertinoIcons.calendar_today, 'name': 'الزيارات'},
    {'image': CupertinoIcons.add_circled, 'name': 'طلب جديد'},
    {'image': CupertinoIcons.cart_badge_plus, 'name': 'عرض سعر'},
    {'image': CupertinoIcons.group, 'name': 'العملاء'},
    {'image': CupertinoIcons.arrow_right_arrow_left_circle, 'name': 'المرتجع'},
    {'image': CupertinoIcons.money_dollar_circle, 'name': 'الصندوق'},
    {'image': CupertinoIcons.qrcode, 'name': 'الفواتير'},
    {'image': CupertinoIcons.home, 'name': 'المخزون'},
    {
      'image': CupertinoIcons.arrow_2_circlepath_circle_fill,
      'name': 'المزامنة',
    },
    {'image': CupertinoIcons.settings, 'name': 'الأعدادات'},    
  ];
var myAppBar=AppBar(
  leading: IconButton(
          icon: Icon(
            isVisible
                ? Icons.navigate_before   // List visible → hide button
                : Icons.navigate_next, // List hidden → show button
          ),
          onPressed: () {
            isVisible = !isVisible;
            print("isVisible: $isVisible");            
          },
        ),
  iconTheme: IconThemeData(color: Colors.white),
  backgroundColor:appBarColor,
  );
class TabletScaffold extends StatefulWidget {
  const TabletScaffold({Key? key}) : super(key: key);
  
  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();  
}

class _TabletScaffoldState extends State<TabletScaffold> {
  
  @override
  Widget build(BuildContext context) {         
    return Scaffold(      
      backgroundColor: myDefaultBackgroundColor,
      appBar: myAppBar,      
      body: Drawer(
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
                Navigator.pop(context);
                menuItemSelected = true;
                appBarColor=myColors[index % myColors.length];
                setState(() {
                  appBarColor=myColors[index % myColors.length];
                  myAppBar.backgroundColor;
                  });
                  print("${item["name"]} tapped, menuItemSelected: $menuItemSelected, appBarColor: $appBarColor");
              },
            );
          },
        ),
      ),      
    );        
  }
}
