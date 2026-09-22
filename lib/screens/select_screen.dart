import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../widgets/floating_cart_banner.dart';
import '../widgets/global_offer_banner.dart';
import 'product_details_screen.dart';

class SelectScreen extends StatefulWidget {
  const SelectScreen({super.key});

  @override
  State<SelectScreen> createState() => _SelectScreenState();
}

class _SelectScreenState extends State<SelectScreen> {
  late final ProductController productController;
  late final CartController cartController;

  String _selectedCategory = 'All Select';
  final List<String> _categories = [
    'All Select',
    'Exotic Fruits & Veg',
    'Organic Dairy',
    'Artisan Bakery',
    'Meat & Protein',
    'Gourmet Chocolates',
  ];

  @override
  void initState() {
    super.initState();
    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());
    cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2), // Premium luxury cream background
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. Premium Top Bar
                _buildSelectTopBar(),

                // 2. Global Offer Banner
                const GlobalOfferBanner(),

                // 3. Category Filter Tabs
                _buildCategoryTabs(),

                // 4. Products Grid
                Expanded(
                  child: Obx(() {
                    final products = productController.getSelectProducts(_selectedCategory);

                    if (products.isEmpty) {
                      return const Center(
                        child: Text(
                          'No gourmet products found in this category.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      );
                    }

                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _buildSelectProductCard(products[index]);
                      },
                    );
                  }),
                ),
              ],
            ),

            // Floating Cart Banner
            const Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: FloatingCartBanner(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF2A1B18), // Deep luxury espresso tone
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'select',
                    style: TextStyle(
                      fontFamily: 'serif',
                      fontSize: 21,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFE5C378), // Luxury gold
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5C378),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'GOURMET',
                      style: TextStyle(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2A1B18),
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'Handpicked & Artisan Finds • 10 Mins Delivery',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, color: Color(0xFFE5C378)),
            onPressed: () => Get.toNamed('/search'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 48,
      color: Colors.white,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        itemCount: _categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = cat;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF2A1B18) : const Color(0xFFF3EFEA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFFE5C378) : Colors.transparent,
                  width: 1.2,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? const Color(0xFFE5C378) : const Color(0xFF4A3E3D),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectProductCard(ProductModel product) {
    final originalPrice = (product.price * 1.3).toInt();

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsScreen(product: product)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEFE8DC), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail with Select Badge
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: 'product_img_${product.id}',
                      child: product.networkImage.startsWith('http')
                          ? Image.network(product.networkImage, fit: BoxFit.contain)
                          : Image.asset(product.networkImage, fit: BoxFit.contain),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A1B18),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFE5C378), width: 0.8),
                      ),
                      child: const Text(
                        'SELECT',
                        style: TextStyle(
                          color: Color(0xFFE5C378),
                          fontSize: 8.5,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Product Name
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Artisan Batch',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 8),

            // Price & Add to Cart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${product.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2A1B18),
                      ),
                    ),
                    Text(
                      '₹$originalPrice',
                      style: TextStyle(
                        fontSize: 11,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),

                // Cart Counter Button
                Obx(() {
                  final qty = cartController.getItemQuantity(product.id);
                  if (qty == 0) {
                    return SizedBox(
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A1B18),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: const BorderSide(color: Color(0xFFE5C378), width: 1),
                          ),
                        ),
                        onPressed: () => cartController.addToCart(product),
                        child: const Text(
                          'ADD',
                          style: TextStyle(
                            color: Color(0xFFE5C378),
                            fontWeight: FontWeight.w900,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }

                  return Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A1B18),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE5C378), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 14, color: Color(0xFFE5C378)),
                          onPressed: () => cartController.decrementQuantity(product.id),
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          padding: EdgeInsets.zero,
                        ),
                        Text(
                          '$qty',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 14, color: Color(0xFFE5C378)),
                          onPressed: () => cartController.addToCart(product),
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
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
    );
  }
}
