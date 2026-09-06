import 'package:get/get.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  // Map of productId to CartItemModel
  var items = <String, CartItemModel>{}.obs;

  // Coupons state
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
  }

  void updateQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      items.remove(productId);
    } else if (items.containsKey(productId)) {
      items[productId]!.quantity = newQuantity;
      items.refresh();
    }
  }

  void clearCart() {
    items.clear();
    removeCoupon();
    selectedDeliveryTime.value = 'Delivering in 6 mins';
  }

  void applyCoupon(String code, double amount) {
    appliedCoupon.value = code;
    couponDiscountAmount.value = amount;
  }

  void removeCoupon() {
    appliedCoupon.value = '';
    couponDiscountAmount.value = 0.0;
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

  // Calculate automatic offer discount based on subtotal tiers
  double get offerDiscount {
    if (subTotal >= 2699) return 200;
    if (subTotal >= 2099) return 150;
    if (subTotal >= 1499) return 100;
    if (subTotal >= 899) return 50;
    return 0;
  }

  double get toPay {
    double total = subTotal + deliveryFee + handlingFee - couponDiscountAmount.value - offerDiscount;
    return total < 0 ? 0 : total;
  }

  double get totalSavings {
    double savings = discount; // MRP discount
    savings += couponDiscountAmount.value; // Coupon discount
    savings += offerDiscount; // Automatic offer discount
    if (subTotal >= 149) savings += 30; // Delivery fee savings
    if (subTotal >= 199) savings += 10; // Handling fee savings
    return savings;
  }
}
