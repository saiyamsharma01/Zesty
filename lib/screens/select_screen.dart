import 'package:flutter/material.dart';
import '../widgets/floating_cart_banner.dart';
import '../widgets/global_offer_banner.dart';

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
      body: Stack(
        children: [
          const Center(
            child: Text('Vegetables, Fruits, and Proteins', style: TextStyle(fontSize: 20)),
          ),
          const GlobalOfferBanner(),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingCartBanner(),
          ),
        ],
      ),
    );
  }
}
