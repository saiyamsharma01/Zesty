import 'package:flutter/material.dart';
import '../widgets/floating_cart_banner.dart';
import '../widgets/global_offer_banner.dart';

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
      body: Stack(
        children: [
          const Center(
            child: Text('Pizza, Fast Food, and Beverages', textAlign: TextAlign.center, style: TextStyle(fontSize: 20)),
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
