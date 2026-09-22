import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../widgets/floating_cart_banner.dart';
import 'product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  late final ProductController productController;
  late final CartController cartController;

  final RxString _searchQuery = ''.obs;
  final List<String> _trendingSearches = [
    'Milk',
    'Amul Butter',
    'Bread',
    'Eggs',
    'Cold Coffee',
    'Chips',
    'Paneer',
    'Nutella',
    'Banana',
    'Coca Cola',
    'Maggi',
    'Ice Cream',
    'Atta',
    'Curd',
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());
    cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTagSelected(String tag) {
    _searchController.text = tag;
    _searchQuery.value = tag;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. Top Search Header
                _buildSearchHeader(),

                // 2. Search Body
                Expanded(
                  child: Obx(() {
                    final query = _searchQuery.value.trim();

                    if (query.isEmpty) {
                      return _buildInitialSearchSuggestions();
                    }

                    final results = productController.searchProducts(query);

                    if (results.isEmpty) {
                      return _buildEmptyResultsState(query);
                    }

                    return _buildSearchResultsGrid(results);
                  }),
                ),
              ],
            ),

            // Bottom Floating Cart Banner
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

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Get.back(),
          ),
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300, width: 0.8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Color(0xFF9852F9), size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (val) => _searchQuery.value = val,
                      style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        hintText: 'Search for milk, chips, vegetables...',
                        hintStyle: TextStyle(fontSize: 13.5, color: Colors.grey),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                  Obx(() {
                    if (_searchQuery.value.isNotEmpty) {
                      return GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _searchQuery.value = '';
                        },
                        child: const Icon(Icons.close, color: Colors.grey, size: 20),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialSearchSuggestions() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      children: [
        // Trending Section
        Row(
          children: const [
            Icon(Icons.trending_up, size: 20, color: Color(0xFFF0145A)),
            SizedBox(width: 8),
            Text(
              'Trending Searches',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: _trendingSearches.map((tag) {
            return InkWell(
              onTap: () => _onTagSelected(tag),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 0.9),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.search, size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // Popular Categories
        const Text(
          'Popular Categories',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.9,
          children: [
            _buildCategoryPill('Fruits & Veg', 'assets/icons/fruits_veg.jpg', 'Fruits'),
            _buildCategoryPill('Dairy & Bread', 'assets/icons/Dairy_bread.jpg', 'Dairy'),
            _buildCategoryPill('Snacks', 'assets/icons/Munchies.jpg', 'Chips'),
            _buildCategoryPill('Zepto Cafe', 'assets/icons/Zepto_cafe.jpg', 'Cafe'),
            _buildCategoryPill('Ice Creams', 'assets/icons/Icecreams_more.jpg', 'Ice Cream'),
            _buildCategoryPill('Beverages', 'assets/icons/Cold_drinks_juices.jpg', 'Juice'),
          ],
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCategoryPill(String title, String image, String searchKeyword) {
    return InkWell(
      onTap: () => _onTagSelected(searchKeyword),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(image, fit: BoxFit.contain),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResultsGrid(List<ProductModel> results) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        Text(
          'Showing ${results.length} results for "${_searchQuery.value}"',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemCount: results.length,
          itemBuilder: (context, index) {
            final product = results[index];
            return _buildProductSearchCard(product);
          },
        ),
      ],
    );
  }

  Widget _buildProductSearchCard(ProductModel product) {
    final originalPrice = (product.price * 1.25).toInt();

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailsScreen(product: product)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 1.1),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image + Offer Badge
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
                  if (product.offer.isNotEmpty)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF9852F9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          product.offer,
                          style: const TextStyle(color: Colors.white, fontSize: 9.5, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1F2937)),
            ),
            const SizedBox(height: 2),
            Text(
              '1 unit',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 8),

            // Price & Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹${product.price.toInt()}',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.black87),
                    ),
                    Text(
                      '₹$originalPrice',
                      style: TextStyle(fontSize: 11, decoration: TextDecoration.lineThrough, color: Colors.grey.shade400),
                    ),
                  ],
                ),
                Obx(() {
                  final qty = cartController.getItemQuantity(product.id);
                  if (qty == 0) {
                    return SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFF0145A),
                          side: const BorderSide(color: Color(0xFFF0145A), width: 1.2),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        onPressed: () => cartController.addToCart(product),
                        child: const Text('ADD', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      ),
                    );
                  }

                  return Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0145A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove, size: 14, color: Colors.white),
                          onPressed: () => cartController.decrementQuantity(product.id),
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          padding: EdgeInsets.zero,
                        ),
                        Text(
                          '$qty',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 14, color: Colors.white),
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

  Widget _buildEmptyResultsState(String query) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 30),
        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          'No matches found for "$query"',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(
          'Check for typos or try searching for general terms like "Milk", "Bread", or "Snacks".',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 32),
        const Text(
          'Popular Items You Might Like',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemCount: productController.products.take(4).length,
          itemBuilder: (context, index) {
            return _buildProductSearchCard(productController.products[index]);
          },
        ),
      ],
    );
  }
}
