import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;
  var stealDealTab = 'Trending'.obs;

  void setStealDealTab(String tab) {
    stealDealTab.value = tab;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading(true);
    try {
      final snapshot = await _database.child('products_v6').get();
      if (!snapshot.exists) {
        // Upload dummy data if node is empty
        await _uploadDummyProducts();
      }

      // Set up real-time listener
      _database.child('products_v6').onValue.listen((event) {
        if (event.snapshot.exists) {
          final Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          final List<ProductModel> loadedProducts = [];
          for (var e in data.entries) {
            try {
              if (e.value is Map) {
                loadedProducts.add(ProductModel.fromMap(Map<String, dynamic>.from(e.value), e.key.toString()));
              }
            } catch (err) {
              print('Skipping malformed product: $err');
            }
          }
          products.assignAll(loadedProducts);
        } else {
          products.clear();
        }
        isLoading(false);
      });
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', 'Failed to fetch products: $e');
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      final newRef = _database.child('products_v6').push();
      await newRef.set(product.toMap());
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _database.child('products_v6').child(product.id).update(product.toMap());
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _database.child('products_v6').child(id).remove();
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  List<ProductModel> getProductsByCategory(String category) {
    if (category == 'All') {
      return products;
    }
    return products.where((p) => p.category == category).toList();
  }

  Future<void> _uploadDummyProducts() async {
    List<String> categories = ['Beauty', 'Pharmacy', 'Toys', 'Mobiles', 'Home', 'Fresh', 'Electronics', 'Grocery', 'Fashion', 'Sports'];
    List<ProductModel> dummyProducts = [];

    for (String category in categories) {
      for (int i = 1; i <= 20; i++) {
        dummyProducts.add(
          ProductModel(
            id: '',
            name: '$category Item $i',
            networkImage: _getImageForCategory(category, i),
            price: (20.0 * i) % 500 + 10,
            offer: '${(i % 5) * 5}% OFF',
            description: 'This is a high-quality $category item.',
            category: category,
          ),
        );
      }
    }

    Map<String, dynamic> updates = {};
    for (var product in dummyProducts) {
      final String? key = _database.child('products_v6').push().key;
      if (key != null) {
        updates[key] = product.toMap();
      }
    }
    
    await _database.child('products_v6').update(updates);
  }

  String _getImageForCategory(String category, int index) {
    // Generates a unique, real high-quality photo for every single item using a seed.
    String seed = '${category.replaceAll(' ', '')}$index';
    return 'https://picsum.photos/seed/Zesty$seed/400/400';
  }
}
