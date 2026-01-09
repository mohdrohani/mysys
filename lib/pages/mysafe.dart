import 'package:flutter/material.dart';

class Mysafe extends StatefulWidget {
  const Mysafe({super.key});

  @override
  State<Mysafe> createState() => _MysafeState();
}

class _MysafeState extends State<Mysafe> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الرئيسية')),
      body: Column(
        children: [
          // Menu Button
          ListTile(
            title: Text('Menu Options'),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          
          // Expandable Content
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isExpanded ? 200 : 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(title: Text('Option 1'), onTap: () {}),
                  ListTile(title: Text('Option 2'), onTap: () {}),
                  ListTile(title: Text('Option 3'), onTap: () {}),
                  ListTile(title: Text('Option 4'), onTap: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
