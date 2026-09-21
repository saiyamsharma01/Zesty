import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../models/coupon_model.dart';

class CartController extends GetxController {
  // Map of productId to CartItemModel
  var items = <String, CartItemModel>{}.obs;

  // Coupons state
  var appliedCouponModel = Rxn<CouponModel>();
  var appliedCoupon = ''.obs;
  var couponDiscountAmount = 0.0.obs;

  // Delivery state
  var selectedDeliveryTime = 'Delivering in 6 mins'.obs;

  void addToCart(ProductModel product) {
    if (items.containsKey(product.id)) {
      items[product.id]!.quantity += 1;
      items.refresh();
    } else {
      items[product.id] = CartItemModel(product: product);
    }
    _validateAppliedCoupon();
  }

  void removeFromCart(String productId) {
    if (items.containsKey(productId)) {
      if (items[productId]!.quantity > 1) {
        items[productId]!.quantity -= 1;
        items.refresh();
      } else {
        items.remove(productId);
      }
    }
    _validateAppliedCoupon();
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      items.remove(productId);
    } else if (items.containsKey(productId)) {
      items[productId]!.quantity = newQuantity;
      items.refresh();
    }
    _validateAppliedCoupon();
  }

  void clearCart() {
    items.clear();
    removeCoupon();
    selectedDeliveryTime.value = 'Delivering in 6 mins';
  }

  Map<String, dynamic> applyCouponModel(CouponModel coupon) {
    appliedCouponModel.value = coupon;
    appliedCoupon.value = coupon.code;
    
    if (subTotal >= coupon.minOrderValue) {
      couponDiscountAmount.value = coupon.discountAmount;
      return {
        'success': true,
        'message': 'Coupon ${coupon.code} applied! You saved ₹${coupon.discountAmount.toInt()}',
      };
    } else {
      couponDiscountAmount.value = 0.0;
      final missing = (coupon.minOrderValue - subTotal).toInt();
      return {
        'success': false,
        'message': 'Add items worth ₹$missing more to activate ${coupon.code}',
      };
    }
  }

  Map<String, dynamic> applyCouponByCode(String code) {
    if (code.trim().isEmpty) {
      return {'success': false, 'message': 'Please enter a coupon code'};
    }
    final coupon = CouponData.getCouponByCode(code.trim());
    if (coupon == null) {
      return {'success': false, 'message': 'Invalid coupon code'};
    }
    return applyCouponModel(coupon);
  }

  void applyCoupon(String code, double amount) {
    final coupon = CouponData.getCouponByCode(code) ??
        CouponModel(
          code: code,
          title: 'Flat ₹${amount.toInt()} Off',
          shortTitle: 'FLAT\n₹${amount.toInt()} OFF',
          subtitle: 'Discount',
          discountAmount: amount,
          minOrderValue: 0.0,
        );
    applyCouponModel(coupon);
  }

  void removeCoupon() {
    appliedCouponModel.value = null;
    appliedCoupon.value = '';
    couponDiscountAmount.value = 0.0;
  }

  bool isCouponApplicable(CouponModel coupon) {
    return subTotal >= coupon.minOrderValue;
  }

  double getMissingAmountForCoupon(CouponModel coupon) {
    final diff = coupon.minOrderValue - subTotal;
    return diff > 0 ? diff : 0.0;
  }

  void _validateAppliedCoupon() {
    if (items.isEmpty) {
      removeCoupon();
      return;
    }
    if (appliedCouponModel.value != null) {
      final coupon = appliedCouponModel.value!;
      if (subTotal >= coupon.minOrderValue) {
        couponDiscountAmount.value = coupon.discountAmount;
      } else {
        couponDiscountAmount.value = 0.0;
      }
    }
  }

  int getQuantity(String productId) {
    return items.containsKey(productId) ? items[productId]!.quantity : 0;
  }

  // Derived getters for Bill Summary
  int get totalItems {
    return items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  double get subTotal {
    return items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  double get originalSubTotal {
    return items.values.fold(0.0, (sum, item) => sum + item.totalOriginalPrice);
  }

  double get discount {
    return originalSubTotal - subTotal;
  }

  double get deliveryFee {
    if (subTotal == 0) return 0;
    return subTotal >= 149 ? 0 : 30; // Free delivery over ₹149 based on offer
  }

  double get handlingFee {
    if (subTotal == 0) return 0;
    return subTotal >= 199 ? 0 : 10; // Free handling over ₹199
  }

  // Offer discount (0 when coupon discount is active)
  double get offerDiscount {
    return 0.0;
  }

  double get toPay {
    double total = subTotal + deliveryFee + handlingFee - couponDiscountAmount.value;
    return total < 0 ? 0 : total;
  }

  double get totalSavings {
    double savings = discount; // MRP discount
    savings += couponDiscountAmount.value; // Coupon discount
    if (subTotal >= 149) savings += 30; // Delivery fee savings
    if (subTotal >= 199) savings += 10; // Handling fee savings
    return savings;
  }
}
