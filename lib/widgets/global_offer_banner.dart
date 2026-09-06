import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';

class GlobalOfferBanner extends StatelessWidget {
  const GlobalOfferBanner({Key? key}) : super(key: key);

  static void showOffersBottomSheet(BuildContext context, CartController cartController) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          alignment: Alignment.topCenter,
          clipBehavior: Clip.none,
          children: [
            // The Bottom Sheet Content
            Container(
              margin: const EdgeInsets.only(top: 60), // Space for floating close button
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
              decoration: const BoxDecoration(
                color: Color(0xFF1E2126), // Very dark grey, almost black
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Offers for you',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // The Timeline/List
                  Obx(() => _buildOfferTimeline(cartController)),
                ],
              ),
            ),
            // Floating Close Button
            Positioned(
              top: 0,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2E35), // Darker grey circle
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildOfferTimeline(CartController cartController) {
    final subtotal = cartController.subTotal;
    
    return Column(
      children: [
        _buildOfferItem(
          title: 'Unlock free delivery',
          subtitle: subtotal >= 149 ? 'Unlocked' : 'Shop for ₹${(149 - subtotal).toInt()} more',
          isActive: subtotal >= 149,
          isFirst: true,
          progress: subtotal / 149,
        ),
        _buildOfferItem(
          title: 'Unlock extra ₹50 OFF',
          subtitle: subtotal >= 899 ? 'Unlocked' : 'Shop for ₹${(899 - subtotal).toInt()} more',
          isActive: subtotal >= 899,
          progress: subtotal / 899,
        ),
        _buildOfferItem(
          title: 'Unlock extra ₹100 OFF',
          subtitle: subtotal >= 1499 ? 'Unlocked' : 'Shop for ₹${(1499 - subtotal).toInt()} more',
          isActive: subtotal >= 1499,
          progress: subtotal / 1499,
        ),
        _buildOfferItem(
          title: 'Unlock extra ₹150 OFF',
          subtitle: subtotal >= 2099 ? 'Unlocked' : 'Shop for ₹${(2099 - subtotal).toInt()} more',
          isActive: subtotal >= 2099,
          progress: subtotal / 2099,
        ),
        _buildOfferItem(
          title: 'Unlock extra ₹200 OFF',
          subtitle: subtotal >= 2699 ? 'Unlocked' : 'Shop for ₹${(2699 - subtotal).toInt()} more',
          isActive: subtotal >= 2699,
          isLast: true,
          progress: subtotal / 2699,
        ),
      ],
    );
  }

  static Widget _buildOfferItem({
    required String title,
    required String subtitle,
    bool isActive = false,
    bool isFirst = false,
    bool isLast = false,
    double progress = 0.0,
  }) {
    final double clampedProgress = progress.clamp(0.0, 1.0);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line and Icon
          SizedBox(
            width: 30,
            child: Column(
              children: [
                // Top line
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : (isActive ? Colors.green.shade500 : Colors.grey.shade700),
                  ),
                ),
                // Icon
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.grey.shade700,
                    shape: BoxShape.circle,
                    border: isActive ? Border.all(color: Colors.green.shade500, width: 2) : null,
                  ),
                  child: Icon(
                    isActive ? Icons.check : Icons.lock,
                    color: isActive ? Colors.green.shade500 : Colors.white,
                    size: 12,
                  ),
                ),
                // Bottom line
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : (clampedProgress >= 1.0 ? Colors.green.shade500 : Colors.grey.shade700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Content Box
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : const Color(0xFF2C3038),
                  borderRadius: BorderRadius.circular(16),
                  border: isActive ? Border.all(color: Colors.green.shade500, width: 2) : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  color: isActive ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  color: isActive ? Colors.green.shade700 : Colors.grey.shade400,
                                  fontSize: 13,
                                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green.shade50 : const Color(0xFF3B4048),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isActive ? 'Unlocked' : 'Locked',
                            style: TextStyle(
                              color: isActive ? Colors.green.shade600 : Colors.grey.shade400,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!isActive && clampedProgress > 0) ...[
                      const SizedBox(height: 12),
                      Container(
                        height: 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: clampedProgress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green.shade500,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<CartController>()) {
      return const SizedBox.shrink();
    }
    final cartController = Get.find<CartController>();

    return Obx(() {
      if (cartController.items.isNotEmpty) {
        return const SizedBox.shrink();
      }

      return Positioned(
        bottom: 20, // Sit just above the bottom nav bar
        left: 16,
        right: 16,
        child: GestureDetector(
          onTap: () => showOffersBottomSheet(context, cartController),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Dark Banner
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF333A42), // Dark grey
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Obx(() {
                final subtotal = cartController.subTotal;
                String bannerTitle = '';
                String bannerSubtitle = '';
                
                if (subtotal < 149) {
                  bannerTitle = 'Unlock free delivery';
                  bannerSubtitle = 'Shop for ₹${(149 - subtotal).toInt()} more';
                } else if (subtotal < 899) {
                  bannerTitle = 'Unlock extra ₹50 OFF';
                  bannerSubtitle = 'Shop for ₹${(899 - subtotal).toInt()} more';
                } else if (subtotal < 1499) {
                  bannerTitle = 'Unlock extra ₹100 OFF';
                  bannerSubtitle = 'Shop for ₹${(1499 - subtotal).toInt()} more';
                } else if (subtotal < 2099) {
                  bannerTitle = 'Unlock extra ₹150 OFF';
                  bannerSubtitle = 'Shop for ₹${(2099 - subtotal).toInt()} more';
                } else if (subtotal < 2699) {
                  bannerTitle = 'Unlock extra ₹200 OFF';
                  bannerSubtitle = 'Shop for ₹${(2699 - subtotal).toInt()} more';
                } else {
                  bannerTitle = 'All offers unlocked!';
                  bannerSubtitle = 'Apply in cart';
                }

                return Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            bannerTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            bannerSubtitle,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
            // Floating "Offers" tag
            Positioned(
              top: -12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pink.shade100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Offers',
                      style: TextStyle(
                        color: Colors.pink.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.pink.shade600,
                      size: 16,
                    ),
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
