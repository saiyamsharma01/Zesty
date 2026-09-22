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
  String _selectedDietary = 'All';
  String _sortBy = 'Popularity';

  final List<String> _categories = [
    'All Select',
    'Exotic Fruits & Veg',
    'Organic Dairy',
    'Artisan Bakery',
    'Meat & Protein',
    'Gourmet Chocolates',
  ];

  final List<String> _dietaryFilters = [
    'All',
    '100% Organic',
    'High Protein',
    'Imported',
    'Vegan',
    'Gluten Free',
    'Chef\'s Special',
  ];

  final List<Map<String, String>> _gourmetSpotlights = [
    {
      'title': 'The French Bakery &\nArtisan Croissants',
      'tag': 'AUTHENTIC & FRESH',
      'desc': 'Flaky, buttery pastries baked fresh every morning.',
      'icon': '🥐',
      'color': '0xFF3E2723',
    },
    {
      'title': 'Exotic Blueberries &\nNew Zealand Kiwis',
      'tag': 'HARVEST PICKS',
      'desc': 'Handpicked berries bursting with rich antioxidants.',
      'icon': '🫐',
      'color': '0xFF1A237E',
    },
    {
      'title': 'Artisan Cheeses &\nGourmet Truffles',
      'tag': 'CURATED FINDS',
      'desc': 'European aged cheddars, burrata & truffle drizzles.',
      'icon': '🧀',
      'color': '0xFF4E342E',
    },
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

  List<ProductModel> _getFilteredProducts() {
    List<ProductModel> list = List.from(productController.getSelectProducts(_selectedCategory));

    if (_selectedDietary != 'All') {
      final key = _selectedDietary.toLowerCase();
      list = list.where((p) {
        if (key.contains('organic')) return p.name.toLowerCase().contains('organic') || p.category.contains('Vegetable');
        if (key.contains('protein')) return p.name.toLowerCase().contains('paneer') || p.name.toLowerCase().contains('egg') || p.name.toLowerCase().contains('chicken') || p.name.toLowerCase().contains('tofu');
        if (key.contains('imported')) return p.name.toLowerCase().contains('avocado') || p.name.toLowerCase().contains('chocolate') || p.name.toLowerCase().contains('coffee') || p.name.toLowerCase().contains('kiwi');
        if (key.contains('vegan')) return !p.category.contains('Dairy') && !p.category.contains('Meat');
        if (key.contains('gluten')) return !p.name.toLowerCase().contains('bread');
        return true;
      }).toList();
    }

    if (_sortBy == 'Price: Low to High') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'Price: High to Low') {
      list.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'Discounts') {
      list.sort((a, b) => b.offer.compareTo(a.offer));
    }

    return list;
  }

  void _showSortSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort Products By', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...['Popularity', 'Price: Low to High', 'Price: High to Low', 'Discounts'].map(
              (opt) => ListTile(
                title: Text(opt, style: TextStyle(fontWeight: _sortBy == opt ? FontWeight.bold : FontWeight.normal)),
                trailing: _sortBy == opt ? const Icon(Icons.check, color: Color(0xFF2A1B18)) : null,
                onTap: () {
                  setState(() => _sortBy = opt);
                  Navigator.pop(ctx);
                },
              ),
            ),
          ],
        ),
      ),
    );
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

                // 4. Scrollable Content (Carousel + Dietary Chips + Sort Bar + Grid)
                Expanded(
                  child: Obx(() {
                    final products = _getFilteredProducts();

                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      children: [
                        // Spotlight Gourmet Carousel
                        _buildSpotlightCarousel(),

                        // Dietary Preferences Row
                        _buildDietaryPills(),

                        // Sorting & Counter Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${products.length} Gourmet Finds',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2A1B18),
                                ),
                              ),
                              GestureDetector(
                                onTap: _showSortSheet,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: const Color(0xFFE5C378)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.sort, size: 14, color: Color(0xFF2A1B18)),
                                      const SizedBox(width: 4),
                                      Text(
                                        _sortBy,
                                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Color(0xFF2A1B18)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Products Grid
                        if (products.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(40.0),
                            child: Center(
                              child: Text(
                                'No products match your selected gourmet filter.',
                                style: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                            ),
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.63,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return _buildSelectProductCard(products[index]);
                              },
                            ),
                          ),
                      ],
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
                color: Colors.white.withValues(alpha: 0.12),
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

  Widget _buildSpotlightCarousel() {
    return Container(
      height: 125,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _gourmetSpotlights.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final spot = _gourmetSpotlights[index];
          return Container(
            width: 260,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Color(int.parse(spot['color']!)),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5C378).withValues(alpha: 0.3), width: 1.2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5C378),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          spot['tag']!,
                          style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFF2A1B18)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        spot['title']!,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
                      ),
                    ],
                  ),
                ),
                Text(
                  spot['icon']!,
                  style: const TextStyle(fontSize: 42),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDietaryPills() {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(top: 10),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _dietaryFilters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final diet = _dietaryFilters[index];
          final isSelected = _selectedDietary == diet;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDietary = diet;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE5C378) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? const Color(0xFF2A1B18) : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  diet,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
                    color: isSelected ? const Color(0xFF2A1B18) : Colors.black87,
                  ),
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
              color: Colors.black.withValues(alpha: 0.02),
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
