import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../controllers/cart_controller.dart';
import '../screens/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final double? width;
  final double? imageHeight;
  final Color? cardBgColor;
  final bool showDeliveryTime;
  final bool isAd;
  final String? badgeText;
  final Color? badgeColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const ProductCard({
    super.key,
    required this.product,
    this.width = 142,
    this.imageHeight = 114,
    this.cardBgColor,
    this.showDeliveryTime = false,
    this.isAd = false,
    this.badgeText,
    this.badgeColor,
    this.onTap,
    this.margin,
  });

  CartController get _cartController {
    if (Get.isRegistered<CartController>()) {
      return Get.find<CartController>();
    }
    return Get.put(CartController(), permanent: true);
  }

  @override
  Widget build(BuildContext context) {
    final cartController = _cartController;
    final originalPrice = (product.price * 1.28).toInt();
    final bool isSelectProduct = product.category == 'Select' ||
        product.name.toLowerCase().contains('select') ||
        product.offer.toLowerCase().contains('select');

    return GestureDetector(
      onTap: onTap ?? () => Get.to(() => ProductDetailsScreen(product: product)),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: width,
        margin: margin ?? (width != null ? const EdgeInsets.only(right: 12) : EdgeInsets.zero),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Image Container with Badges & Floating Add Button
            Container(
              height: imageHeight,
              width: double.infinity,
              decoration: BoxDecoration(
                color: cardBgColor ?? const Color(0xFFF6F7F9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200, width: 0.8),
              ),
              child: Stack(
                children: [
                  // Product Image
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: product.networkImage.startsWith('http')
                            ? Image.network(
                                product.networkImage,
                                fit: BoxFit.contain,
                                height: (imageHeight ?? 114) * 0.78,
                                width: (imageHeight ?? 114) * 0.78,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade100,
                                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 36),
                                ),
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    color: Colors.grey.shade100,
                                    child: const Center(
                                      child: SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFF0145A)),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Image.asset(
                                product.networkImage,
                                fit: BoxFit.contain,
                                height: (imageHeight ?? 114) * 0.78,
                                width: (imageHeight ?? 114) * 0.78,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey.shade100,
                                  child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 36),
                                ),
                              ),
                      ),
                    ),
                  ),

                  // Top Left Badge (Select / Discount / Custom)
                  if (badgeText != null || isSelectProduct || product.offer.isNotEmpty)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: badgeColor ?? (isSelectProduct ? const Color(0xFF7A3614) : const Color(0xFF9852F9)),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              badgeText ?? (isSelectProduct ? 'select' : product.offer),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                              ),
                            ),
                            if (isSelectProduct) ...[
                              const SizedBox(width: 2),
                              const Icon(Icons.chevron_right, size: 11, color: Colors.white),
                            ],
                          ],
                        ),
                      ),
                    )
                  else if (showDeliveryTime)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.timer_outlined, size: 10, color: Color(0xFF1CB469)),
                            SizedBox(width: 2),
                            Text(
                              '8 MINS',
                              style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Color(0xFF1CB469)),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Bottom Left 'Ad' Badge if applicable
                  if (isAd)
                    Positioned(
                      bottom: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.grey.shade300, width: 0.6),
                        ),
                        child: Text(
                          'Ad',
                          style: TextStyle(fontSize: 8, fontWeight: FontWeight.w700, color: Colors.grey.shade600),
                        ),
                      ),
                    ),

                  // Bottom Right Floating Add Button
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Obx(() {
                      final quantity = cartController.getQuantity(product.id);

                      if (quantity == 0) {
                        return GestureDetector(
                          onTap: () => cartController.addToCart(product),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFF0145A), width: 1.8),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                color: Color(0xFFF0145A),
                                size: 22,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0145A),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFF0145A).withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: () => cartController.removeFromCart(product.id),
                                behavior: HitTestBehavior.opaque,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  child: Icon(Icons.remove, color: Colors.white, size: 15),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  '$quantity',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => cartController.addToCart(product),
                                behavior: HitTestBehavior.opaque,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                  child: Icon(Icons.add, color: Colors.white, size: 15),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),

            // Product Details (Price Tag, Name, Weight)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 2.0, right: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Row with Green Pill & Strikethrough
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6.5, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF248232),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF248232).withValues(alpha: 0.2),
                              blurRadius: 3,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          '₹${product.price.toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      if (originalPrice > product.price.toInt()) ...[
                        const SizedBox(width: 5),
                        Text(
                          '₹$originalPrice',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w600,
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 5),

                  // Product Title (2 lines max)
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12.5,
                      height: 1.22,
                      color: Color(0xFF1F2937),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),

                  // Pack Size / Weight Description
                  Text(
                    product.description.isNotEmpty ? product.description : '1 pack',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
