import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../widgets/floating_cart_banner.dart';
import '../widgets/global_offer_banner.dart';
import '../widgets/product_card.dart';

class SuperMallScreen extends StatefulWidget {
  const SuperMallScreen({super.key});

  @override
  State<SuperMallScreen> createState() => _SuperMallScreenState();
}

class _SuperMallScreenState extends State<SuperMallScreen> {
  late final ProductController productController;
  late final CartController cartController;

  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Electronics & Gadgets',
    'Beauty & Personal Care',
    'Home & Living',
    'Kitchen Appliances',
    'Toys & Kids',
  ];

  final List<Map<String, String>> _featuredBrands = [
    {'name': 'boAt', 'tag': 'UPTO 70% OFF', 'color': '0xFFFDE8E8'},
    {'name': 'Philips', 'tag': 'APPLIANCES', 'color': '0xFFE1EFFE'},
    {'name': 'Nykaa', 'tag': 'GLAM PICKS', 'color': '0xFFFDF2F8'},
    {'name': 'Noise', 'tag': 'SMARTWATCHES', 'color': '0xFFF3F4F6'},
    {'name': 'Milton', 'tag': 'HOME & KITCHEN', 'color': '0xFFDEF7EC'},
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
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // 1. SuperMall Header Bar
                _buildSuperMallHeader(),

                // 2. Category Horizontal Tabs
                _buildCategoryTabs(),

                // 3. Products Grid & Featured Brand Carousel
                Expanded(
                  child: Obx(() {
                    final products = productController.getSuperMallProducts(_selectedCategory);

                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 100),
                      children: [
                        // SuperMall Flash Deal Banner
                        _buildFlashSaleBanner(),

                        // Featured Brand Spotlights
                        _buildBrandSpotlight(),

                        // Section Title
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            'SuperMall Collections (${products.length} Items)',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                            ),
                          ),
                        ),

                        // Products Grid
                        if (products.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Center(
                              child: Text(
                                'No products found in this SuperMall section.',
                                style: TextStyle(color: Colors.grey),
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
                                mainAxisSpacing: 14,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.70,
                              ),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                return _buildMallProductCard(products[index]);
                              },
                            ),
                          ),
                      ],
                    );
                  }),
                ),
              ],
            ),

            // Global Offer Banner (Free Delivery bottom banner)
            const GlobalOfferBanner(),

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

  Widget _buildSuperMallHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
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
                    'SuperMall',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBBF24),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '15 MINS',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'Electronics, Fashion, Home & More',
                style: TextStyle(fontSize: 11, color: Colors.white70),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
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
                color: isSelected ? const Color(0xFF1D4ED8) : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF1E40AF),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFlashSaleBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE047),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '⚡ FLASH SUPER SALE',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.black87),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Up to 70% Off on\nElectronics & Decor',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.headset_mic_rounded, size: 56, color: Colors.white70),
        ],
      ),
    );
  }

  Widget _buildBrandSpotlight() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            'Brand Spotlight',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
        ),
        SizedBox(
          height: 72,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _featuredBrands.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final brand = _featuredBrands[index];
              return Container(
                width: 120,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(int.parse(brand['color']!)),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand['name']!,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.black87),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      brand['tag']!,
                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMallProductCard(ProductModel product) {
    return ProductCard(
      product: product,
      badgeText: 'SUPERMALL',
      badgeColor: const Color(0xFF1D4ED8),
      width: null,
      imageHeight: 125,
    );
  }
}
