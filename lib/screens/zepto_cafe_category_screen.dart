import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../widgets/floating_cart_banner.dart';
import '../widgets/cafe_filter_bottom_sheet.dart';

class ZeptoCafeCategoryScreen extends StatefulWidget {
  const ZeptoCafeCategoryScreen({super.key});

  @override
  State<ZeptoCafeCategoryScreen> createState() => _ZeptoCafeCategoryScreenState();
}

class _ZeptoCafeCategoryScreenState extends State<ZeptoCafeCategoryScreen> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  
  String selectedFilter = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              _buildFilterRow(),
              Expanded(
                child: Obx(() {
                  if (productController.products.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  // Filter for Cafe products and apply type filter if selected
                  final allCafeProducts = productController.getProductsByCategory('Cafe');
                  final displayedProducts = allCafeProducts.where((p) {
                    if (selectedFilter.isNotEmpty) {
                      // For simplicity, checking if the product name contains the filter word
                      // The real app would have more robust metadata for tags/types
                      return p.name.toLowerCase().contains(selectedFilter.toLowerCase());
                    }
                    return true;
                  }).toList();

                  if (displayedProducts.isEmpty) {
                    return const Center(child: Text('No products found matching the filter'));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // padding for cart banner
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 24, // increased for the wide add button
                      childAspectRatio: 0.70, // taller cards
                    ),
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      return _buildCafeCategoryCard(displayedProducts[index]);
                    },
                  );
                }),
              ),
            ],
          ),
          const Positioned(
            bottom: 0, left: 0, right: 0,
            child: FloatingCartBanner(),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => Get.back(),
      ),
      title: const Text('Price drop starting from 39', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      titleSpacing: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: Colors.grey.shade200, height: 1),
      ),
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterIconButton(),
            const SizedBox(width: 12),
            _buildFilterPill('Type', isDropdown: true),
            const SizedBox(width: 12),
            _buildFilterPill('Tea', imageAsset: 'assets/icons/Tea_Coffee_more.jpg'),
            const SizedBox(width: 12),
            _buildFilterPill('Maggi', imageAsset: 'assets/icons/Munchies.jpg'), // using munchies as placeholder
            const SizedBox(width: 12),
            _buildFilterPill('Chaat', imageAsset: 'assets/icons/Biscuits.jpg'), // placeholder
          ],
        ),
      ),
    );
  }

  Widget _buildFilterIconButton() {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          builder: (context) => const CafeFilterBottomSheet(),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.tune, size: 20, color: Colors.black87),
      ),
    );
  }

  Widget _buildFilterPill(String title, {bool isDropdown = false, String? imageAsset}) {
    bool isSelected = selectedFilter == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = isSelected ? '' : title;
        });
        if (isDropdown) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            builder: (context) => const CafeFilterBottomSheet(),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.shade50 : Colors.white,
          border: Border.all(color: isSelected ? Colors.purple : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (imageAsset != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(imageAsset, width: 20, height: 20, fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(width: 20, height: 20, color: Colors.grey.shade200),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isSelected ? Colors.purple : Colors.black87)),
            if (isDropdown) ...[
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down, size: 18, color: isSelected ? Colors.purple : Colors.black87),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCafeCategoryCard(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.networkImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: Colors.grey.shade200, child: const Center(child: Icon(Icons.fastfood, color: Colors.grey)));
                  },
                ),
              ),
              // Veg/Non-veg icon
              Positioned(
                bottom: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  child: Icon(Icons.stop_circle_outlined, color: Colors.green.shade700, size: 16),
                ),
              ),
              // Wide Add Button spanning card width bottom corner
              Positioned(
                bottom: 8, right: 8,
                child: _buildWideAddButton(product),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Price Row
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.green.shade700, borderRadius: BorderRadius.circular(6)),
              child: Text('₹${product.price.toInt()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            const SizedBox(width: 6),
            Text('₹${(product.price * 1.5).toInt()}', style: const TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        Text('1 serving', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ],
    );
  }

  Widget _buildWideAddButton(ProductModel product) {
    return GestureDetector(
      onTap: () {
        cartController.addToCart(product);
      },
      child: Container(
        width: 100, // wider button
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFF0145A), width: 1.5),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('ADD', style: TextStyle(color: Color(0xFFF0145A), fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 1.2)),
            if (product.offer.isNotEmpty && product.offer != 'ADD')
              Text(product.offer, style: TextStyle(color: Colors.grey.shade500, fontSize: 9, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
