import 'package:flutter/material.dart';

class Mysafe extends StatelessWidget {
  const Mysafe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('my safe'),
        ),
      ),
    );
  }
}
