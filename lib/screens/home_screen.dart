import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/location_controller.dart';
import 'category_screen.dart';
import 'manage_products_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());
    final locationController = Get.put(LocationController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // AppBar area with Location and Profile
            // Zepto-style Top Header
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location & Profile
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                _showLocationBottomSheet(context, locationController);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.location_on, color: Colors.purple[700], size: 24),
                                      const SizedBox(width: 4),
                                      const Text(
                                        '6 minutes',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Obx(() => locationController.isLoading.value 
                                        ? const SizedBox(
                                            width: 16, 
                                            height: 16, 
                                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.purple)
                                          )
                                        : const SizedBox.shrink()
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Obx(() => Text(
                                          locationController.currentAddress.value,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )),
                                      ),
                                      const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black54),
                                      const SizedBox(width: 20), // padding for profile icon
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              final controller = Get.find<AuthController>();
                              controller.logout();
                            },
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.purple,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Navigation Tabs
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          _buildNavTab(
                            title: 'zepto',
                            isSelected: true,
                            textColor: Colors.white,
                            bgColor: Colors.purple,
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          _buildNavTab(
                            title: 'select',
                            isSelected: false,
                            textColor: Colors.purple,
                            bgColor: Colors.purple.shade50,
                            onTap: () => Get.toNamed('/select'),
                          ),
                          const SizedBox(width: 12),
                          _buildNavTab(
                            title: 'Super\nMall.',
                            isSelected: false,
                            textColor: Colors.purple,
                            bgColor: Colors.purple.shade50,
                            isMultiLine: true,
                            onTap: () => Get.toNamed('/super-mall'),
                          ),
                          const SizedBox(width: 12),
                          _buildNavTab(
                            title: 'cafe\nFrom ₹39',
                            isSelected: false,
                            textColor: Colors.purple,
                            bgColor: Colors.purple.shade50,
                            isMultiLine: true,
                            onTap: () => Get.toNamed('/cafe'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.grey),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Search for "Rakhi"',
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Quick Categories Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildQuickCategory('assets/icons/cat_all.jpg', 'All'),
                          _buildQuickCategory('assets/icons/cat_beauty.jpg', 'Beauty'),
                          _buildQuickCategory('assets/icons/cat_pharmacy.jpg', 'Pharmacy'),
                          _buildQuickCategory('assets/icons/cat_toys.jpg', 'Toys'),
                          _buildQuickCategory('assets/icons/cat_mobiles.jpg', 'Mobiles'),
                          _buildQuickCategory('assets/icons/cat_home.jpg', 'Home'),
                          _buildQuickCategory('assets/icons/cat_fresh.jpg', 'Fresh'),
                          _buildQuickCategory('assets/icons/cat_electronics.jpg', 'Electronics'),
                          _buildQuickCategory('assets/icons/cat_home.jpg', 'Grocery'),
                          _buildQuickCategory('assets/icons/cat_beauty.jpg', 'Fashion'),
                          _buildQuickCategory('assets/icons/cat_toys.jpg', 'Sports'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    'assets/icons/banner.jpg',
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),


            // Trending Near You Title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Trending Near You',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Products Horizontal List
            SliverToBoxAdapter(
              child: SizedBox(
                height: 220,
                child: Obx(() {
                  if (productController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (productController.products.isEmpty) {
                    return const Center(child: Text('No products available.'));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      final product = productController.products[index];
                      return Container(
                        width: 140,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 120,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image.network(
                                  product.networkImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${product.price.toInt()}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: Colors.purple),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: const Text(
                                          'ADD',
                                          style: TextStyle(
                                            color: Colors.purple,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
            
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => const ManageProductsScreen());
        },
        backgroundColor: Colors.purple,
        icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
        label: const Text('Manage Products', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildNavTab({
    required String title,
    required bool isSelected,
    required Color textColor,
    required Color bgColor,
    required VoidCallback onTap,
    bool isMultiLine = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: Colors.transparent),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: isMultiLine ? 14 : 18,
            height: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickCategory(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CategoryScreen(categoryName: label));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Column(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLocationBottomSheet(BuildContext context, LocationController controller) {
    final TextEditingController addressController = TextEditingController(text: controller.currentAddress.value);

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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                  prefixIcon: const Icon(Icons.location_city, color: Colors.purple),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.purple, width: 2),
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
}
