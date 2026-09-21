import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../models/product_model.dart';
import '../widgets/floating_cart_banner.dart';
import '../widgets/global_offer_banner.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find<ProductController>();
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        centerTitle: true,
      ),
      body: Obx(() {
        if (productController.isLoading.value && productController.products.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFFFF006E)));
        }

        final products = productController.getProductsByCategory(categoryName);

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_basket_outlined, size: 64, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'No products found in "$categoryName"',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Explore our other fresh categories!',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
          );
        }

        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.68,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return _buildCategoryProductCard(product, cartController);
                    },
                  ),
                ),
              ],
            ),
            const GlobalOfferBanner(),
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FloatingCartBanner(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryProductCard(ProductModel product, CartController cartController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200, width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Container with 8 MINS badge and ADD button
          Container(
            height: 130,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.networkImage,
                        fit: BoxFit.contain,
                        height: 100,
                        width: 100,
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
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFFFF006E)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // 8 MINS Badge
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
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
                // ADD / Counter Button
                Positioned(
                  bottom: 6,
                  right: 6,
                  child: _buildAddButton(product, cartController),
                ),
              ],
            ),
          ),

          // Details Section
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '₹${product.price.toInt()}',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '₹${(product.price * 1.3).toInt()}',
                      style: TextStyle(color: Colors.grey.shade400, decoration: TextDecoration.lineThrough, fontSize: 11.5),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.name,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5, height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  product.description.isNotEmpty ? product.description : '1 unit',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(ProductModel product, CartController cartController) {
    return Obx(() {
      final quantity = cartController.getQuantity(product.id);
      if (quantity == 0) {
        return InkWell(
          onTap: () => cartController.addToCart(product),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFFF006E), width: 1.2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4, offset: const Offset(0, 2)),
              ],
            ),
            child: const Text(
              'ADD',
              style: TextStyle(
                color: Color(0xFFFF006E),
                fontWeight: FontWeight.w800,
                fontSize: 11.5,
              ),
            ),
          ),
        );
      } else {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFFF006E),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => cartController.removeFromCart(product.id),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Icon(Icons.remove, color: Colors.white, size: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  '$quantity',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 12),
                ),
              ),
              InkWell(
                onTap: () => cartController.addToCart(product),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  child: Icon(Icons.add, color: Colors.white, size: 14),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
