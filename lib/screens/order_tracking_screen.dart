import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class OrderTrackingScreen extends StatefulWidget {
  final Map<String, dynamic>? orderData;

  const OrderTrackingScreen({super.key, this.orderData});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> with SingleTickerProviderStateMixin {
  late final Map<String, dynamic> order;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    if (widget.orderData != null) {
      order = widget.orderData!;
    } else if (Get.arguments is Map<String, dynamic>) {
      order = Get.arguments as Map<String, dynamic>;
    } else {
      order = {
        'id': 'ZEP9823412',
        'status': 'out_for_delivery',
        'totalAmount': 249.0,
        'placedAt': 'Today, 10:15 PM',
        'address': 'Platinum Hostel, Phase 5, Sector 59, SAS Nagar, Punjab',
        'items': [
          {'name': 'Amul Taaza Homogenised Toned Milk', 'price': 27.0, 'qty': 2, 'img': 'assets/icons/Dairy_bread.jpg'},
          {'name': 'Fresh Banana Robusta (500g)', 'price': 38.0, 'qty': 1, 'img': 'assets/icons/fruits_veg.jpg'},
          {'name': 'Lays Classic Salted Potato Chips', 'price': 20.0, 'qty': 2, 'img': 'assets/icons/Munchies.jpg'},
        ],
      };
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderId = order['id'] ?? 'ZEP849204';
    final totalAmount = (order['totalAmount'] is num) ? (order['totalAmount'] as num).toDouble() : 249.0;
    final List<dynamic> items = order['items'] ?? [];
    final address = order['address'] ?? 'Phase 5, Sector 59, SAS Nagar, Punjab';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Live Order Tracking',
              style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w800),
            ),
            Text(
              'Order #$orderId',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 11.5),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () => Get.toNamed(Routes.helpSupport),
            icon: const Icon(Icons.headset_mic_outlined, size: 16, color: Color(0xFF9852F9)),
            label: const Text('Help', style: TextStyle(color: Color(0xFF9852F9), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Live ETA & Status Header Card
            _buildEtaCard(),
            const SizedBox(height: 16),

            // 2. Simulated Live Map View
            _buildLiveMapCard(),
            const SizedBox(height: 16),

            // 3. Delivery Partner Details Card
            _buildDeliveryPartnerCard(),
            const SizedBox(height: 16),

            // 4. Step-by-Step Order Timeline
            _buildOrderTimeline(),
            const SizedBox(height: 16),

            // 5. Delivery Address Card
            _buildAddressCard(address),
            const SizedBox(height: 16),

            // 6. Ordered Items Card
            _buildOrderItemsCard(items),
            const SizedBox(height: 16),

            // 7. Bill Details Card
            _buildBillDetailsCard(totalAmount),
            const SizedBox(height: 24),

            // 8. Cancel / Help Buttons
            _buildActionButtons(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildEtaCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3F007D), Color(0xFF6B21A8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBBF24),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bolt, size: 14, color: Colors.black87),
                      SizedBox(width: 4),
                      Text(
                        'ON TIME DELIVERY',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Arriving in 8 Mins',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Your delivery partner is on the way with your order.',
                  style: TextStyle(fontSize: 12.5, color: Colors.white70),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.two_wheeler, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveMapCard() {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Stack(
        children: [
          // Background Map Pattern
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE5E7EB), Color(0xFFD1D5DB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CustomPaint(
                  painter: _MapRoutePainter(),
                ),
              ),
            ),
          ),

          // Dark Store Pin (Left)
          Positioned(
            left: 28,
            top: 70,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF3F007D),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.storefront, color: Colors.white, size: 18),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                  ),
                  child: const Text('Zepto Hub', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Customer Home Pin (Right)
          Positioned(
            right: 28,
            top: 60,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home, color: Colors.white, size: 18),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
                  ),
                  child: const Text('Your Home', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // Moving Scooter (Center animated)
          Positioned(
            left: 140,
            top: 62,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 1.0 + (_pulseController.value * 0.12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0145A),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF0145A).withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.delivery_dining, color: Colors.white, size: 22),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryPartnerCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFE9D5FF),
            child: Icon(Icons.person, color: Color(0xFF6B21A8), size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Vikram Singh',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.verified, color: Colors.blue, size: 16),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '4.9 (1.2k+ deliveries)',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Vaccinated & Temperature checked',
                  style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFF3E8FF),
            ),
            icon: const Icon(Icons.call, color: Color(0xFF9852F9), size: 20),
            onPressed: () {
              Get.snackbar('Calling Rider', 'Connecting you to Vikram Singh (+91 98721XXXXX)...');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Status',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          const SizedBox(height: 16),
          _buildTimelineStep('Order Placed & Confirmed', '10:15 PM', isCompleted: true),
          _buildTimelineStep('Packed at Local Dark Store', '10:17 PM', isCompleted: true),
          _buildTimelineStep('Delivery Partner Assigned', '10:19 PM', isCompleted: true),
          _buildTimelineStep('Out for Delivery', '10:21 PM', isActive: true),
          _buildTimelineStep('Arriving at Doorstep', 'Est. 10:27 PM', isLast: true),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(String title, String time, {bool isCompleted = false, bool isActive = false, bool isLast = false}) {
    Color dotColor = Colors.grey.shade300;
    IconData icon = Icons.circle;

    if (isCompleted) {
      dotColor = const Color(0xFF10B981);
      icon = Icons.check_circle;
    } else if (isActive) {
      dotColor = const Color(0xFF9852F9);
      icon = Icons.radio_button_checked;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(icon, size: 18, color: dotColor),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: isCompleted ? const Color(0xFF10B981) : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: isActive || isCompleted ? FontWeight.w700 : FontWeight.w500,
                    color: isActive ? const Color(0xFF9852F9) : (isCompleted ? Colors.black87 : Colors.grey.shade500),
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressCard(String address) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on, color: Color(0xFF9852F9), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Delivery Address',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItemsCard(List<dynamic> items) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items (${items.length})',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 20),
            itemBuilder: (context, index) {
              final itm = items[index];
              final name = itm['name'] ?? 'Product';
              final price = itm['price'] ?? 0;
              final qty = itm['qty'] ?? 1;

              return Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Qty: $qty',
                          style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '₹${price * qty}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBillDetailsCard(double total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bill Summary',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          _buildBillRow('Item Total', '₹${total.toInt()}'),
          _buildBillRow('Delivery Fee', 'FREE', isDiscount: true),
          _buildBillRow('Handling Fee', '₹4'),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Paid',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: Colors.black87),
              ),
              Text(
                '₹${(total + 4).toInt()}',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF3F007D)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDiscount ? Colors.green : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: const BorderSide(color: Colors.red),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.defaultDialog(
                title: 'Cancel Order',
                middleText: 'Are you sure you want to cancel this order? Instant refund will be issued to Zepto Cash.',
                textConfirm: 'Yes, Cancel',
                textCancel: 'No',
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () {
                  Get.back();
                  Get.back();
                  Get.snackbar('Order Cancelled', 'Your order was cancelled and ₹${order['totalAmount'] ?? 249} refunded.');
                },
              );
            },
            child: const Text('Cancel Order', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3F007D),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Get.toNamed(Routes.helpSupport),
            child: const Text('Need Help', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

class _MapRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9852F9)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.18, size.height * 0.45);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.25,
      size.width * 0.82,
      size.height * 0.40,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
