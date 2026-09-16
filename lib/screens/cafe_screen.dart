import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../widgets/floating_cart_banner.dart';

class CafeScreen extends StatefulWidget {
  const CafeScreen({super.key});

  @override
  State<CafeScreen> createState() => _CafeScreenState();
}

class _CafeScreenState extends State<CafeScreen> {
  final ProductController productController = Get.find<ProductController>();
  final CartController cartController = Get.find<CartController>();
  
  String activeTab = 'Cafe';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopNavTabs(),
                    _buildPromotionalBanner(),
                    _buildTags(),
                    const SizedBox(height: 16),
                    _buildHorizontalSection('Handpicked For You!'),
                    const SizedBox(height: 24),
                    _buildHorizontalSection('Recommended for you'),
                    const SizedBox(height: 24),
                    _buildHorizontalSection('Price drop starting from ₹39', hasSeeAll: true),
                    const SizedBox(height: 100), // padding for cart banner
                  ],
                ),
              ),
            ],
          ),
          const Positioned(
            bottom: 0, left: 0, right: 0,
            child: FloatingCartBanner(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFFDE8B3), // matching the yellow background from the image
      elevation: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.black, size: 16),
                    const Text('6 minutes', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Row(
                  children: [
                    const Text('Other - 1895, 1895, Phase 5, Sector...', style: TextStyle(color: Colors.black87, fontSize: 12)),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.black87, size: 16),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Colors.purple, size: 16),
                  const SizedBox(width: 4),
                  const Text('₹0', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const CircleAvatar(
              backgroundColor: Colors.black,
              radius: 16,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Container(
            height: 44,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Icon(Icons.search, color: Colors.grey)),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search "Milk"',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                ),
                Container(width: 1, height: 24, color: Colors.grey.shade300),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Image.asset('assets/icons/Tea_Coffee_more.jpg', width: 24, height: 24, errorBuilder: (c,e,s) => const Icon(Icons.card_giftcard, size: 20, color: Colors.redAccent)),
                      const SizedBox(width: 4),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Teacher\'s', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text('Day', style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavTabs() {
    return Container(
      color: const Color(0xFFFDE8B3),
      padding: const EdgeInsets.only(bottom: 0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildTopNavItem('All', 'assets/icons/Fruits_veg.jpg'),
              _buildTopNavItem('Mall', 'assets/icons/Biscuits.jpg'),
              _buildTopNavItem('Cafe', 'assets/icons/Zepto_cafe.jpg'),
              _buildTopNavItem('Fresh', 'assets/icons/Fruits_veg.jpg'),
              _buildTopNavItem('Ganesh Cha...', 'assets/icons/Sweets_craving.jpg'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavItem(String title, String imageAsset) {
    bool isSelected = activeTab == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          activeTab = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(imageAsset, width: 36, height: 36, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(width: 36, height: 36, color: Colors.grey.shade200),
              ),
            ),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, fontSize: 13, color: Colors.black87)),
            const SizedBox(height: 6),
            Container(height: 3, width: 40, decoration: BoxDecoration(color: isSelected ? Colors.black : Colors.transparent, borderRadius: BorderRadius.circular(1.5))),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionalBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          height: 100,
          color: Colors.deepPurpleAccent,
          child: Stack(
            children: [
              const Center(
                child: Text('FLAT\n35% OFF', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
              ),
              Positioned(top: -10, left: -10, child: Icon(Icons.star, color: Colors.white.withOpacity(0.3), size: 40)),
              Positioned(bottom: 10, right: 20, child: Icon(Icons.star, color: Colors.white.withOpacity(0.5), size: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTags() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.orange.shade50.withOpacity(0.5),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.orange.shade100),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.room_service, color: Colors.purple, size: 18),
              const SizedBox(width: 8),
              const Text('Made to order', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(width: 12),
              Container(width: 1, height: 16, color: Colors.grey.shade400),
              const SizedBox(width: 12),
              const Icon(Icons.star, color: Colors.purple, size: 18),
              const SizedBox(width: 8),
              const Text('Rated 4.4 by 1M+', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalSection(String title, {bool hasSeeAll = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        (constraints.constrainWidth() / 6).floor(),
                        (index) => SizedBox(width: 3, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey.shade300))),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 260,
          child: Obx(() {
            final cafeProducts = productController.getProductsByCategory('Cafe');
            if (cafeProducts.isEmpty) return const SizedBox();
            
            // Just for variety between the sections, we shuffle/reverse the Cafe products
            final items = title.length % 2 == 0 ? cafeProducts.toList() : cafeProducts.reversed.toList();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length.clamp(0, 6),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: SizedBox(
                    width: 140,
                    child: _buildCafeProductCard(items[index]),
                  ),
                );
              },
            );
          }),
        ),
        if (hasSeeAll)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Center(
              child: OutlinedButton(
                onPressed: () {
                  Get.toNamed('/cafe-category');
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('See all', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: Colors.black87, size: 20),
                  ],
                ),
              ),
            ),
          )
      ],
    );
  }

  Widget _buildCafeProductCard(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 140,
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
              Positioned(
                bottom: 8, left: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                  child: Icon(Icons.stop_circle_outlined, color: Colors.green.shade700, size: 16),
                ),
              ),
              Positioned(
                bottom: -12, right: 8,
                child: _buildWideAddButton(product),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 6),
        Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 4),
        Text('120 g', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.purple,
      unselectedItemColor: Colors.grey,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
      currentIndex: 0, // Assuming Home/Cafe is active
      onTap: (index) {
        if (index == 0) {
          Get.offNamed('/home'); // Go back to regular home
        }
        // Other taps could route to respective pages
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.percent), label: 'Price Drop'),
        BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Spotlight'),
      ],
    );
  }
}
