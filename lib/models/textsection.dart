import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {
  final String description;
  final double textFontSize;
  final Color textColor;
  
  const TextSection({
    super.key,
    required this.description,
    this.textFontSize=12,
    this.textColor=Colors.white70
  });  

  @override
  Widget build(BuildContext context) {
    /*return TextField(
      obscureText: true,
        decoration: InputDecoration(border: OutlineInputBorder(), labelText: description),
    );*/
    return Text(
      description, 
      softWrap: false,
      style: TextStyle(fontSize: textFontSize,color: textColor),
    );
  }
}
