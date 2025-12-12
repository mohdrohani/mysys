import 'package:flutter/material.dart';
class InputField extends StatelessWidget{
  final String inputTextHolder;

  const InputField({
    super.key,
    required this.inputTextHolder,    
  });
  
  @override
  Widget build(BuildContext context) 
  {
    return TextField(        
      
      style: TextStyle(fontSize: 12,color: Colors.white),
      decoration: InputDecoration(
        border: OutlineInputBorder(),        
        hintText: inputTextHolder, 
        contentPadding: EdgeInsets.all(10),     
        isDense: true, 
      ),
    );
  }
}

