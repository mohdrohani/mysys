import 'package:flutter/material.dart';
import "theme_provider.dart";
import 'package:provider/provider.dart';

class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {    
    return ThemeButton();
  }
}

class ThemeButton extends StatelessWidget {
  const ThemeButton({
    super.key,            
    this.onPressed,
  });  

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Icon(Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
        ? Icons.light_mode
        : Icons.dark_mode);
        onPressed?.call();
      },
      
    );
  }
}
