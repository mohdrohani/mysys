import 'package:flutter/material.dart';
class TitledContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final Color borderColor;
  final double borderWidth;
  final Color titleBackgroundColor;
  final Color titleColor;  

  const TitledContainer({
    super.key,
    required this.title,
    required this.child,
    this.borderColor = Colors.white,
    this.borderWidth = 1.5,
    this.titleBackgroundColor = const Color(0xFF3C3C3C), // Background behind the title
    this.titleColor=Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The Bordered Container
        Container(
          margin: const EdgeInsets.all(12), // Space for the title
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: borderWidth),
            color: titleBackgroundColor,
            borderRadius: BorderRadius.circular(10.0),
          ),          
          child: child,
        ),
        // The Title positioned over the top border
        PositionedDirectional(
          start: 0.0, // Adjust position as needed
          top: 0.0,
          child: Container(            
            color: titleBackgroundColor, // Matches the app background
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}