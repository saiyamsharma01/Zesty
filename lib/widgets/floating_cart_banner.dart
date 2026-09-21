import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../screens/cart_screen.dart';
import 'global_offer_banner.dart';

class FloatingCartBanner extends StatelessWidget {
  const FloatingCartBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Obx(() {
      if (cartController.items.isEmpty) {
        return const SizedBox.shrink();
      }

      final subtotal = cartController.subTotal;
      String offerTitle = '';
      String offerSubtitle = '';

      if (subtotal < 149) {
        offerTitle = 'Unlock free delivery';
        offerSubtitle = 'Shop for ₹${(149 - subtotal).toInt()} more';
      } else if (subtotal < 899) {
        offerTitle = 'Unlock extra ₹50 OFF';
        offerSubtitle = 'Shop for ₹${(899 - subtotal).toInt()} more';
      } else if (subtotal < 1499) {
        offerTitle = 'Unlock extra ₹100 OFF';
        offerSubtitle = 'Shop for ₹${(1499 - subtotal).toInt()} more';
      } else if (subtotal < 2099) {
        offerTitle = 'Unlock extra ₹150 OFF';
        offerSubtitle = 'Shop for ₹${(2099 - subtotal).toInt()} more';
      } else if (subtotal < 2699) {
        offerTitle = 'Unlock extra ₹200 OFF';
        offerSubtitle = 'Shop for ₹${(2699 - subtotal).toInt()} more';
      } else {
        offerTitle = 'All offers unlocked!';
        offerSubtitle = 'Apply in cart';
      }

      return GestureDetector(
        onTap: () {
          GlobalOfferBanner.showOffersBottomSheet(context, cartController);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2E3239), // Dark blue/grey background
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    // Offer Icon
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.percent,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    
                    // Offer Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            offerTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            offerSubtitle,
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Pink Cart Button
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const CartScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0145A), // Zepto pink
                          borderRadius: BorderRadius.circular(12),
                        ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Small product image preview
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: cartController.items.values.first.product.networkImage.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Image.network(
                                        cartController.items.values.first.product.networkImage,
                                        fit: BoxFit.contain,
                                        errorBuilder: (c, e, s) => const Icon(Icons.shopping_bag, size: 18, color: Colors.orange),
                                      ),
                                    )
                                  : const Icon(Icons.shopping_bag, size: 18, color: Colors.orange),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Cart',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${cartController.totalItems} items',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ),
                  ],
                ),
              ),
              
              // Top "Offers" Badge
              Positioned(
                top: -12,
                left: 60,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.pink.shade100),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Offers',
                        style: TextStyle(
                          color: Color(0xFFF0145A),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(Icons.keyboard_arrow_up, color: const Color(0xFFF0145A), size: 14),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
