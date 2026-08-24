import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading(true);
    try {
      final snapshot = await _database.child('products').get();
      if (!snapshot.exists) {
        // Upload dummy data if node is empty
        await _uploadDummyProducts();
        final newSnapshot = await _database.child('products').get();
        if (newSnapshot.exists) {
          final Map<dynamic, dynamic> data = newSnapshot.value as Map<dynamic, dynamic>;
          products.value = data.entries.map((e) {
            return ProductModel.fromMap(Map<String, dynamic>.from(e.value), e.key.toString());
          }).toList();
        }
      } else {
        final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        products.value = data.entries.map((e) {
          return ProductModel.fromMap(Map<String, dynamic>.from(e.value), e.key.toString());
        }).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _uploadDummyProducts() async {
    List<ProductModel> dummyProducts = [
      ProductModel(
        id: '',
        name: 'Fresh Toned Milk 500ml',
        networkImage: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&q=80&w=300',
        price: 32.0,
        offer: '5% OFF',
        description: 'Fresh and pure toned milk, delivered daily.',
        category: 'Dairy',
      ),
      ProductModel(
        id: '',
        name: 'Whole Wheat Bread',
        networkImage: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&q=80&w=300',
        price: 45.0,
        offer: '10% OFF',
        description: 'Healthy and soft whole wheat bread.',
        category: 'Bakery',
      ),
      ProductModel(
        id: '',
        name: 'Farm Fresh Eggs (6 pcs)',
        networkImage: 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?auto=format&fit=crop&q=80&w=300',
        price: 60.0,
        offer: 'Super Saver',
        description: 'White eggs sourced directly from farms.',
        category: 'Eggs',
      ),
      ProductModel(
        id: '',
        name: 'Amul Butter 100g',
        networkImage: 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?auto=format&fit=crop&q=80&w=300',
        price: 58.0,
        offer: 'Best Price',
        description: 'Delicious Amul pasteurised butter.',
        category: 'Dairy',
      ),
      ProductModel(
        id: '',
        name: 'Lays Magic Masala 50g',
        networkImage: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&q=80&w=300',
        price: 20.0,
        offer: 'Trending',
        description: 'Crunchy potato chips with magic masala flavor.',
        category: 'Snacks',
      ),
    ];

    for (var product in dummyProducts) {
      final newRef = _database.child('products').push();
      await newRef.set(product.toMap());
    }
  }
}
