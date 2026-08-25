import 'package:flutter/material.dart';

class SuperMallScreen extends StatelessWidget {
  const SuperMallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Mall', style: TextStyle(color: Colors.blue)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: const Center(
        child: Text('Clothes, Electronics, Home Furnishing, Home Decor', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
