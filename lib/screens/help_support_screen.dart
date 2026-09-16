import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  late final OrderController orderController;

  @override
  void initState() {
    super.initState();
    orderController = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar
              _buildTopBar(),
              const SizedBox(height: 16),

              // 2. Dynamic Recent Order / Cancelled Order Help Card
              Obx(() {
                if (orderController.orders.isEmpty) {
                  return const SizedBox.shrink();
                }
                final recentOrder = orderController.orders.first;
                return Column(
                  children: [
                    _buildRecentOrderHelpCard(recentOrder),
                    const SizedBox(height: 24),
                  ],
                );
              }),

              // 3. FAQs Section Header
              const Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 12),

              // 4. FAQs List Container
              _buildFaqListCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================
  Widget _buildTopBar() {
    return Row(
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
          'Help & Support',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // RECENT ORDER HELP CARD (DYNAMIC)
  // ============================================================
  Widget _buildRecentOrderHelpCard(Map<String, dynamic> order) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showOrderResolutionSheet(order),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row
                Row(
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
                    const SizedBox(width: 4),
                    const Icon(Icons.more_vert, color: Colors.black54, size: 20),
                  ],
                ),

                // Timestamp
                const SizedBox(height: 2),
                Text(
                  'Placed at $placedAt',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 12),

                // Thumbnails
                SizedBox(
                  height: 52,
                  child: ListView.separated(
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // FAQS LIST CARD
  // ============================================================
  Widget _buildFaqListCard() {
    final faqTopics = [
      {'title': 'General Inquiry', 'desc': 'Questions about delivery timings, service areas, and store hours.'},
      {'title': 'Payment Related', 'desc': 'Issues with UPI, debit/credit cards, netbanking, and failed transactions.'},
      {'title': 'Feedback & Suggestions', 'desc': 'Share feedback or report any delivery experience improvements.'},
      {'title': 'Order / Products Related', 'desc': 'Missing or damaged items, replacement requests, and return policies.'},
      {'title': 'Gift Card', 'desc': 'How to purchase, send, redeem, and check Zesty Gift Card voucher balance.'},
      {'title': 'No-Cost EMI', 'desc': 'Eligible bank credit cards for No-Cost EMI on large orders.'},
      {'title': 'Wallet Related', 'desc': 'Zepto Cash balance, auto-refunds, and cash cashback queries.'},
      {'title': 'Zepto Club', 'desc': 'Exclusive benefits, zero delivery fees, and VIP member perks.'},
      {'title': 'Referral', 'desc': 'Invite friends and earn ₹100 Zepto Cash on their first order.'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: faqTopics.length,
        separatorBuilder: (context, index) => Divider(
          height: 1,
          thickness: 0.8,
          color: Colors.grey.shade200,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (context, index) {
          final topic = faqTopics[index];
          final title = topic['title']!;
          final desc = topic['desc']!;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: index == 0
                  ? const BorderRadius.vertical(top: Radius.circular(16))
                  : index == faqTopics.length - 1
                      ? const BorderRadius.vertical(bottom: Radius.circular(16))
                      : BorderRadius.zero,
              onTap: () => _showFaqDetails(title, desc),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: Color(0xFFF0145A),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ============================================================
  // ORDER RESOLUTION DETAILS SHEET
  // ============================================================
  void _showOrderResolutionSheet(Map<String, dynamic> order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Order Help & Resolution',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.red),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Order #${order['id']} was cancelled. If amount was deducted, ₹${order['totalAmount']?.toInt()} has been refunded to your original payment method.',
                      style: const TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.currency_rupee, color: Colors.green),
              title: const Text('Check Refund Status'),
              subtitle: const Text('Refund completed within 2-4 business hours'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(ctx).pop();
                Get.snackbar('Refund Status', 'Refund of ₹${order['totalAmount']?.toInt()} processed successfully!');
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline, color: Colors.deepPurple),
              title: const Text('Why was my order cancelled?'),
              subtitle: const Text('Store stock unavailability or rider allocation delay'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(ctx).pop();
                Get.snackbar('Reason', 'Items were temporarily out of stock at the dark store.');
              },
            ),
            ListTile(
              leading: const Icon(Icons.support_agent, color: Color(0xFFF0145A)),
              title: const Text('Chat with Support Executive'),
              subtitle: const Text('Available 24/7 for instant assistance'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(ctx).pop();
                Get.snackbar('Support', 'Agent connected. How may we assist you with order #${order['id']}?');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // FAQ TOPIC DETAILS SHEET
  // ============================================================
  void _showFaqDetails(String title, String desc) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              desc,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.4),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Frequently Asked Questions:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text('• How fast will my delivery arrive? (Typically 10-15 minutes)'),
                  SizedBox(height: 4),
                  Text('• Can I cancel an order after placing it? (Yes, before dispatch)'),
                  SizedBox(height: 4),
                  Text('• How do I use coupons & gift cards? (Apply at checkout or Zepto Cash)'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF0145A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
                label: const Text('Still need help? Chat with Us', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Get.snackbar('Support Chat', 'Connecting with a customer service specialist...');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
