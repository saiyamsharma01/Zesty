import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManagePaymentsScreen extends StatefulWidget {
  const ManagePaymentsScreen({super.key});

  @override
  State<ManagePaymentsScreen> createState() => _ManagePaymentsScreenState();
}

class _ManagePaymentsScreenState extends State<ManagePaymentsScreen> {
  // Dynamic wallet link states
  bool isAmazonPayLinked = false;
  double amazonPayBalance = 0.0;
  bool isAmazonPayLaterLinked = false;
  bool isOneClickUpiEnabled = true;

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
              // 1. Top Header Bar
              _buildTopBar(),
              const SizedBox(height: 16),

              // 2. Zepto UPI Management Card
              _buildZeptoUpiCard(),
              const SizedBox(height: 24),

              // 3. Section: Wallets
              const Text(
                'Wallets',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              _buildAmazonPayBalanceCard(),
              const SizedBox(height: 24),

              // 4. Section: Pay Later
              const Text(
                'Pay Later',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 12),
              _buildAmazonPayLaterCard(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 1. TOP HEADER BAR
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
          'Manage Payments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 2. ZEPTO UPI MANAGEMENT CARD
  // ============================================================
  Widget _buildZeptoUpiCard() {
    return Container(
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
        children: [
          // Top Banner Row (zepto UPI + 1-CLICK UPI Badge)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'zepto',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF7E22CE),
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 6),
                    // UPI Logo
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF0F9D58), Color(0xFF4285F4), Color(0xFFF4B400)],
                      ).createShader(bounds),
                      child: const Text(
                        'UPI',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                // 1-CLICK UPI Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D9488),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.bolt_rounded, color: Colors.white, size: 14),
                      SizedBox(width: 2),
                      Text(
                        '1-CLICK UPI',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 10.5,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Container(
            height: 1,
            color: const Color(0xFFF3F4F6),
          ),

          // Zepto UPI Management Tile
          InkWell(
            onTap: _showZeptoUpiSheet,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Mini Z UPI icon box
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF5FF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE9D5FF), width: 1.1),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Z',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF7E22CE),
                              fontFamily: 'serif',
                            ),
                          ),
                          Text(
                            'UPI',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF7E22CE),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Zepto UPI Management',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Manage everything related to Zepto UPI',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Red/Pink Chevron
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFFFF2B66),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 3. WALLETS (AMAZON PAY BALANCE)
  // ============================================================
  Widget _buildAmazonPayBalanceCard() {
    return Container(
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
      child: InkWell(
        onTap: _toggleAmazonPay,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Amazon Pay Logo Icon
              _buildAmazonPayIcon(),
              const SizedBox(width: 14),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amazon Pay Balance',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    if (isAmazonPayLinked)
                      Text(
                        'Available: ₹$amazonPayBalance',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),

              // Link > Action
              Text(
                isAmazonPayLinked ? 'Unlink' : 'Link >',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: isAmazonPayLinked ? Colors.grey.shade600 : const Color(0xFFFF2B66),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // 4. PAY LATER (AMAZON PAY LATER)
  // ============================================================
  Widget _buildAmazonPayLaterCard() {
    return Container(
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
      child: InkWell(
        onTap: _toggleAmazonPayLater,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // Amazon Pay Logo Icon
              _buildAmazonPayIcon(),
              const SizedBox(width: 14),

              // Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Amazon Pay Later',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    if (isAmazonPayLaterLinked)
                      const Text(
                        'Active Limit: ₹10,000',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF16A34A),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),

              // Link > Action
              Text(
                isAmazonPayLaterLinked ? 'Unlink' : 'Link >',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: isAmazonPayLaterLinked ? Colors.grey.shade600 : const Color(0xFFFF2B66),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmazonPayIcon() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'pay',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFF232F3E),
              ),
            ),
            Container(
              width: 18,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9900),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // INTERACTIVE BOTTOM SHEETS & ACTIONS
  // ============================================================
  void _showZeptoUpiSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Zepto UPI Management',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('1-Click Superfast UPI Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Complete orders without switching apps'),
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF0D9488),
              value: isOneClickUpiEnabled,
              onChanged: (val) {
                setState(() => isOneClickUpiEnabled = val);
                Get.back();
                Get.snackbar('1-Click UPI', val ? '1-Click UPI enabled' : '1-Click UPI disabled');
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.account_balance, color: Color(0xFF7E22CE)),
              title: const Text('Manage Linked Bank Accounts'),
              subtitle: const Text('Primary: HDFC Bank •••• 4892'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.back();
                Get.snackbar('Bank Accounts', 'Primary account verified');
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.lock_outline, color: Color(0xFF7E22CE)),
              title: const Text('Change UPI PIN'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Get.back();
                Get.snackbar('Security', 'UPI PIN management prompt opened');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleAmazonPay() {
    if (isAmazonPayLinked) {
      setState(() {
        isAmazonPayLinked = false;
        amazonPayBalance = 0.0;
      });
      Get.snackbar('Amazon Pay', 'Wallet unlinked successfully');
    } else {
      final phoneCtrl = TextEditingController(text: '9876543210');
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Link Amazon Pay Wallet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Enter mobile number registered with Amazon:'),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixText: '+91 ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3F007D)),
                  onPressed: () {
                    setState(() {
                      isAmazonPayLinked = true;
                      amazonPayBalance = 1250.0;
                    });
                    Get.back();
                    Get.snackbar('Success', 'Amazon Pay linked successfully! Balance: ₹1,250');
                  },
                  child: const Text('Link & Verify', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _toggleAmazonPayLater() {
    if (isAmazonPayLaterLinked) {
      setState(() {
        isAmazonPayLaterLinked = false;
      });
      Get.snackbar('Amazon Pay Later', 'Pay Later unlinked');
    } else {
      setState(() {
        isAmazonPayLaterLinked = true;
      });
      Get.snackbar('Success', 'Amazon Pay Later activated with ₹10,000 credit limit!');
    }
  }
}
