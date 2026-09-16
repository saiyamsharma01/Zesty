import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'cart_controller.dart';

class OrderController extends GetxController {
  var orders = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (doc.exists && doc.data() != null && doc.data()!.containsKey('orders')) {
          final List<dynamic> list = doc.data()!['orders'];
          orders.value = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        } else {
          _seedDefaultOrders();
        }
      } catch (e) {
        _seedDefaultOrders();
      }
    } else {
      _seedDefaultOrders();
    }
  }

  void _seedDefaultOrders() {
    orders.value = [
      {
        'id': 'ORD-98421',
        'status': 'cancelled',
        'statusText': 'Order cancelled',
        'totalAmount': 485.0,
        'placedAt': '2nd Sep 2026, 07:00 pm',
        'items': [
          {
            'name': 'Maggi 2-Minute Noodles',
            'image': 'https://images.unsplash.com/photo-1612927601601-6638404737ce?w=200&q=80',
            'price': 40.0,
            'quantity': 2,
          },
          {
            'name': 'Lays Classic Salted Chips',
            'image': 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=200&q=80',
            'price': 30.0,
            'quantity': 1,
          },
          {
            'name': 'Sting Energy Drink',
            'image': 'https://images.unsplash.com/photo-1622543925917-763c34d1a86e?w=200&q=80',
            'price': 20.0,
            'quantity': 2,
          },
          {
            'name': 'Cadbury Silk Chocolate',
            'image': 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?w=200&q=80',
            'price': 175.0,
            'quantity': 1,
          },
          {
            'name': 'Oreo Vanilla Biscuits',
            'image': 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=200&q=80',
            'price': 40.0,
            'quantity': 2,
          },
        ],
      },
      {
        'id': 'ORD-98104',
        'status': 'cancelled',
        'statusText': 'Order cancelled',
        'totalAmount': 338.0,
        'placedAt': '2nd Sep 2026, 06:26 pm',
        'items': [
          {
            'name': 'Doritos Sweet Chilli',
            'image': 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=200&q=80',
            'price': 50.0,
            'quantity': 2,
          },
          {
            'name': 'Doritos Cheese Supreme',
            'image': 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=200&q=80',
            'price': 50.0,
            'quantity': 1,
          },
          {
            'name': 'Cheetos Crunchy',
            'image': 'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac?w=200&q=80',
            'price': 40.0,
            'quantity': 2,
          },
          {
            'name': 'Kurkure Masala Munch',
            'image': 'https://images.unsplash.com/photo-1621996346565-e3d5d6281699?w=200&q=80',
            'price': 30.0,
            'quantity': 2,
          },
        ],
      },
    ];
  }

  Future<void> placeOrder({
    required List<CartItemModel> cartItems,
    required double totalAmount,
    required String address,
  }) async {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final timeStr = '${now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour)}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'pm' : 'am'}';
    final dateStr = '${now.day}th ${months[now.month - 1]} ${now.year}, $timeStr';

    final newOrder = {
      'id': 'ORD-${now.millisecondsSinceEpoch.toString().substring(7)}',
      'status': 'delivered',
      'statusText': 'Order delivered',
      'totalAmount': totalAmount,
      'placedAt': dateStr,
      'address': address,
      'items': cartItems.map((item) => {
        'name': item.product.name,
        'image': item.product.networkImage,
        'price': item.product.price,
        'quantity': item.quantity,
      }).toList(),
    };

    orders.insert(0, newOrder);
    await _saveOrdersToFirebase();
  }

  Future<void> deleteOrder(String orderId) async {
    orders.removeWhere((item) => item['id'] == orderId);
    await _saveOrdersToFirebase();
  }

  Future<void> cancelOrder(String orderId) async {
    final idx = orders.indexWhere((item) => item['id'] == orderId);
    if (idx != -1) {
      orders[idx]['status'] = 'cancelled';
      orders[idx]['statusText'] = 'Order cancelled';
      orders.refresh();
      await _saveOrdersToFirebase();
    }
  }

  void reorder(Map<String, dynamic> order) {
    if (Get.isRegistered<CartController>()) {
      final cartCtrl = Get.find<CartController>();
      final List<dynamic> items = order['items'] ?? [];
      for (var item in items) {
        final prod = ProductModel(
          id: item['name'] ?? 'reorder-item',
          name: item['name'] ?? 'Product',
          networkImage: item['image'] ?? '',
          price: (item['price'] is num) ? (item['price'] as num).toDouble() : 50.0,
          offer: '',
          description: '',
          category: 'Snacks',
        );
        cartCtrl.addToCart(prod);
      }
      Get.snackbar('Items Added', 'Order items added to your cart!', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> _saveOrdersToFirebase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          {'orders': orders.toList()},
          SetOptions(merge: true),
        );
      } catch (e) {
        debugPrint('Error saving orders: $e');
      }
    }
  }
}
