import 'package:flutter/material.dart';
class InputField extends StatelessWidget{
  final String inputTextHolder;
  final Color focusedBorderColor;

  const InputField({
    super.key,
    required this.inputTextHolder,    
    this.focusedBorderColor=Colors.white,
  });
  
  @override
  Widget build(BuildContext context) 
  {
    return TextField(
      textAlignVertical:TextAlignVertical.center,
      textAlign:TextAlign.center,
      style: TextStyle(fontSize: 12,color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 1.5),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color:focusedBorderColor, width: 2.5),
          borderRadius: BorderRadius.circular(8.0),
        ),     
        border: OutlineInputBorder(),
        hintText: inputTextHolder, 
        hintStyle: TextStyle(
          color: Colors.grey, // set your color here          
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 0,vertical: 0),     
        isDense: true, 
      ),
    );
  }
}

