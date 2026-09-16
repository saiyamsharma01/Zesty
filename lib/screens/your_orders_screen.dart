import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';
import '../widgets/floating_cart_banner.dart';
import 'help_support_screen.dart';

class YourOrdersScreen extends StatefulWidget {
  const YourOrdersScreen({super.key});

  @override
  State<YourOrdersScreen> createState() => _YourOrdersScreenState();
}

class _YourOrdersScreenState extends State<YourOrdersScreen> {
  late final OrderController orderController;
  late final CartController cartController;
  late final ProductController productController;

  @override
  void initState() {
    super.initState();
    orderController = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());

    cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController());

    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Top Header Bar
                _buildTopBar(),

                // 2. Orders & Featured Content
                Expanded(
                  child: Obx(() {
                    if (orderController.orders.isEmpty) {
                      return _buildEmptyOrdersState();
                    }

                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      children: [
                        // First Order Card
                        if (orderController.orders.isNotEmpty)
                          _buildOrderCard(orderController.orders[0]),

                        const SizedBox(height: 20),

                        // Featured for you section
                        _buildFeaturedSection(),

                        const SizedBox(height: 20),

                        // Remaining Orders
                        for (int i = 1; i < orderController.orders.length; i++) ...[
                          _buildOrderCard(orderController.orders[i]),
                          const SizedBox(height: 16),
                        ],

                        const SizedBox(height: 90), // Space for floating cart
                      ],
                    );
                  }),
                ),
              ],
            ),

            // Floating Bottom Cart Banner
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: const FloatingCartBanner(),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP APP BAR
  // ============================================================
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1.2),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.black87,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Your Orders',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================
  Widget _buildEmptyOrdersState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shopping_bag_outlined, size: 64, color: Color(0xFF9852F9)),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Orders Yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'You haven’t placed any orders yet.\nExplore products and order now!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9852F9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => Get.back(),
              child: const Text('Start Shopping', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ORDER CARD
  // ============================================================
  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] ?? 'delivered';
    final statusText = order['statusText'] ?? (status == 'cancelled' ? 'Order cancelled' : 'Order delivered');
    final totalAmount = (order['totalAmount'] is num) ? (order['totalAmount'] as num).toDouble() : 0.0;
    final placedAt = order['placedAt'] ?? '';
    final List<dynamic> items = order['items'] ?? [];
    final bool isCancelled = status == 'cancelled';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0, top: 14.0, bottom: 4.0),
            child: Row(
              children: [
                Text(
                  statusText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(
                  isCancelled ? Icons.cancel : Icons.check_circle,
                  color: isCancelled ? Colors.grey.shade400 : Colors.green,
                  size: 18,
                ),
                const Spacer(),
                Text(
                  '₹${totalAmount.toInt()}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.black54, size: 20),
                  onSelected: (val) {
                    if (val == 'help') {
                      Get.to(() => const HelpSupportScreen());
                    } else if (val == 'invoice') {
                      Get.snackbar('Invoice', 'Invoice sent to your registered email!');
                    } else if (val == 'delete') {
                      orderController.deleteOrder(order['id'] ?? '');
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'help', child: Text('Get Help')),
                    const PopupMenuItem(value: 'invoice', child: Text('Download Invoice')),
                    const PopupMenuItem(value: 'delete', child: Text('Remove from History')),
                  ],
                ),
              ],
            ),
          ),

          // Placed at date
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Placed at $placedAt',
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Product Thumbnails Row
          SizedBox(
            height: 54,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final img = item['image'] ?? '';
                return Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200, width: 1.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.network(
                      img,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.fastfood_outlined,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 14),
          Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200),

          // Order Again Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              onTap: () => orderController.reorder(order),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                child: const Text(
                  'Order Again',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF0145A),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FEATURED FOR YOU SECTION
  // ============================================================
  Widget _buildFeaturedSection() {
    final featuredItems = [
      {
        'id': 'feat-1',
        'title': 'YumFills Rich ChocoPie by Sunfeast Dark Fantasy',
        'weight': '1 pack (11 x 22 g)',
        'price': 89.0,
        'oldPrice': 180.0,
        'tag': 'Low trans-fat • Choco-filled',
        'badge': 'Ad',
        'image': 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=300&q=80',
      },
      {
        'id': 'feat-2',
        'title': 'Original Choco Fills By Sunfeast Dark Fantasy | Perfect Snack',
        'weight': '1 pack (230 g)',
        'price': 100.0,
        'oldPrice': 170.0,
        'tag': 'Low trans-fat • Choco-filled',
        'badge': 'select >',
        'image': 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=300&q=80',
      },
      {
        'id': 'feat-3',
        'title': 'Nua Ultra Thin Rash-Free Sanitary Pads XXL',
        'weight': '1 pack (12 pads)',
        'price': 150.0,
        'oldPrice': 249.0,
        'tag': 'Zero Toxins • Super Absorbent',
        'badge': 'XXL',
        'image': 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=300&q=80',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Featured for you',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 290,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: featuredItems.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final item = featuredItems[index];
              return _buildFeaturedCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> item) {
    final String id = item['id'] as String;
    final String title = item['title'] as String;
    final String weight = item['weight'] as String;
    final double price = item['price'] as double;
    final double oldPrice = item['oldPrice'] as double;
    final String tag = item['tag'] as String;
    final String badge = item['badge'] as String;
    final String image = item['image'] as String;

    final prod = ProductModel(
      id: id,
      name: title,
      networkImage: image,
      price: price,
      offer: '₹${(oldPrice - price).toInt()} OFF',
      description: tag,
      category: 'Featured',
    );

    return Container(
      width: 168,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with badge
          Stack(
            children: [
              Container(
                height: 125,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.fastfood, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              if (badge == 'select >')
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8D4F27),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'select',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.chevron_right, color: Colors.white, size: 10),
                      ],
                    ),
                  ),
                )
              else if (badge == 'Ad')
                Positioned(
                  bottom: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'Ad',
                      style: TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
              // ADD Button positioned on bottom right of image
              Positioned(
                bottom: 6,
                right: 8,
                child: Obx(() {
                  final qty = cartController.getQuantity(prod.id);
                  if (qty == 0) {
                    return InkWell(
                      onTap: () => cartController.addToCart(prod),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFF0145A), width: 1.2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Text(
                          'ADD',
                          style: TextStyle(
                            color: Color(0xFFF0145A),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  }

                  return Container(
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0145A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 24, minHeight: 28),
                          icon: const Icon(Icons.remove, size: 14, color: Colors.white),
                          onPressed: () => cartController.removeFromCart(prod.id),
                        ),
                        Text(
                          '$qty',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 24, minHeight: 28),
                          icon: const Icon(Icons.add, size: 14, color: Colors.white),
                          onPressed: () => cartController.addToCart(prod),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),

          // Price row
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF108A00),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '₹${price.toInt()}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '₹${oldPrice.toInt()}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                height: 1.2,
              ),
            ),
          ),

          // Weight
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0),
            child: Text(
              weight,
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.grey.shade600,
              ),
            ),
          ),

          // Feature Tag
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 3.0),
            child: Text(
              tag,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF8D4F27),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
