import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'category_screen.dart';
import '../widgets/global_offer_banner.dart';
import '../widgets/floating_cart_banner.dart';

class AllCategoriesScreen extends StatelessWidget {
  const AllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('All Categories', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Grocery & Kitchen', [
                  _CategoryItem('Fruits &\nVegetables', span: 2, imagePath: 'assets/icons/fruits_veg.jpg'),
                  _CategoryItem('Dairy, Bread\n& Eggs', span: 1, imagePath: 'assets/icons/dairy_bread.jpg'),
                  _CategoryItem('Atta, Rice,\nOil & Dals', span: 1, imagePath: 'assets/icons/atta_rice.jpg'),
                  _CategoryItem('Meat, Fish\n& Eggs', span: 1, imagePath: 'assets/icons/Meat_fish.jpg'),
                  _CategoryItem('Masala &\nDry Fruits', span: 1, imagePath: 'assets/icons/Masala_Dryfruits.jpg'),
                  _CategoryItem('Breakfast &\nSauces', span: 1, imagePath: 'assets/icons/Breakfast_Sauces.jpg'),
                  _CategoryItem('Packaged\nFood', span: 1, imagePath: 'assets/icons/packaged_food.jpg'),
                ]),
                _buildSection('Snacks & Drinks', [
                  _CategoryItem('Zepto\nCafe', span: 1, imagePath: 'assets/icons/Zepto_cafe.jpg'),
                  _CategoryItem('Tea, Coffee\n& More', span: 1, imagePath: 'assets/icons/Tea_Coffee_more.jpg'),
                  _CategoryItem('Ice Creams\n& More', span: 1, imagePath: 'assets/icons/Icecreams_more.jpg'),
                  _CategoryItem('Frozen\nFood', span: 1, imagePath: 'assets/icons/frozen_food.jpg'),
                  _CategoryItem('Sweet\nCravings', span: 1, imagePath: 'assets/icons/Sweet_craving.jpg'),
                  _CategoryItem('Cold Drinks\n& Juices', span: 1, imagePath: 'assets/icons/ColdDrinks_juices.jpg'),
                  _CategoryItem('Munchies', span: 1, imagePath: 'assets/icons/Munchies.jpg'),
                  _CategoryItem('Biscuits\n& Cookies', span: 1, imagePath: 'assets/icons/Biscuits.jpg'),
                ]),
                _buildSection('Fashion & Lifestyle', [
                  _CategoryItem('Apparel', span: 2, imagePath: 'assets/icons/apparel_lifestyle.jpg'),
                  _CategoryItem('Jewellery', span: 2, imagePath: 'assets/icons/jewellery.jpg'),
                ]),
                _buildSection('Beauty & Personal Care', [
                  _CategoryItem('Personal Care\nStudio', span: 2, imagePath: 'assets/icons/Beauty_personalcare.jpg'),
                  _CategoryItem('Skincare', span: 1, imagePath: 'assets/icons/skin_care.jpg'),
                  _CategoryItem('Makeup\n& Beauty', span: 1, imagePath: 'assets/icons/Makeup_Beauty.jpg'),
                  _CategoryItem('Fragrance', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f338.png'),
                  _CategoryItem('Bath & Body', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f6c1.png'),
                  _CategoryItem('Haircare', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/2702.png'),
                  _CategoryItem('Baby Care', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f37c.png'),
                  _CategoryItem('Protein &\nNutrition', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f4aa.png'),
                  _CategoryItem('Pharmacy\n& Wellness', span: 1, imagePath: 'assets/icons/cat_pharmacy.jpg'),
                  _CategoryItem('Feminine\nHygiene', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1fa78.png'),
                  _CategoryItem('Sexual\nWellness', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f346.png'),
                ]),
                _buildSection('Household Essentials', [
                  _CategoryItem('Home\nNeeds', span: 2, imagePath: 'assets/icons/cat_home.jpg'),
                  _CategoryItem('Kitchenware &\nAppliances', span: 2, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f373.png'),
                  _CategoryItem('Cleaning\nEssentials', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f9f9.png'),
                  _CategoryItem('Electronics\nStore', span: 1, imagePath: 'assets/icons/cat_electronics.jpg'),
                  _CategoryItem('Pet\nCare', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f436.png'),
                  _CategoryItem('Paan\nCorner', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f343.png'),
                ]),
                _buildSection('Hobbies & Interests', [
                  _CategoryItem('Toys &\nGames', span: 1, imagePath: 'assets/icons/cat_toys.jpg'),
                  _CategoryItem('Stationery\n& Crafts', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f3a8.png'),
                  _CategoryItem('Sports &\nFitness', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/26bd.png'),
                  _CategoryItem('Book\nStore', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f4da.png'),
                ]),
                _buildSection('Shop by Store', [
                  _CategoryItem('Gift\nStore', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f381.png'),
                  _CategoryItem('Ayush\nStore', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f33f.png'),
                  _CategoryItem('Pooja\nStore', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f549.png'),
                  _CategoryItem('Derma\nStore', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/2695.png'),
                  _CategoryItem('Global\nStore', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f30d.png'),
                  _CategoryItem('Sports\nStore', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f3cf.png'),
                  _CategoryItem('Gaming\nGift Cards', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f3ae.png'),
                  _CategoryItem('Baby\nStore', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f476.png'),
                  _CategoryItem('Pleasure\nStore', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f525.png'),
                  _CategoryItem('Automotive\nStore', span: 1, imagePath: 'https://unpkg.com/emoji-datasource-apple@15.0.1/img/apple/64/1f697.png'),
                ]),
                const SizedBox(height: 100), // padding for bottom banner
              ],
            ),
          ),
          const GlobalOfferBanner(),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingCartBanner(),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<_CategoryItem> items) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double spacing = 12.0;
                final int columns = 4;
                final double totalSpacing = spacing * (columns - 1);
                final double cellWidth = (constraints.maxWidth - totalSpacing) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: 16.0,
                  children: items.map((item) {
                    final double itemWidth = item.span == 2 
                        ? (cellWidth * 2) + spacing 
                        : cellWidth;
                    
                    return GestureDetector(
                      onTap: () {
                        // Navigate to CategoryScreen and pass the title (removing newlines)
                        Get.to(() => CategoryScreen(categoryName: item.title.replaceAll('\n', ' ')));
                      },
                      child: SizedBox(
                        width: itemWidth,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: itemWidth,
                              height: cellWidth, // Keep height consistent across all items
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: item.imagePath.startsWith('http')
                                    ? Image.network(
                                        item.imagePath,
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_outlined, color: Colors.grey),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.asset(
                                          item.imagePath,
                                          fit: BoxFit.cover, // Use cover for local jpg images so they fill out nicely like in the screenshots
                                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_outlined, color: Colors.grey),
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _CategoryItem {
  final String title;
  final int span;
  final String imagePath;

  _CategoryItem(this.title, {this.span = 1, this.imagePath = ''});
}
