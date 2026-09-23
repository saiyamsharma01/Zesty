import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/location_controller.dart';
import '../models/product_model.dart';
import '../models/coupon_model.dart';
import '../widgets/coupon_details_bottom_sheet.dart';
import 'category_screen.dart';
import 'manage_products_screen.dart';
import 'all_categories_screen.dart';
import '../widgets/global_offer_banner.dart';
import '../widgets/floating_cart_banner.dart';
import '../controllers/cart_controller.dart';
import '../routes/app_routes.dart';
import '../widgets/product_card.dart';
import 'product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  final RxBool _showBackToTop = false.obs;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 400 && !_showBackToTop.value) {
        _showBackToTop.value = true;
      } else if (_scrollController.offset <= 400 && _showBackToTop.value) {
        _showBackToTop.value = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController(), permanent: true);
    final CartController cartController = Get.put(CartController(), permanent: true);
    final locationController = Get.put(LocationController(), permanent: true);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    color: const Color(0xFFFDE9AA), // Yellow-ish background from screenshot
                    child: Column(
                      children: [
                        _buildHeader(context, locationController),
                        _buildSearchBar(),
                        _buildHeroBanner1(),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildExploreSection(),
                        _buildCouponsAndOffers(),
                        _buildValuePicks(productController, cartController),
                        _buildBuyAgain(productController, cartController),
                        _buildHeroBanner2(),
                        _buildBloomSection(productController, cartController),
                        _buildStealDeals(productController, cartController),
                        _buildFreshSection(productController, cartController),
                        _buildBlockbusterDeals(productController, cartController),
                        _buildClearanceSale(productController, cartController),
                        const SizedBox(height: 100),
                      ],
                    ),
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
            Obx(() {
              if (!_showBackToTop.value) return const SizedBox();
              return Positioned(
                top: 70, // Below the GlobalOfferBanner
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      _scrollController.animateTo(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.black.withOpacity(0.8), borderRadius: BorderRadius.circular(20)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Back to top', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_upward, color: Colors.white, size: 14),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
        onTap: (index) {
          if (index == 1) {
            Get.to(() => const AllCategoriesScreen());
          } else if (index == 3) {
            Get.to(() => const ManageProductsScreen());
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.percent), label: 'Price Drop'),
          BottomNavigationBarItem(icon: Icon(Icons.star_border), label: 'Spotlight'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, LocationController locationController) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showLocationBottomSheet(context, locationController),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.bolt, color: Colors.black87, size: 24),
                      const SizedBox(width: 4),
                      const Text(
                        '5 minutes',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Text(
                            'Other - ${locationController.currentAddress.value}',
                            style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black54),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              Obx(() {
                final authCtrl = Get.find<AuthController>();
                return GestureDetector(
                  onTap: () => Get.toNamed(Routes.profile),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.purple.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet, color: Colors.purple.shade300, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '₹${authCtrl.zeptoCash.value.toInt()}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.profile),
                child: const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.search),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
            ],
          ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(Icons.search, color: Colors.grey, size: 24),
            ),
            const Expanded(
              child: Text(
                'Search "Milk"',
                style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Container(width: 1, height: 30, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 24,
                    decoration: BoxDecoration(color: Colors.red.shade100, borderRadius: BorderRadius.circular(4)),
                    child: const Icon(Icons.fastfood, size: 14, color: Colors.red),
                  ),
                  const SizedBox(width: 6),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Breakfast', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold, height: 1.0)),
                      Text('Express', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold, height: 1.0)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildHeroBanner1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color(0xFFFFE4C4), const Color(0xFFFFDAB9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hot Sips &', style: TextStyle(color: Color(0xFFE95D3E), fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'serif')),
                      const Text('Snack Fest', style: TextStyle(color: Color(0xFFE95D3E), fontSize: 28, fontWeight: FontWeight.w900, fontFamily: 'serif')),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Text('Powered By ', style: TextStyle(fontSize: 10, color: Colors.black54)),
                          _buildBrandIcon(Icons.coffee, Colors.brown),
                          const SizedBox(width: 4),
                          _buildBrandIcon(Icons.local_cafe, Colors.red),
                          const SizedBox(width: 4),
                          _buildBrandIcon(Icons.emoji_food_beverage, Colors.black),
                        ],
                      ),
                    ],
                  ),
                  Image.asset('assets/icons/Tea_Coffee_more.jpg', height: 80, width: 80, errorBuilder: (c,e,s) => const Icon(Icons.coffee, size: 60, color: Colors.white)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildBannerCard('Top\nDeals', 'Starts at\n₹94', 'assets/icons/Tea_Coffee_more.jpg', height: 210, isLarge: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildBannerCard('Hot Sips & Mixes', 'Starts at\n₹40', 'assets/icons/Tea_Coffee_more.jpg', height: 100),
                        const SizedBox(height: 10),
                        _buildBannerCard('Munch & Slurp', 'Starts at\n₹15', 'assets/icons/Biscuits.jpg', height: 100),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildBannerCard('Frozen Bites', 'Starts at\n₹129', 'assets/icons/frozen_food.jpg', height: 100),
                        const SizedBox(height: 10),
                        _buildBannerCard('Cookies & Cake', 'Starts at\n₹15', 'assets/icons/Biscuits.jpg', height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: Icon(icon, size: 12, color: color),
    );
  }

  Widget _buildBannerCard(String title, String price, String img, {required double height, bool isLarge = false}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isLarge ? 15 : 11,
                    color: Colors.brown.shade900,
                    height: 1.1,
                  ),
                ),
                const Spacer(),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    img,
                    height: isLarge ? 110 : 44,
                    width: isLarge ? 110 : 44,
                    fit: BoxFit.contain,
                    errorBuilder: (c, e, s) => const SizedBox(height: 20),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
          Positioned(
            bottom: isLarge ? 10 : 0,
            left: isLarge ? null : 0,
            right: isLarge ? 10 : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: isLarge ? Colors.white : const Color(0xFFD66046),
                borderRadius: isLarge
                    ? BorderRadius.circular(16)
                    : const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(14),
                      ),
                boxShadow: isLarge ? [BoxShadow(color: Colors.black12, blurRadius: 4)] : [],
              ),
              child: Text(
                price,
                style: TextStyle(
                  color: isLarge ? Colors.brown.shade900 : Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: isLarge ? 13 : 9.5,
                  height: 1.05,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, {bool hasDottedLine = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
          if (hasDottedLine) ...[
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
          ]
        ],
      ),
    );
  }

  Widget _buildExploreSection() {
    final featuredCategories = [
      {'title': 'Pharmacy', 'img': 'assets/icons/cat_pharmacy.jpg', 'color': 0xFFEBF7F5, 'tag': 'UPTO 60%'},
      {'title': 'Price Drop Zone', 'img': 'assets/icons/cat_all.jpg', 'color': 0xFFEAF8EC, 'tag': '80% OFF'},
      {'title': 'Beauty Store', 'img': 'assets/icons/Makeup_Beauty.jpg', 'color': 0xFFFDF0F4, 'tag': 'TRENDING'},
      {'title': 'Baby & Toys', 'img': 'assets/icons/cat_toys.jpg', 'color': 0xFFEFF4FE, 'tag': 'BEST VALUE'},
      {'title': 'Zepto Cafe', 'img': 'assets/icons/Zepto_cafe.jpg', 'color': 0xFFFFF6EB, 'tag': 'HOT & FRESH'},
      {'title': 'Super Mall', 'img': 'assets/icons/cat_electronics.jpg', 'color': 0xFFF3EDFD, 'tag': 'NEW'},
      {'title': 'Fresh Fruits & Veg', 'img': 'assets/icons/fruits_veg.jpg', 'color': 0xFFEBF8EE, 'tag': 'DAILY'},
      {'title': 'Munchies & Snacks', 'img': 'assets/icons/Munchies.jpg', 'color': 0xFFFEF2E8, 'tag': 'CRAVINGS'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Featured'),
        SizedBox(
          height: 104,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: featuredCategories.length,
            itemBuilder: (context, index) {
              final cat = featuredCategories[index];
              return InkWell(
                onTap: () {
                  final title = cat['title'] as String;
                  if (title.contains('Cafe')) {
                    Get.toNamed('/cafe');
                  } else if (title.contains('Mall')) {
                    Get.toNamed('/super-mall');
                  } else {
                    Get.to(() => CategoryScreen(categoryName: title));
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 78,
                  margin: const EdgeInsets.only(right: 14),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Color(cat['color'] as int),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              cat['img'] as String,
                              fit: BoxFit.contain,
                              errorBuilder: (c, e, s) => const Icon(
                                Icons.category_outlined,
                                color: Colors.grey,
                                size: 28,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['title'] as String,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF262C34),
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildExploreCard('Zepto Cafe', 'assets/icons/Zepto_cafe.jpg'),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _buildExploreCard('select\nGourmet finds', 'assets/icons/Icecreams_more.jpg', isWide: true),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(child: _buildExploreCard('Super Mall', 'assets/icons/cat_electronics.jpg')),
              const SizedBox(width: 10),
              Expanded(child: _buildExploreCard('Fresh', 'assets/icons/fruits_veg.jpg')),
              const SizedBox(width: 10),
              Expanded(child: _buildExploreCard('Price Drop', 'assets/icons/cat_all.jpg')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExploreCard(String title, String img, {bool isWide = false}) {
    return GestureDetector(
      onTap: () {
        if (title.contains('select')) {
          Get.toNamed('/select');
        } else if (title.contains('Cafe')) {
          Get.toNamed('/cafe');
        } else if (title.contains('Mall')) {
          Get.toNamed('/super-mall');
        } else {
          Get.to(() => CategoryScreen(categoryName: title));
        }
      },
      child: Container(
        height: 94,
        decoration: BoxDecoration(
          color: isWide ? const Color(0xFFFBF6EF) : const Color(0xFFF9F7FB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isWide ? const Color(0xFFEEDCC8) : const Color(0xFFEAE2F3),
            width: 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image.asset(
                  img,
                  height: 48,
                  width: 48,
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.image, size: 36, color: Colors.grey),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6.0, left: 4.0, right: 4.0),
                child: isWide
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 2),
                          ],
                        ),
                        child: Text(
                          'Gourmet finds',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800,
                          ),
                        ),
                      )
                    : Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11.5,
                          color: Color(0xFF2B303A),
                        ),
                      ),
              ),
            ),
            if (isWide)
              const Positioned(
                top: 8,
                left: 10,
                child: Text(
                  'select',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponsAndOffers() {
    final defaultCoupons = CouponData.defaultCoupons;
    final bankOffers = CouponData.bankOffers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Coupons & Offers'),
        SizedBox(
          height: 84,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: defaultCoupons.length,
            itemBuilder: (context, index) {
              final coupon = defaultCoupons[index];
              return InkWell(
                onTap: () => CouponDetailsBottomSheet.show(context, coupon),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 92,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F0),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFBCE6D0)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFF1CB469),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.percent, color: Colors.white, size: 12),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        coupon.shortTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11.5,
                          height: 1.1,
                          color: Color(0xFF1B2A1E),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(11),
                            bottomRight: Radius.circular(11),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          coupon.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: bankOffers.length,
            itemBuilder: (context, index) {
              final offer = bankOffers[index];
              return InkWell(
                onTap: () => CouponDetailsBottomSheet.show(context, offer),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? const Color(0xFFF0F7FF) : const Color(0xFFFDF4E7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: index % 2 == 0 ? const Color(0xFFD6E8FC) : const Color(0xFFF6DEC2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          index == 0
                              ? Icons.account_balance
                              : index == 1
                                  ? Icons.shopping_bag_outlined
                                  : index == 2
                                      ? Icons.credit_card
                                      : Icons.account_balance_wallet,
                          color: index % 2 == 0 ? Colors.orange.shade700 : Colors.indigo.shade700,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              offer.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              offer.bankSubtitle ?? offer.subtitle,
                              style: const TextStyle(fontSize: 10, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildValuePicks(ProductController productController, CartController cartController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Value Picks'),
        SizedBox(
          height: 200,
          child: Obx(() {
            final items = productController.getValuePicks();
            if (items.isEmpty) return const SizedBox();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildProductCard(items[index], cartController);
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => Get.to(() => const CategoryScreen(categoryName: 'Price Drop')),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.grey.shade50,
              ),
              child: const Text('See All ‣', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBuyAgain(ProductController productController, CartController cartController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Buy Again'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(height: 1.5, color: const Color(0xFFF0145A)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() => Row(
                  children: [
                    GestureDetector(
                      onTap: () => productController.setBuyAgainTab('All Items'),
                      child: _buildGenericTab(title: 'All Items', isSelected: productController.buyAgainTab.value == 'All Items', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade700),
                    ),
                    GestureDetector(
                      onTap: () => productController.setBuyAgainTab('Zepto Cafe'),
                      child: _buildGenericTab(title: 'Zepto Cafe', isSelected: productController.buyAgainTab.value == 'Zepto Cafe', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade700),
                    ),
                    GestureDetector(
                      onTap: () => productController.setBuyAgainTab('Snacks & Drinks'),
                      child: _buildGenericTab(title: 'Snacks & Drinks', isSelected: productController.buyAgainTab.value == 'Snacks & Drinks', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade700),
                    ),
                    GestureDetector(
                      onTap: () => productController.setBuyAgainTab('Sweets & Chocolates'),
                      child: _buildGenericTab(title: 'Sweets & Chocolates', isSelected: productController.buyAgainTab.value == 'Sweets & Chocolates', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade700),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Obx(() {
            final items = productController.getBuyAgainProducts(productController.buyAgainTab.value);
            if (items.isEmpty) return const SizedBox();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildProductCard(items[index], cartController);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeroBanner2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFCECD9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('PROTEIN &', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF5D4037), height: 1.0)),
                  const Text('FITNESS', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF5D4037), height: 1.0)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Powered by ', style: TextStyle(fontSize: 10, color: Colors.black54)),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), color: Colors.red, child: const Text('SUPERYOU', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildBannerCard('Right Fit\nDeals', 'Starts from\n₹349', 'assets/icons/Tea_Coffee_more.jpg', height: 210, isLarge: true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildBannerCard('Protein Powder\n& Supplements', 'UPTO 60% OFF', 'assets/icons/Tea_Coffee_more.jpg', height: 100),
                        const SizedBox(height: 10),
                        _buildBannerCard('Protein\nBites', 'STARTS FROM ₹26', 'assets/icons/Biscuits.jpg', height: 100),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildBannerCard('Healthy Munchies\n& Beverages', 'STARTS FROM ₹25', 'assets/icons/frozen_food.jpg', height: 100),
                        const SizedBox(height: 10),
                        _buildBannerCard('Gym & Sport\nEssentials', 'STARTS FROM ₹79', 'assets/icons/Biscuits.jpg', height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildBloomSection(ProductController productController, CartController cartController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Introducing ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
                  Text('bloom', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.green.shade800, fontFamily: 'serif')),
                ],
              ),
              Text('Handpicked fresh fruits and vegetables', style: TextStyle(fontSize: 13, color: Colors.green.shade700, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: Obx(() {
            final items = productController.getBloomProducts();
            if (items.isEmpty) return const SizedBox();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildProductCard(items[index], cartController, bgColor: const Color(0xFFF0F6E6));
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildStealDeals(ProductController productController, CartController cartController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Steal Deals', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFFF0145A))),
                  const Text('Add Any 10 Items', style: TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(height: 1.5, color: const Color(0xFFF0145A)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() => Row(
                  children: [
                    GestureDetector(onTap: () => productController.setStealDealTab('Trending'), child: _buildGenericTab(title: 'Trending', isSelected: productController.stealDealTab.value == 'Trending', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade800)),
                    GestureDetector(onTap: () => productController.setStealDealTab('₹9 Store'), child: _buildGenericTab(title: '₹9 Store', isSelected: productController.stealDealTab.value == '₹9 Store' || productController.stealDealTab.value == '₹9\nStore', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade800)),
                    GestureDetector(onTap: () => productController.setStealDealTab('₹19 Store'), child: _buildGenericTab(title: '₹19 Store', isSelected: productController.stealDealTab.value == '₹19 Store' || productController.stealDealTab.value == '₹19\nStore', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade800)),
                    GestureDetector(onTap: () => productController.setStealDealTab('₹29 Store'), child: _buildGenericTab(title: '₹29 Store', isSelected: productController.stealDealTab.value == '₹29 Store' || productController.stealDealTab.value == '₹29\nStore', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade800)),
                  ],
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Obx(() {
            final items = productController.getStealDeals(
              productController.stealDealTab.value,
              productController.stealDealSubCategory.value,
            );
            if (items.isEmpty) return const SizedBox();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildProductCard(items[index], cartController);
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => Get.to(() => const CategoryScreen(categoryName: 'Price Drop')),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.grey.shade50,
              ),
              child: const Text('See All ‣', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenericTab({
    required String title,
    required bool isSelected,
    required Color activeColor,
    required Color activeBgColor,
    required Color inactiveColor,
  }) {
    if (isSelected) {
      return Container(
        decoration: BoxDecoration(
          color: activeColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Container(
          margin: const EdgeInsets.only(top: 1.5, left: 1.5, right: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [activeBgColor, Colors.white],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(14.5)),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: activeColor,
            ),
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.transparent, width: 1.5),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: inactiveColor,
          ),
        ),
      );
    }
  }

  Widget _buildProductCard(ProductModel product, CartController cartController, {Color? bgColor}) {
    return ProductCard(
      product: product,
      cardBgColor: bgColor,
    );
  }

  void _showLocationBottomSheet(
    BuildContext context,
    LocationController controller,
  ) {
    final TextEditingController addressController = TextEditingController(
      text: controller.currentAddress.value,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enter your location',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Enter complete address',
                  prefixIcon: const Icon(
                    Icons.location_city,
                    color: Colors.purple,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.purple,
                      width: 2,
                    ),
                  ),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    controller.updateAddress(addressController.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    controller.getCurrentLocation();
                  },
                  icon: const Icon(Icons.my_location, color: Colors.purple),
                  label: const Text(
                    'Use Current Location',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.purple),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFreshSection(ProductController productController, CartController cartController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fresh', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF2E7D32))),
                  const Text('Handpicked daily essentials', style: TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(height: 1.5, color: const Color(0xFF2E7D32)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() => Row(
                  children: [
                    GestureDetector(onTap: () => productController.setFreshTab('Bouquets & Plants'), child: _buildGenericTab(title: 'Bouquets & Plants', isSelected: productController.freshTab.value == 'Bouquets & Plants', activeColor: const Color(0xFF2E7D32), activeBgColor: const Color(0xFFE8F5E9), inactiveColor: Colors.blueGrey.shade800)),
                    GestureDetector(onTap: () => productController.setFreshTab('Fruits'), child: _buildGenericTab(title: 'Fruits', isSelected: productController.freshTab.value == 'Fruits', activeColor: const Color(0xFF2E7D32), activeBgColor: const Color(0xFFE8F5E9), inactiveColor: Colors.blueGrey.shade800)),
                    GestureDetector(onTap: () => productController.setFreshTab('Veggies'), child: _buildGenericTab(title: 'Veggies', isSelected: productController.freshTab.value == 'Veggies', activeColor: const Color(0xFF2E7D32), activeBgColor: const Color(0xFFE8F5E9), inactiveColor: Colors.blueGrey.shade800)),
                    GestureDetector(onTap: () => productController.setFreshTab('Season\'s Best'), child: _buildGenericTab(title: 'Season\'s Best', isSelected: productController.freshTab.value == 'Season\'s Best', activeColor: const Color(0xFF2E7D32), activeBgColor: const Color(0xFFE8F5E9), inactiveColor: Colors.blueGrey.shade800)),
                  ],
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Obx(() {
            final items = productController.getFreshProducts(productController.freshTab.value);
            if (items.isEmpty) return const SizedBox();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildProductCard(items[index], cartController);
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => Get.to(() => const CategoryScreen(categoryName: 'Fresh')),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.grey.shade50,
              ),
              child: const Text('See All ‣', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlockbusterDeals(ProductController productController, CartController cartController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Blockbuster Deals'),
        SizedBox(
          height: 200,
          child: Obx(() {
            final items = productController.getBlockbusterDeals();
            if (items.isEmpty) return const SizedBox();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildProductCard(items[index], cartController);
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => Get.to(() => const CategoryScreen(categoryName: 'Price Drop')),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.grey.shade50,
              ),
              child: const Text('See All ‣', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClearanceSale(ProductController productController, CartController cartController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Clearance Sale'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Stack(
            children: [
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(height: 1.5, color: const Color(0xFFF0145A)),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() => Row(
                  children: [
                    GestureDetector(onTap: () => productController.setClearanceSaleTab('Top Deals'), child: _buildGenericTab(title: 'Top Deals', isSelected: productController.clearanceSaleTab.value == 'Top Deals', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade700)),
                    GestureDetector(onTap: () => productController.setClearanceSaleTab('Electronics & Appliances'), child: _buildGenericTab(title: 'Electronics & Appliances', isSelected: productController.clearanceSaleTab.value == 'Electronics & Appliances', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade700)),
                    GestureDetector(onTap: () => productController.setClearanceSaleTab('Apparel & Lifestyle'), child: _buildGenericTab(title: 'Apparel & Lifestyle', isSelected: productController.clearanceSaleTab.value == 'Apparel & Lifestyle', activeColor: const Color(0xFFF0145A), activeBgColor: const Color(0xFFFFF0F5), inactiveColor: Colors.blueGrey.shade700)),
                  ],
                )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: Obx(() {
            final items = productController.getClearanceProducts(productController.clearanceSaleTab.value);
            if (items.isEmpty) return const SizedBox();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildProductCard(items[index], cartController);
              },
            );
          }),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton(
              onPressed: () => Get.to(() => const CategoryScreen(categoryName: 'Super Mall')),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.grey.shade50,
              ),
              child: const Text('See All ‣', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }
}
