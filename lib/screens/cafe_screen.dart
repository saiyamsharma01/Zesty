import 'package:flutter/material.dart';

class CafeScreen extends StatelessWidget {
  const CafeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafe', style: TextStyle(color: Colors.purple)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.purple),
      ),
      body: const Center(
        child: Text('Pizza, Fast Food, and Beverages', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
