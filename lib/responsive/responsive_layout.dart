import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mysys/data/myappsettings.dart';


class ResponsiveLayout extends StatelessWidget {
  
  final Widget mobileScaffold;
  final Widget tabletScaffold;
  final Widget desktopScaffold;
  
  const ResponsiveLayout({
    super.key,
    required this.mobileScaffold,
    required this.tabletScaffold,
    required this.desktopScaffold,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = 0;
        double height = 0;
        // Get the width of the screen
        width = constraints.maxWidth;
        height = constraints.maxHeight;
        myMaxWidthGlobal=width;
        myMaxHeightGlobal=height;

        // Determine which layout to use based on the width
        if(width<500){  
          return mobileScaffold;
        }
        else if(width < 1100)
        {
          //cax=2;
          return tabletScaffold;
        }
        else{
          return desktopScaffold;
        }
      },
    );
  }
}
