import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/address_bottom_sheet.dart';
import '../widgets/coupon_details_bottom_sheet.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import '../models/cart_item_model.dart';
import '../models/coupon_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.find<CartController>();
  final TextEditingController _couponTextController = TextEditingController();
  
  String? _selectedAddressTitle;
  double? _selectedAddressDistance;
  bool _needBag = false;

  @override
  void dispose() {
    _couponTextController.dispose();
    super.dispose();
  }

  void _onSelectAddressTapped() {
    showAddressBottomSheet(context, (title, distance) {
      setState(() {
        _selectedAddressTitle = title;
        _selectedAddressDistance = distance;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7), // Light grey background
      appBar: _buildAppBar(),
      body: Obx(() {
        if (cartController.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text('Your cart is empty', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Add items to get started', style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Browse Products', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSavingsBanner(),
                    if (_selectedAddressTitle != null) _buildDistanceBanner(),
                    const SizedBox(height: 12),
                    _buildCouponsSection(),
                    const SizedBox(height: 12),
                    _buildDeliverySection(),
                    const SizedBox(height: 12),
                    _buildDeliveryInstructions(),
                    const SizedBox(height: 12),
                    _buildDeliveryPartnerTip(),
                    const SizedBox(height: 12),
                    _buildFeedingIndiaSection(),
                    const SizedBox(height: 12),
                    _buildBillSummary(),
                    const SizedBox(height: 12),
                    _buildSavingsBreakdown(),
                    const SizedBox(height: 12),
                    _buildCancellationPolicyCard(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
        onPressed: () => Get.back(),
      ),
      title: _selectedAddressTitle == null
          ? const Text('Cart', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_selectedAddressTitle!, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                    const Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 18),
                  ],
                ),
                const Text(
                  '1895, 1895, Phase 5, Sector 59, Sahibzada Ajit Singh N...',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
    );
  }

  Widget _buildSavingsBanner() {
    return Container(
      width: double.infinity,
      color: Colors.green.shade50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Yay! You saved ₹${cartController.totalSavings.toInt()} on this order',
            style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.w600, fontSize: 12),
          ),
          const SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, color: Colors.green.shade700, size: 16),
        ],
      ),
    );
  }

  Widget _buildDistanceBanner() {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade700,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'You are $_selectedAddressDistance Kms away from this location',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const Icon(Icons.close, color: Colors.white70, size: 16),
        ],
      ),
    );
  }

  Widget _buildCouponsSection() {
    final appliedCoupon = cartController.appliedCoupon.value;
    final couponDiscount = cartController.couponDiscountAmount.value;
    final appliedModel = cartController.appliedCouponModel.value;
    final bool hasCouponApplied = appliedCoupon.isNotEmpty;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('NEW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Apply coupons + payment offers & save more',
                    style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Promo Code Input Box
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: _couponTextController,
                          textCapitalization: TextCapitalization.characters,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                          decoration: const InputDecoration(
                            hintText: 'Enter code (e.g. DISCOUNT50)',
                            hintStyle: TextStyle(fontSize: 12, color: Colors.black38, fontWeight: FontWeight.normal),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          final code = _couponTextController.text.trim();
                          if (code.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please enter a coupon code')),
                            );
                            return;
                          }
                          final result = cartController.applyCouponByCode(code);
                          final bool isSuccess = result['success'] == true;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(isSuccess ? Icons.celebration : Icons.info_outline, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(result['message'] ?? '')),
                                ],
                              ),
                              backgroundColor: isSuccess ? const Color(0xFF1CB469) : Colors.orange.shade800,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                          if (isSuccess) {
                            _couponTextController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF006E),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Applied Banner
                if (hasCouponApplied) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: couponDiscount > 0 ? const Color(0xFFEBF9F1) : const Color(0xFFFFF7ED),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: couponDiscount > 0 ? const Color(0xFFB8EACC) : const Color(0xFFFED7AA),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          couponDiscount > 0 ? Icons.check_circle : Icons.warning_amber_rounded,
                          color: couponDiscount > 0 ? const Color(0xFF1CB469) : Colors.orange.shade800,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Coupon Applied: $appliedCoupon',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: couponDiscount > 0 ? const Color(0xFF0F5132) : Colors.orange.shade900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                couponDiscount > 0
                                    ? 'You are saving ₹${couponDiscount.toInt()} on this order!'
                                    : (appliedModel != null
                                        ? 'Add items worth ₹${cartController.getMissingAmountForCoupon(appliedModel).toInt()} more to activate discount'
                                        : 'Coupon requires higher cart total'),
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: couponDiscount > 0 ? const Color(0xFF198754) : Colors.orange.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            cartController.removeCoupon();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Coupon removed'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Text('Remove', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Recommended Coupons List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Coupons & offers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    GestureDetector(
                      onTap: () => _showAllCouponsBottomSheet(context),
                      child: Text(
                        'View all >',
                        style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ...CouponData.defaultCoupons.take(2).map((c) => _buildDynamicCouponItem(c)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                ...CouponData.bankOffers.take(1).map((b) => _buildDynamicCouponItem(b)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicCouponItem(CouponModel coupon) {
    final isApplied = cartController.appliedCoupon.value == coupon.code;
    final isApplicable = cartController.isCouponApplicable(coupon);
    final missingAmount = cartController.getMissingAmountForCoupon(coupon);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => CouponDetailsBottomSheet.show(context, coupon),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: isApplied ? const Color(0xFF1CB469) : Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
                color: isApplied ? const Color(0xFFE8F8F0) : Colors.grey.shade50,
              ),
              child: Icon(
                coupon.isBankOffer ? Icons.account_balance_wallet : Icons.discount,
                color: isApplied ? const Color(0xFF1CB469) : (coupon.isBankOffer ? Colors.black87 : Colors.green.shade700),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => CouponDetailsBottomSheet.show(context, coupon),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Save ₹${coupon.discountAmount.toInt()} with ${coupon.code}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: isApplied ? const Color(0xFF1CB469) : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.info_outline, size: 13, color: Colors.grey.shade500),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    isApplied
                        ? (cartController.couponDiscountAmount.value > 0 ? 'Coupon Applied!' : 'Add ₹${missingAmount.toInt()} more to activate')
                        : (isApplicable ? 'Applicable on this order' : 'Add items worth ₹${missingAmount.toInt()} more'),
                    style: TextStyle(
                      color: isApplied
                          ? (cartController.couponDiscountAmount.value > 0 ? const Color(0xFF1CB469) : Colors.orange.shade800)
                          : (isApplicable ? Colors.green.shade600 : Colors.grey.shade600),
                      fontSize: 11.5,
                      fontWeight: isApplicable ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (isApplied) {
                cartController.removeCoupon();
              } else {
                final result = cartController.applyCouponModel(coupon);
                final bool isSuccess = result['success'] == true;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(isSuccess ? Icons.celebration : Icons.info_outline, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(result['message'] ?? '')),
                      ],
                    ),
                    backgroundColor: isSuccess ? const Color(0xFF1CB469) : Colors.orange.shade800,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                );
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isApplied ? Colors.grey : const Color(0xFFFF006E),
                ),
              ),
            ),
            child: Text(
              isApplied ? 'Remove' : 'Apply',
              style: TextStyle(
                color: isApplied ? Colors.grey.shade700 : const Color(0xFFFF006E),
                fontWeight: FontWeight.bold,
                fontSize: 12.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAllCouponsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('All Coupons & Offers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final all = CouponData.allCoupons;
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: all.length,
                    separatorBuilder: (context, index) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final coupon = all[index];
                      return _buildDynamicCouponItem(coupon);
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDeliverySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.timer_outlined, color: Colors.black87, size: 24),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cartController.selectedDeliveryTime.value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('${cartController.totalItems} items', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Schedule Delivery', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 16),
                              ListTile(
                                leading: const Icon(Icons.wb_sunny_outlined, color: Colors.orange),
                                title: const Text('Tomorrow, 9 AM - 11 AM'),
                                onTap: () {
                                  cartController.selectedDeliveryTime.value = 'Tomorrow, 9 AM - 11 AM';
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.nights_stay_outlined, color: Colors.indigo),
                                title: const Text('Tomorrow, 5 PM - 7 PM'),
                                onTap: () {
                                  cartController.selectedDeliveryTime.value = 'Tomorrow, 5 PM - 7 PM';
                                  Navigator.pop(context);
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        );
                      }
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange.shade200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.orange.shade700, size: 16),
                        const SizedBox(width: 4),
                        const Text('Schedule', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          // Dynamic items
          ...cartController.items.values.map((item) => _buildCartItem(item)).toList(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Forgot something? ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Text('Add More Items', style: TextStyle(color: Colors.pink.shade600, fontWeight: FontWeight.bold, fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(CartItemModel item) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200, width: 0.8),
                    ),
                    child: Center(
                      child: item.product.networkImage.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  item.product.networkImage,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.shopping_bag_outlined, color: Colors.grey.shade400, size: 28),
                                ),
                              ),
                            )
                          : Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.product.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.2), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text('1 pc', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.pink.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.pink.shade100),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove, color: Colors.pink.shade600, size: 16),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          onPressed: () {
                            cartController.removeFromCart(item.product.id);
                          },
                        ),
                        Text('${item.quantity}', style: TextStyle(color: Colors.pink.shade600, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.add, color: Colors.pink.shade600, size: 16),
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          onPressed: () {
                            cartController.addToCart(item.product);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('₹${item.totalOriginalPrice.toInt()}', style: TextStyle(color: Colors.grey.shade500, decoration: TextDecoration.lineThrough, fontSize: 12)),
                      const SizedBox(width: 4),
                      Text('₹${item.totalPrice.toInt()}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
      ],
    );
  }

  Widget _buildDeliveryInstructions() {
    final instructions = [
      {'title': 'Leave at door', 'icon': Icons.door_front_door_outlined},
      {'title': 'Don\'t ring bell', 'icon': Icons.notifications_off_outlined},
      {'title': 'Avoid calling', 'icon': Icons.phone_disabled_outlined},
      {'title': 'Leave with guard', 'icon': Icons.security_outlined},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.directions_bike_outlined, size: 20, color: Color(0xFF3F007D)),
              SizedBox(width: 8),
              Text('Delivery Instructions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: instructions.map((inst) {
              return Obx(() {
                final isSelected = cartController.deliveryInstruction.value == inst['title'];
                return InkWell(
                  onTap: () {
                    if (isSelected) {
                      cartController.deliveryInstruction.value = '';
                    } else {
                      cartController.deliveryInstruction.value = inst['title'] as String;
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF3E8FF) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF9852F9) : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          inst['icon'] as IconData,
                          size: 14,
                          color: isSelected ? const Color(0xFF9852F9) : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          inst['title'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? const Color(0xFF9852F9) : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryPartnerTip() {
    final tips = [10.0, 20.0, 30.0, 50.0];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.volunteer_activism_outlined, size: 20, color: Color(0xFFF0145A)),
              SizedBox(width: 8),
              Text('Delivery Partner Tip', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '100% of your tip goes directly to your delivery partner.',
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          Row(
            children: tips.map((tip) {
              return Expanded(
                child: Obx(() {
                  final isSelected = cartController.tipAmount.value == tip;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: InkWell(
                      onTap: () {
                        if (isSelected) {
                          cartController.tipAmount.value = 0.0;
                        } else {
                          cartController.tipAmount.value = tip;
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFFFF0F5) : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? const Color(0xFFF0145A) : Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '₹${tip.toInt()}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.bold,
                              color: isSelected ? const Color(0xFFF0145A) : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedingIndiaSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        return Row(
          children: [
            Checkbox(
              value: cartController.feedingIndiaDonation.value,
              onChanged: (val) {
                cartController.feedingIndiaDonation.value = val ?? false;
              },
              activeColor: const Color(0xFFF0145A),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Feeding India Donation (₹1)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'Help feed a person in need with every meal.',
                    style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCancellationPolicyCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.shield_outlined, size: 18, color: Colors.green),
              SizedBox(width: 8),
              Text('Cancellation Policy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '100% refund for cancellations before your order is packed at dark store. Instant refunds credited directly to Zepto Cash.',
            style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, height: 1.35),
          ),
        ],
      ),
    );
  }

  Widget _buildBillSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.receipt_long_outlined, size: 20),
              SizedBox(width: 8),
              Text('Bill Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          _buildBillRow('Item Total', '₹${cartController.originalSubTotal.toInt()}', '₹${cartController.subTotal.toInt()}'),
          const SizedBox(height: 12),
          _buildBillRow('Delivery Fee', '₹30', cartController.deliveryFee == 0 ? 'FREE' : '₹${cartController.deliveryFee.toInt()}', isFree: cartController.deliveryFee == 0),
          const SizedBox(height: 12),
          _buildBillRow('Handling Fee', '₹10', cartController.handlingFee == 0 ? 'FREE' : '₹${cartController.handlingFee.toInt()}', isFree: cartController.handlingFee == 0, isDashed: true),
          if (cartController.tipAmount.value > 0) ...[
            const SizedBox(height: 12),
            _buildBillRow('Delivery Partner Tip', '', '₹${cartController.tipAmount.value.toInt()}'),
          ],
          if (cartController.feedingIndiaDonation.value) ...[
            const SizedBox(height: 12),
            _buildBillRow('Feeding India Donation', '', '₹1'),
          ],
          if (cartController.appliedCoupon.isNotEmpty && cartController.couponDiscountAmount.value > 0) ...[
            const SizedBox(height: 12),
            _buildBillRow('Coupon (${cartController.appliedCoupon.value}) Discount', '', '-₹${cartController.couponDiscountAmount.value.toInt()}', isFree: true),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('To Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Row(
                children: [
                  Text('₹${(cartController.originalSubTotal + 40 + cartController.tipAmount.value + (cartController.feedingIndiaDonation.value ? 1 : 0)).toInt()}', style: TextStyle(color: Colors.grey.shade500, decoration: TextDecoration.lineThrough, fontSize: 14)),
                  const SizedBox(width: 6),
                  Text('₹${cartController.toPay.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillRow(String title, String oldPrice, String newPrice, {bool isFree = false, bool isDashed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
            if (isDashed)
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 70,
                child: Row(
                  children: List.generate(15, (index) => Expanded(child: Container(color: index % 2 == 0 ? Colors.grey.shade400 : Colors.transparent, height: 1))),
                ),
              ),
          ],
        ),
        Row(
          children: [
            if (oldPrice.isNotEmpty)
              Text(oldPrice, style: TextStyle(color: Colors.grey.shade400, decoration: TextDecoration.lineThrough, fontSize: 13)),
            const SizedBox(width: 6),
            Text(
              newPrice,
              style: TextStyle(
                color: isFree ? Colors.green.shade700 : Colors.black87,
                fontWeight: isFree ? FontWeight.bold : FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSavingsBreakdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Savings on this order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('₹${cartController.totalSavings.toInt()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              )
            ],
          ),
          const SizedBox(height: 16),
          _buildSavingRow(Icons.percent, 'Discount on MRP', '₹${cartController.discount.toInt()}'),
          
          if (cartController.appliedCoupon.isNotEmpty && cartController.couponDiscountAmount.value > 0) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Colors.black12),
            ),
            _buildSavingRow(Icons.discount, 'Coupon (${cartController.appliedCoupon.value}) Discount', '₹${cartController.couponDiscountAmount.value.toInt()}'),
          ],

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Colors.black12),
          ),
          _buildSavingRow(Icons.card_giftcard, 'FREE delivery savings', cartController.deliveryFee == 0 ? '₹30' : '₹0'),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Colors.black12),
          ),
          _buildSavingRow(Icons.currency_rupee, 'Savings on Handling fee', cartController.handlingFee == 0 ? '₹10' : '₹0'),
        ],
      ),
    );
  }

  Widget _buildSavingRow(IconData icon, String title, String amount) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.green.shade600,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 12),
        ),
        const SizedBox(width: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
        const Spacer(),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildBottomBar() {
    if (_selectedAddressTitle == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -4), blurRadius: 10),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _onSelectAddressTapped,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade600,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Select Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), offset: const Offset(0, -4), blurRadius: 10),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _needBag,
                      onChanged: (val) {
                        setState(() {
                          _needBag = val ?? false;
                        });
                      },
                      activeColor: Colors.pink.shade600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text("I don't need a bag", style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Icon(Icons.eco, color: Colors.green.shade400, size: 18),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('To Pay', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      Text('₹${cartController.toPay.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bolt, color: Colors.black87, size: 20),
                          const SizedBox(width: 4),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('Instant Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text('Pay while we deliver', style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        // Record order in OrderController
                        final orderCtrl = Get.isRegistered<OrderController>()
                            ? Get.find<OrderController>()
                            : Get.put(OrderController());
                        orderCtrl.placeOrder(
                          cartItems: cartController.items.values.toList(),
                          totalAmount: cartController.toPay,
                          address: _selectedAddressTitle ?? 'Home',
                          appliedCoupon: cartController.appliedCoupon.value,
                          couponDiscount: cartController.couponDiscountAmount.value,
                        );

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: const EdgeInsets.all(32.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.green, size: 80),
                                    const SizedBox(height: 24),
                                    const Text('Order Placed Successfully!', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 12),
                                    Text('Arriving by ${cartController.selectedDeliveryTime.value.toLowerCase()}', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        Future.delayed(const Duration(seconds: 3), () {
                          cartController.clearCart();
                          Get.offAllNamed('/'); // Or Get.offAll(() => const HomeScreen()) but wait I need to import home_screen.dart
                          // Assuming Get.back() multiple times or Get.offAll is safe. Let's just use Get.offAll
                          Get.back(); // close dialog
                          Get.back(); // go back to home screen
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade600,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Pay Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
