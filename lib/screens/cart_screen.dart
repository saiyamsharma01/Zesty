import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/address_bottom_sheet.dart';
import '../controllers/cart_controller.dart';
import '../models/cart_item_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartController cartController = Get.find<CartController>();
  
  String? _selectedAddressTitle;
  double? _selectedAddressDistance;
  bool _needBag = false;

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
                    _buildBillSummary(),
                    const SizedBox(height: 12),
                    _buildSavingsBreakdown(),
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
                Text('Apply coupons + payment offers & save more', style: TextStyle(color: Colors.blue.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Coupons & offers', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 16),
                _buildCouponItem(
                  icon: Icons.discount,
                  title: 'Save ₹50 with Z-PRIMESAVE50',
                  subtitle: 'View all coupons >',
                  couponCode: 'Z-PRIMESAVE50',
                  discountAmount: 50.0,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1, color: Color(0xFFEEEEEE)),
                ),
                _buildCouponItem(
                  icon: Icons.account_balance_wallet,
                  title: 'Get Upto ₹50 Cashback on using\nAmazon Pay',
                  subtitle: 'View all payment offers',
                  iconColor: Colors.black87,
                  couponCode: 'AMAZON50',
                  discountAmount: 50.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCouponItem({required IconData icon, required String title, required String subtitle, Color iconColor = Colors.green, required String couponCode, required double discountAmount}) {
    bool isApplied = cartController.appliedCoupon.value == couponCode;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(8),
            color: isApplied ? Colors.green.shade50 : Colors.transparent,
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.2, color: isApplied ? Colors.green.shade800 : Colors.black87)),
              const SizedBox(height: 2),
              Text(isApplied ? 'Coupon Applied!' : subtitle, style: TextStyle(color: isApplied ? Colors.green.shade600 : Colors.grey.shade600, fontSize: 12)),
            ],
          ),
        ),
        TextButton(
          onPressed: () {
            if (isApplied) {
              cartController.removeCoupon();
            } else {
              cartController.applyCoupon(couponCode, discountAmount);
            }
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: isApplied ? Colors.grey : Colors.pink.shade600)),
          ),
          child: Text(isApplied ? 'Remove' : 'Apply', style: TextStyle(color: isApplied ? Colors.grey.shade700 : Colors.pink.shade600, fontWeight: FontWeight.bold)),
        )
      ],
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
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200)
                    ),
                    child: Center(
                      child: item.product.networkImage.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(item.product.networkImage, fit: BoxFit.cover),
                            )
                          : Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 32),
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
            children: [
              Icon(Icons.receipt_long_outlined, size: 20),
              const SizedBox(width: 8),
              const Text('Bill Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          _buildBillRow('Item Total', '₹${cartController.originalSubTotal.toInt()}', '₹${cartController.subTotal.toInt()}'),
          const SizedBox(height: 12),
          _buildBillRow('Delivery Fee', '₹30', cartController.deliveryFee == 0 ? 'FREE' : '₹${cartController.deliveryFee.toInt()}', isFree: cartController.deliveryFee == 0),
          const SizedBox(height: 12),
          _buildBillRow('Handling Fee', '₹10', cartController.handlingFee == 0 ? 'FREE' : '₹${cartController.handlingFee.toInt()}', isFree: cartController.handlingFee == 0, isDashed: true),
          if (cartController.appliedCoupon.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildBillRow('Coupon Discount', '', '-₹${cartController.couponDiscountAmount.value.toInt()}', isFree: true),
          ],
          if (cartController.offerDiscount > 0) ...[
            const SizedBox(height: 12),
            _buildBillRow('Offer Discount', '', '-₹${cartController.offerDiscount.toInt()}', isFree: true),
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
                  Text('₹${(cartController.originalSubTotal + 40).toInt()}', style: TextStyle(color: Colors.grey.shade500, decoration: TextDecoration.lineThrough, fontSize: 14)),
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
          
          if (cartController.appliedCoupon.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Colors.black12),
            ),
            _buildSavingRow(Icons.discount, 'Coupon Discount', '₹${cartController.couponDiscountAmount.value.toInt()}'),
          ],
          
          if (cartController.offerDiscount > 0) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Colors.black12),
            ),
            _buildSavingRow(Icons.local_offer, 'Offer Discount', '₹${cartController.offerDiscount.toInt()}'),
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
