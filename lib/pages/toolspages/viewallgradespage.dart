import 'package:flutter/material.dart';

class Viewallgradespage extends StatefulWidget {
  const Viewallgradespage({super.key});

  @override
  State<Viewallgradespage> createState() => _ViewallgradespageState();
}

class _ViewallgradespageState extends State<Viewallgradespage> {
  Widget body = Text('在写了');
  // Center(child: CircularProgressIndicator());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('所有成绩查看')),
      body: body,
    );
  }
}
