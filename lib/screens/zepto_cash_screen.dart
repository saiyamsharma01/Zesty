import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class ZeptoCashScreen extends StatefulWidget {
  const ZeptoCashScreen({super.key});

  @override
  State<ZeptoCashScreen> createState() => _ZeptoCashScreenState();
}

class _ZeptoCashScreenState extends State<ZeptoCashScreen> {
  late final AuthController authController;
  final TextEditingController amountController = TextEditingController(text: '1000');
  int selectedPill = 1000;

  final List<int> quickAmounts = [500, 1000, 2000, 5000];

  @override
  void initState() {
    super.initState();
    authController = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());
    authController.fetchUserData();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void _selectAmount(int amount) {
    setState(() {
      selectedPill = amount;
      amountController.text = '$amount';
    });
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

              // 2. Available Balance Card
              _buildAvailableBalanceCard(),
              const SizedBox(height: 16),

              // 3. One-Tap & Instant Refund Banner
              _buildBenefitsBanner(),
              const SizedBox(height: 16),

              // 4. Add Amount Card
              _buildAddAmountCard(),
              const SizedBox(height: 16),

              // 5. Have a Gift Card Card
              _buildGiftCardCard(),
              const SizedBox(height: 16),

              // 6. How it works & FAQs Card
              _buildInfoFaqCard(),
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
          'Zepto Cash',
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
  // AVAILABLE BALANCE CARD
  // ============================================================
  Widget _buildAvailableBalanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
      ),
      child: Column(
        children: [
          Text(
            'AVAILABLE BALANCE',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() {
            final cash = authController.zeptoCash.value.toInt();
            return Text(
              '₹$cash',
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
            );
          }),
        ],
      ),
    );
  }

  // ============================================================
  // BENEFITS BANNER
  // ============================================================
  Widget _buildBenefitsBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE9FE), // Lavender background matching screenshot
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Left: One-Tap Payment
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF6B21A8),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.touch_app_rounded,
                    color: Color(0xFFFDE047), // Yellow icon
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'ONE-TAP',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF581C87),
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    'payment',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF581C87),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Divider
          Container(
            width: 1,
            height: 32,
            color: Colors.purple.shade200,
          ),

          // Right: Instant Refund
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF6B21A8),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.autorenew_rounded,
                    color: Color(0xFFFDE047), // Yellow icon
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'INSTANT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF581C87),
                      letterSpacing: 0.2,
                    ),
                  ),
                  Text(
                    'refund',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF581C87),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ADD AMOUNT CARD
  // ============================================================
  Widget _buildAddAmountCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field container
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300, width: 1.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'Add amount ',
                    style: TextStyle(color: Colors.black54, fontSize: 11),
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: Color(0xFFF0145A), fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Text(
                      '₹ ',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (val) {
                          final parsed = int.tryParse(val) ?? 0;
                          setState(() {
                            selectedPill = parsed;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quick Selection Pills
          Row(
            children: quickAmounts.map((amt) {
              final bool isSelected = selectedPill == amt;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => _selectAmount(amt),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? const Color(0xFFF0145A) : Colors.grey.shade300,
                          width: isSelected ? 1.4 : 1.0,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$amt',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFFF0145A) : Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // Add Balance Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF0145A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              onPressed: () {
                final amt = double.tryParse(amountController.text.trim()) ?? 0.0;
                if (amt > 0) {
                  authController.addZeptoCash(amt);
                } else {
                  Get.snackbar('Invalid Amount', 'Please enter a valid amount greater than ₹0');
                }
              },
              child: const Text(
                'Add Balance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HAVE A GIFT CARD CARD
  // ============================================================
  Widget _buildGiftCardCard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.card_giftcard_rounded, color: Colors.black87, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Have a Gift Card?',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFF0145A), width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
            onPressed: _showAddGiftCardDialog,
            child: const Text(
              'Add Card',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0145A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddGiftCardDialog() {
    final cardCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Redeem Gift Card', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your 16-digit voucher or coupon code to add funds to Zepto Cash.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: cardCtrl,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                hintText: 'e.g. ZEPTO500 or ZEPTO1000',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF0145A)),
            onPressed: () {
              if (cardCtrl.text.trim().isNotEmpty) {
                authController.redeemGiftCard(cardCtrl.text.trim());
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HOW IT WORKS & FAQS CARD
  // ============================================================
  Widget _buildInfoFaqCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1.1),
      ),
      child: Column(
        children: [
          // How it works
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              onTap: _showHowItWorksSheet,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline_rounded, color: Colors.black54, size: 22),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'How it works',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.black54, size: 20),
                  ],
                ),
              ),
            ),
          ),

          Divider(height: 1, thickness: 0.8, color: Colors.grey.shade200, indent: 52, endIndent: 16),

          // FAQs
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              onTap: _showFaqSheet,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: const [
                    Icon(Icons.chat_bubble_outline_rounded, color: Colors.black54, size: 22),
                    SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'FAQs',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: Colors.black54, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHowItWorksSheet() {
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
                const Text('How Zepto Cash Works', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
              ],
            ),
            const SizedBox(height: 14),
            _buildHowStep('1', 'Instant 1-Tap Checkout', 'Pay without OTP or bank redirects for lightning fast ordering.'),
            const SizedBox(height: 12),
            _buildHowStep('2', 'Zero Payment Failures', 'Never get stuck with bank downtime or OTP delay.'),
            const SizedBox(height: 12),
            _buildHowStep('3', 'Instant Refunds in Seconds', 'All order returns and cancellations credit back immediately.'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHowStep(String num, String title, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: const Color(0xFFF0145A),
          child: Text(num, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 2),
              Text(desc, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  void _showFaqSheet() {
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
                const Text('Zepto Cash FAQs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(ctx).pop()),
              ],
            ),
            const SizedBox(height: 14),
            const Text('• Is there an expiration date on Zepto Cash? No, balance never expires.'),
            const SizedBox(height: 8),
            const Text('• Can I transfer Zepto Cash to a bank account? No, wallet funds can only be used on Zesty orders.'),
            const SizedBox(height: 8),
            const Text('• How do refunds work with Zepto Cash? Any cancellation is credited back within 2 seconds.'),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
