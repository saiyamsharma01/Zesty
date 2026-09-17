import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import '../routes/app_routes.dart';

class YourRefundsScreen extends StatefulWidget {
  const YourRefundsScreen({super.key});

  @override
  State<YourRefundsScreen> createState() => _YourRefundsScreenState();
}

class _YourRefundsScreenState extends State<YourRefundsScreen> {
  late final OrderController orderController;

  // Refunds list - empty by default when user has no refunds
  final RxList<Map<String, dynamic>> refundsList = <Map<String, dynamic>>[].obs;

  @override
  void initState() {
    super.initState();
    orderController = Get.isRegistered<OrderController>()
        ? Get.find<OrderController>()
        : Get.put(OrderController());

    _loadRefunds();
  }

  void _loadRefunds() {
    // Check for refunded orders dynamically from orderController
    final List<Map<String, dynamic>> dynamicRefunds = [];

    for (var order in orderController.orders) {
      if (order['status'] == 'refunded') {
        dynamicRefunds.add({
          'orderId': order['id'] ?? 'ORD-REFUND',
          'amount': (order['totalAmount'] is num) ? (order['totalAmount'] as num).toInt() : 0,
          'paymentMode': order['paymentMode'] ?? 'UPI',
          'status': 'Completed',
          'initiatedAt': order['refundInitiatedAt'] ?? order['placedAt'] ?? 'Recently',
          'creditedAt': order['refundCreditedAt'] ?? 'Within 2 hours',
          'upiRefId': 'UPI/${(order['id'] ?? 'REF').replaceAll('-', '')}',
          'arn': 'ARN${(order['id'] ?? 'REF').hashCode.abs()}',
          'reason': 'Order cancelled / refunded',
        });
      }
    }

    refundsList.value = dynamicRefunds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Header Bar
            _buildTopBar(),

            // 2. Refund List or Empty State (Reactive via Obx)
            Expanded(
              child: Obx(() {
                if (refundsList.isEmpty) {
                  return _buildEmptyRefundsState();
                }
                return _buildRefundsList();
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 1. TOP HEADER BAR
  // ============================================================
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1.0),
        ),
      ),
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
                border: Border.all(color: Colors.grey.shade300, width: 1.1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.black87,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Text(
            'Your Refunds',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 2. EMPTY REFUNDS STATE (DEFAULT WHEN NO REFUNDS)
  // ============================================================
  Widget _buildEmptyRefundsState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.currency_rupee_rounded,
                  size: 40,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'No Refunds Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'When an item is returned or an order is cancelled, your refund details and live status will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
                height: 1.45,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3F007D),
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: () => Get.toNamed(Routes.home),
              child: const Text(
                'Explore Products',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 3. REFUNDS LIST (WHEN REFUNDS EXIST)
  // ============================================================
  Widget _buildRefundsList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      itemCount: refundsList.length,
      itemBuilder: (context, index) {
        final refund = refundsList[index];
        return _buildRefundCard(refund);
      },
    );
  }

  // ============================================================
  // REFUND CARD (MATCHING IMAGE 3)
  // ============================================================
  Widget _buildRefundCard(Map<String, dynamic> refund) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section: ORDER ID & Amount
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ORDER ID',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF9CA3AF),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      refund['orderId'] ?? 'QUILRSPSB08775',
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${refund['amount']}',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),

          // Dotted horizontal line divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: CustomPaint(
                painter: _DottedDividerPainter(color: const Color(0xFFE5E7EB)),
              ),
            ),
          ),

          // Middle section: To: UPI [Completed] & Initiation Date
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'To: ',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    Text(
                      '${refund['paymentMode'] ?? 'UPI'} ',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F8EE),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        refund['status'] ?? 'Completed',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF4B5563),
                    ),
                    children: [
                      const TextSpan(text: 'Refund initiated on '),
                      TextSpan(
                        text: refund['initiatedAt'] ?? '10th Aug, 2026 at 09:22 AM',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Bottom section divider
          Container(
            height: 1,
            color: const Color(0xFFF3F4F6),
          ),

          // Bottom button: Show Details
          InkWell(
            onTap: () => _showRefundDetailsSheet(refund),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              alignment: Alignment.center,
              child: const Text(
                'Show Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFFF2B66),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SHOW DETAILS BOTTOM SHEET
  // ============================================================
  void _showRefundDetailsSheet(Map<String, dynamic> refund) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sheet Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Refund Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20, color: Colors.black87),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Summary Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Refund Amount', '₹${refund['amount']}', isAmount: true),
                    const Divider(height: 20),
                    _buildDetailRow('Status', refund['status'] ?? 'Completed', isStatus: true),
                    const Divider(height: 20),
                    _buildDetailRow('Refund Mode', refund['paymentMode'] ?? 'UPI'),
                    const Divider(height: 20),
                    _buildDetailRow('Order ID', refund['orderId'] ?? 'QUILRSPSB08775'),
                    const Divider(height: 20),
                    _buildDetailRow('UPI Reference ID', refund['upiRefId'] ?? 'UPI/422391028391'),
                    const Divider(height: 20),
                    _buildDetailRow('Bank ARN', refund['arn'] ?? 'ARN8839210948'),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Refund Progress Timeline
              const Text(
                'Refund Timeline',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 14),

              _buildTimelineStep(
                title: 'Refund Initiated',
                time: refund['initiatedAt'] ?? 'Recently',
                subtitle: 'Refund request processed by Zesty',
                isCompleted: true,
                isLast: false,
              ),
              _buildTimelineStep(
                title: 'Processed by Payment Gateway',
                time: 'Within few minutes',
                subtitle: 'Sent to recipient banking partner',
                isCompleted: true,
                isLast: false,
              ),
              _buildTimelineStep(
                title: 'Credited to UPI Account',
                time: refund['creditedAt'] ?? 'Within 2 hours',
                subtitle: 'Funds successfully deposited into your account',
                isCompleted: true,
                isLast: true,
              ),
              const SizedBox(height: 20),

              // Need Help Button
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFF3F007D), width: 1.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Get.back();
                  Get.toNamed(Routes.helpSupport);
                },
                icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF3F007D)),
                label: const Text(
                  'Need Help with this Refund?',
                  style: TextStyle(
                    color: Color(0xFF3F007D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isAmount = false, bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isStatus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8EE),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF16A34A),
              ),
            ),
          )
        else
          Text(
            value,
            style: TextStyle(
              fontSize: isAmount ? 16 : 13,
              fontWeight: FontWeight.w700,
              color: isAmount ? const Color(0xFF111827) : const Color(0xFF1F2937),
            ),
          ),
      ],
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String time,
    required String subtitle,
    required bool isCompleted,
    required bool isLast,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0xFF16A34A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 12, color: Colors.white),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 38,
                color: const Color(0xFF16A34A).withValues(alpha: 0.4),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// DOTTED DIVIDER PAINTER
// ============================================================
class _DottedDividerPainter extends CustomPainter {
  final Color color;

  _DottedDividerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashWidth = 3.0;
    const dashSpace = 3.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _DottedDividerPainter oldDelegate) =>
      oldDelegate.color != color;
}
