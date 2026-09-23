import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../widgets/floating_cart_banner.dart';
import '../widgets/product_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel? product;

  const ProductDetailsScreen({super.key, this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final ProductModel item;
  late final CartController cartController;
  late final ProductController productController;

  @override
  void initState() {
    super.initState();
    cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    if (widget.product != null) {
      item = widget.product!;
    } else if (Get.arguments is ProductModel) {
      item = Get.arguments as ProductModel;
    } else {
      item = ProductModel(
        id: 'default_item',
        name: 'Fresh Product',
        networkImage: 'assets/icons/fruits_veg.jpg',
        price: 99,
        offer: '10% OFF',
        description: 'Fresh quality product delivered right to your doorstep.',
        category: 'Fruits & Vegetables',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final originalPrice = (item.price * 1.25).toInt();
    final savings = originalPrice - item.price.toInt();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Text(
          item.category.isNotEmpty ? item.category : 'Product Details',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.black87),
            onPressed: () {
              Get.snackbar('Share', 'Product link copied to clipboard!');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Hero Image Container
                Container(
                  width: double.infinity,
                  height: 280,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Center(
                        child: Hero(
                          tag: 'product_img_${item.id}',
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: item.networkImage.startsWith('http')
                                ? Image.network(
                                    item.networkImage,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  )
                                : Image.asset(
                                    item.networkImage,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported_outlined,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      if (item.offer.isNotEmpty)
                        Positioned(
                          top: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF9852F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.offer,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 2. Main Title, Price & Quantity Stepper
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Fast delivery badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3E8FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.bolt, size: 14, color: Color(0xFF9852F9)),
                                SizedBox(width: 4),
                                Text(
                                  '10 MINS DELIVERY',
                                  style: TextStyle(
                                    color: Color(0xFF9852F9),
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.verified, size: 16, color: Colors.green),
                          const SizedBox(width: 4),
                          const Text(
                            '100% Genuine',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Product Title
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1F2937),
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '1 unit (Standard Pack)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Price and Add to Cart Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${item.price.toInt()}',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '₹$originalPrice',
                                    style: TextStyle(
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              if (savings > 0) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'You save ₹$savings',
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF059669),
                                  ),
                                ),
                              ],
                            ],
                          ),

                          // Reactive Cart Button
                          Obx(() {
                            final qty = cartController.getItemQuantity(item.id);
                            if (qty == 0) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF0145A),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                                ),
                                onPressed: () => cartController.addToCart(item),
                                child: const Text(
                                  'ADD',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }

                            return Container(
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0145A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove, size: 16, color: Colors.white),
                                    onPressed: () => cartController.decrementQuantity(item.id),
                                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    padding: EdgeInsets.zero,
                                  ),
                                  Text(
                                    '$qty',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                                    onPressed: () => cartController.addToCart(item),
                                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                    padding: EdgeInsets.zero,
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 3. Why Shop on Zepto Guarantees
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Why Shop on Zepto?',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildGuaranteeRow(
                        Icons.timer_outlined,
                        'Superfast 10 Mins Delivery',
                        'Directly picked and packed from your nearest Zepto dark store.',
                      ),
                      const SizedBox(height: 12),
                      _buildGuaranteeRow(
                        Icons.verified_outlined,
                        'Best Prices & Freshness Guaranteed',
                        'Quality inspected products sourced directly from verified distributors.',
                      ),
                      const SizedBox(height: 12),
                      _buildGuaranteeRow(
                        Icons.refresh_rounded,
                        'Easy Replacement & Instant Refund',
                        'Not satisfied? Get instant refund directly into your Zepto Cash wallet.',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 4. Product Details & Specifications
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Product Details',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.description.isNotEmpty
                            ? item.description
                            : 'Authentic high-quality product packed under hygienic conditions. Enjoy rich taste, fresh quality, and instant 10-minute dark store delivery.',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSpecRow('Shelf Life', '3 to 6 Months'),
                      _buildSpecRow('Country of Origin', 'India'),
                      _buildSpecRow('Seller', 'Zepto Retail Private Limited'),
                      _buildSpecRow('FSSAI License', '10019022009876'),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 5. Similar Products Carousel
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Similar Products',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 205,
                        child: Obx(() {
                          final similar = productController.getProductsByCategory(item.category)
                              .where((p) => p.id != item.id)
                              .take(6)
                              .toList();

                          if (similar.isEmpty) {
                            return const Center(child: Text('No more items in this category'));
                          }

                          return ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: similar.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final p = similar[index];
                              return ProductCard(
                                product: p,
                                width: 140,
                                imageHeight: 114,
                                margin: EdgeInsets.zero,
                                onTap: () {
                                  Get.to(() => ProductDetailsScreen(product: p), preventDuplicates: false);
                                },
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Cart Banner at bottom
          const Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: FloatingCartBanner(),
          ),
        ],
      ),
    );
  }

  Widget _buildGuaranteeRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3EDFD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF3F007D)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
