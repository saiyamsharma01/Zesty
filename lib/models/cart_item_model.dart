import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  // Example helper to calculate discounted price for demo purposes
  // Real implementation might have an MRP field in ProductModel.
  double get totalOriginalPrice => (product.price + 500) * quantity;
  double get totalPrice => product.price * quantity;
}
