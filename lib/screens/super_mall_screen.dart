import 'package:flutter/material.dart';
import '../widgets/floating_cart_banner.dart';
import '../widgets/global_offer_banner.dart';

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
      body: Stack(
        children: [
          const Center(
            child: Text('Clothes, Electronics, Home Furnishing, Home Decor', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
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
