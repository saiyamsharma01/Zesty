import 'package:flutter/material.dart';

class SelectScreen extends StatelessWidget {
  const SelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select', style: TextStyle(color: Colors.brown)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: const Center(
        child: Text('Vegetables, Fruits, and Proteins', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
