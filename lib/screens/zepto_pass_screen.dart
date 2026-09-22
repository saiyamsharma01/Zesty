import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ZeptoPassScreen extends StatefulWidget {
  const ZeptoPassScreen({super.key});

  @override
  State<ZeptoPassScreen> createState() => _ZeptoPassScreenState();
}

class _ZeptoPassScreenState extends State<ZeptoPassScreen> {
  int _selectedPlan = 1; // 0: 1 mo, 1: 3 mos, 2: 12 mos
  bool _isPassActive = false;

  final List<Map<String, dynamic>> _plans = [
    {'title': '1 Month', 'price': 49, 'mrp': 99, 'tag': 'BASIC'},
    {'title': '3 Months', 'price': 99, 'mrp': 249, 'tag': 'MOST POPULAR', 'badgeColor': 0xFFF0145A},
    {'title': '12 Months', 'price': 299, 'mrp': 599, 'tag': 'BEST VALUE', 'badgeColor': 0xFF059669},
  ];

  @override
  void initState() {
    super.initState();
    _loadPassStatus();
  }

  Future<void> _loadPassStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPassActive = prefs.getBool('zepto_pass_active') ?? false;
    });
  }

  Future<void> _togglePass() async {
    final prefs = await SharedPreferences.getInstance();
    final newStatus = !_isPassActive;
    await prefs.setBool('zepto_pass_active', newStatus);
    setState(() {
      _isPassActive = newStatus;
    });

    if (newStatus) {
      Get.snackbar(
        '🎉 Zepto Pass Activated!',
        'Enjoy Unlimited Free Deliveries & 20% off on Zepto Cafe!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFE8F8EE),
      );
    } else {
      Get.snackbar(
        'Subscription Cancelled',
        'Zepto Pass has been deactivated.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Zepto Pass VIP',
          style: TextStyle(color: Colors.black87, fontSize: 17, fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. VIP Card Header
            _buildVipMembershipCard(),
            const SizedBox(height: 20),

            // 2. Savings Calculation Banner
            _buildSavingsBanner(),
            const SizedBox(height: 24),

            // 3. Subscription Plans Selection
            const Text(
              'Select Your Membership Plan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            _buildPlansList(),
            const SizedBox(height: 24),

            // 4. VIP Perks & Benefits
            _buildPerksSection(),
            const SizedBox(height: 24),

            // 5. Frequently Asked Questions
            _buildFaqSection(),
            const SizedBox(height: 32),

            // 6. Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isPassActive ? Colors.red.shade600 : const Color(0xFFF0145A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
                onPressed: _togglePass,
                child: Text(
                  _isPassActive
                      ? 'Cancel Zepto Pass Membership'
                      : 'Join Zepto Pass • ₹${_plans[_selectedPlan]['price']}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVipMembershipCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF240046), Color(0xFF3C096C), Color(0xFF5A189A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5A189A).withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.workspace_premium, color: Color(0xFFFFD166), size: 28),
                  SizedBox(width: 8),
                  Text(
                    'zepto pass',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _isPassActive ? const Color(0xFF10B981) : const Color(0xFFFFD166),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _isPassActive ? 'ACTIVE MEMBER' : 'VIP PASS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: _isPassActive ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Unlimited Free Deliveries on all orders above ₹99.',
            style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Plus 20% OFF on Cafe, priority dispatch & exclusive deals.',
            style: TextStyle(fontSize: 12.5, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.savings_outlined, color: Color(0xFFD97706), size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Members save an average of ₹1,200/mo',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E)),
                ),
                Text(
                  'Your pass pays for itself in just 2 orders!',
                  style: TextStyle(fontSize: 11.5, color: Color(0xFFB45309)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList() {
    return Column(
      children: List.generate(_plans.length, (index) {
        final plan = _plans[index];
        final isSelected = _selectedPlan == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedPlan = index;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? const Color(0xFFF0145A) : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  color: isSelected ? const Color(0xFFF0145A) : Colors.grey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            plan['title'],
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          if (plan.containsKey('tag')) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(plan['badgeColor'] ?? 0xFF6B7280),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                plan['tag'],
                                style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        'Total ₹${plan['price']} for ${plan['title']}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '₹${plan['price']}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black87),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '₹${plan['mrp']}',
                      style: TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPerksSection() {
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
            'Zepto Pass Member Privileges',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          const SizedBox(height: 14),
          _buildPrivilegeRow(Icons.delivery_dining, 'Free Deliveries on ₹99+', 'Save ₹25 to ₹40 on every grocery order.'),
          const SizedBox(height: 12),
          _buildPrivilegeRow(Icons.local_cafe, 'Flat 20% Off Zepto Cafe', 'Save on hot brews, croissants, snacks & shakes.'),
          const SizedBox(height: 12),
          _buildPrivilegeRow(Icons.bolt, 'VIP Dark Store Priority', 'Your items get picked and packed on ultra fast lanes.'),
        ],
      ),
    );
  }

  Widget _buildPrivilegeRow(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E8FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF7E22CE)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFaqSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black87),
          ),
          SizedBox(height: 12),
          ExpansionTile(
            title: Text('What is the minimum order for free delivery?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('All orders with a subtotal above ₹99 qualify for 100% free delivery across all categories.', style: TextStyle(fontSize: 12, color: Colors.black54)),
              ),
            ],
          ),
          ExpansionTile(
            title: Text('Can I cancel my membership anytime?', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text('Yes, you can cancel your membership at any time with a single tap without any penalty.', style: TextStyle(fontSize: 12, color: Colors.black54)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
