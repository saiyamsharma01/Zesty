import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;
  var stealDealTab = 'Trending'.obs;
  var freshTab = 'Bouquets & Plants'.obs;
  var clearanceSaleTab = 'Top Deals'.obs;

  void setStealDealTab(String tab) {
    stealDealTab.value = tab;
  }

  void setFreshTab(String tab) {
    freshTab.value = tab;
  }

  void setClearanceSaleTab(String tab) {
    clearanceSaleTab.value = tab;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading(true);
    try {
      final snapshot = await _database.child('products_v7').get();
      if (!snapshot.exists) {
        // Upload dummy data if node is empty
        await _uploadDummyProducts();
      }

      // Set up real-time listener
      _database.child('products_v7').onValue.listen((event) {
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
      final newRef = _database.child('products_v7').push();
      await newRef.set(product.toMap());
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _database.child('products_v7').child(product.id).update(product.toMap());
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _database.child('products_v7').child(id).remove();
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
    List<String> categories = ['Cafe', 'Beauty', 'Pharmacy', 'Toys', 'Mobiles', 'Home', 'Fresh', 'Electronics', 'Grocery', 'Fashion', 'Sports'];
    List<ProductModel> dummyProducts = [];

    // Specific Cafe Items based on user screenshots
    dummyProducts.addAll([
      ProductModel(id: '', name: 'Plain Maggi', networkImage: 'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?q=80&w=400&auto=format&fit=crop', price: 39.0, offer: '2 options', description: '250 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Bull\'s-eye Eggs', networkImage: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=400&auto=format&fit=crop', price: 39.0, offer: '2 options', description: '100 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Veg Puff', networkImage: 'https://images.unsplash.com/photo-1600119280267-33f78e0f98fb?q=80&w=400&auto=format&fit=crop', price: 49.0, offer: 'Customize', description: '100 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Vada Pav', networkImage: 'https://images.unsplash.com/photo-1626243029194-279261ed2435?q=80&w=400&auto=format&fit=crop', price: 59.0, offer: 'Customize', description: '120 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Masala Chaas', networkImage: 'https://images.unsplash.com/photo-1626844131082-256783844137?q=80&w=400&auto=format&fit=crop', price: 39.0, offer: '2 options', description: '250 ml', category: 'Cafe'),
      ProductModel(id: '', name: 'Butter Maggi', networkImage: 'https://images.unsplash.com/photo-1602881917760-73ce59c1581e?q=80&w=400&auto=format&fit=crop', price: 59.0, offer: '4 options', description: '260 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Lemon Iced Tea', networkImage: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?q=80&w=400&auto=format&fit=crop', price: 69.0, offer: '2 options', description: '250 ml', category: 'Cafe'),
      ProductModel(id: '', name: 'Tangy Kokum Sharbat', networkImage: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?q=80&w=400&auto=format&fit=crop', price: 49.0, offer: 'ADD', description: '250 ml', category: 'Cafe'),
      ProductModel(id: '', name: 'Mini Butter Croissants', networkImage: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?q=80&w=400&auto=format&fit=crop', price: 69.0, offer: '2 options', description: '60 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Cheese Maggi', networkImage: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?q=80&w=400&auto=format&fit=crop', price: 69.0, offer: '4 options', description: '270 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Chili Cheese Toast', networkImage: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?q=80&w=400&auto=format&fit=crop', price: 94.0, offer: 'ADD', description: '120 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Bhelpuri', networkImage: 'https://images.unsplash.com/photo-1645472856006-25916de84d1a?q=80&w=400&auto=format&fit=crop', price: 119.0, offer: 'Customize', description: '200 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Choco Lava Cake', networkImage: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?q=80&w=400&auto=format&fit=crop', price: 99.0, offer: 'ADD', description: '70 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Samosa Pav', networkImage: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?q=80&w=400&auto=format&fit=crop', price: 65.0, offer: 'Customize', description: '140 g', category: 'Cafe'),
      ProductModel(id: '', name: 'Butter Croissant', networkImage: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?q=80&w=400&auto=format&fit=crop', price: 97.0, offer: '2 options', description: '60 g', category: 'Cafe'),
    ]);

    for (String category in categories) {
      if (category == 'Cafe') continue; // We already added specific items
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
      final String? key = _database.child('products_v7').push().key;
      if (key != null) {
        updates[key] = product.toMap();
      }
    }
    
    await _database.child('products_v7').update(updates);
  }

  String _getImageForCategory(String category, int index) {
    // Generates a unique, real high-quality photo for every single item using a seed.
    String seed = '${category.replaceAll(' ', '')}$index';
    return 'https://picsum.photos/seed/Zesty$seed/400/400';
  }
}
