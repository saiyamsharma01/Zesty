import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  var products = <ProductModel>[].obs;
  var isLoading = false.obs;

  // Home Screen dynamic tab states
  var buyAgainTab = 'All Items'.obs;
  var stealDealTab = 'Trending'.obs;
  var stealDealSubCategory = 'ALL'.obs;
  var freshTab = 'Bouquets & Plants'.obs;
  var clearanceSaleTab = 'Top Deals'.obs;

  void setBuyAgainTab(String tab) {
    buyAgainTab.value = tab;
  }

  void setStealDealTab(String tab) {
    stealDealTab.value = tab;
  }

  void setStealDealSubCategory(String subCat) {
    stealDealSubCategory.value = subCat;
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
    // Pre-populate with verified, rich catalog for instantaneous rendering
    products.assignAll(_getInitialProductCatalog());
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    isLoading(true);
    try {
      final snapshot = await _database.child('products_v8').get();
      if (!snapshot.exists) {
        // Upload rich catalog if node is empty
        await _uploadInitialProducts();
      }

      // Realtime listener
      _database.child('products_v8').onValue.listen((event) {
        if (event.snapshot.exists) {
          final Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
          final List<ProductModel> loadedProducts = [];
          for (var e in data.entries) {
            try {
              if (e.value is Map) {
                loadedProducts.add(ProductModel.fromMap(Map<String, dynamic>.from(e.value), e.key.toString()));
              }
            } catch (err) {
              // skip malformed
            }
          }
          if (loadedProducts.isNotEmpty) {
            products.assignAll(loadedProducts);
          }
        }
        isLoading(false);
      });
    } catch (e) {
      isLoading(false);
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      final newRef = _database.child('products_v8').push();
      await newRef.set(product.toMap());
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      await _database.child('products_v8').child(product.id).update(product.toMap());
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _database.child('products_v8').child(id).remove();
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  // ==========================================
  // DYNAMIC FILTERING METHODS
  // ==========================================

  List<ProductModel> getProductsByCategory(String category) {
    if (products.isEmpty) return [];
    final query = category.toLowerCase().trim();

    if (query == 'all' || query.isEmpty) {
      return products;
    }

    // Keyword based intelligent matching
    return products.where((p) {
      final cat = p.category.toLowerCase();
      final name = p.name.toLowerCase();

      if (query.contains('fruit') || query.contains('veg') || query == 'fresh') {
        return cat.contains('fresh') || cat.contains('fruit') || cat.contains('veg') || name.contains('mango') || name.contains('apple') || name.contains('tomato') || name.contains('banana') || name.contains('potato') || name.contains('onion') || name.contains('capsicum') || name.contains('plant') || name.contains('rose');
      }
      if (query.contains('dairy') || query.contains('bread') || query.contains('egg')) {
        return cat.contains('dairy') || cat.contains('bread') || cat.contains('egg') || name.contains('milk') || name.contains('butter') || name.contains('cheese') || name.contains('paneer') || name.contains('yogurt') || name.contains('egg');
      }
      if (query.contains('atta') || query.contains('rice') || query.contains('oil') || query.contains('dal')) {
        return cat.contains('atta') || cat.contains('rice') || cat.contains('oil') || cat.contains('dal') || cat.contains('staple') || name.contains('atta') || name.contains('oil') || name.contains('rice') || name.contains('dal') || name.contains('salt');
      }
      if (query.contains('meat') || query.contains('fish')) {
        return cat.contains('meat') || cat.contains('fish') || name.contains('chicken') || name.contains('fish') || name.contains('prawn') || name.contains('kebab');
      }
      if (query.contains('masala') || query.contains('dry fruit')) {
        return cat.contains('masala') || cat.contains('dry fruit') || name.contains('almond') || name.contains('kaju') || name.contains('cashew') || name.contains('mirch') || name.contains('turmeric') || name.contains('walnut');
      }
      if (query.contains('breakfast') || query.contains('sauce')) {
        return cat.contains('breakfast') || cat.contains('sauce') || name.contains('ketchup') || name.contains('corn flakes') || name.contains('oats') || name.contains('nutella') || name.contains('peanut butter') || name.contains('mayonnaise');
      }
      if (query.contains('cafe')) {
        return cat == 'cafe' || name.contains('maggi') || name.contains('croissant') || name.contains('puff') || name.contains('pav') || name.contains('chaas') || name.contains('tea') || name.contains('cake');
      }
      if (query.contains('tea') || query.contains('coffee')) {
        return cat.contains('tea') || cat.contains('coffee') || cat.contains('beverage') || name.contains('tea') || name.contains('coffee') || name.contains('nescafe');
      }
      if (query.contains('ice cream') || query.contains('sweet') || query.contains('craving')) {
        return cat.contains('ice cream') || cat.contains('sweet') || cat.contains('dessert') || name.contains('ice cream') || name.contains('chocolate') || name.contains('silk') || name.contains('kitkat') || name.contains('rocher') || name.contains('cornetto');
      }
      if (query.contains('cold drink') || query.contains('juice')) {
        return cat.contains('drink') || cat.contains('juice') || cat.contains('beverage') || name.contains('cola') || name.contains('thums up') || name.contains('juice') || name.contains('sprite') || name.contains('frooti') || name.contains('red bull');
      }
      if (query.contains('munchies') || query.contains('snack') || query.contains('packaged')) {
        return cat.contains('munchies') || cat.contains('snack') || cat.contains('packaged') || name.contains('lays') || name.contains('kurkure') || name.contains('nacho') || name.contains('bhujia') || name.contains('pringles') || name.contains('maggi');
      }
      if (query.contains('biscuit') || query.contains('cookie')) {
        return cat.contains('biscuit') || cat.contains('cookie') || name.contains('good day') || name.contains('parle') || name.contains('oreo') || name.contains('dark fantasy') || name.contains('bourbon') || name.contains('cookie');
      }
      if (query.contains('beauty') || query.contains('skin') || query.contains('personal care') || query.contains('makeup')) {
        return cat.contains('beauty') || cat.contains('skin') || cat.contains('personal') || name.contains('cream') || name.contains('shampoo') || name.contains('kajal') || name.contains('facewash') || name.contains('lotion') || name.contains('toothpaste') || name.contains('dettol');
      }
      if (query.contains('pharmacy') || query.contains('wellness')) {
        return cat.contains('pharmacy') || cat.contains('wellness') || name.contains('dolo') || name.contains('chyawanprash') || name.contains('vicks') || name.contains('revital') || name.contains('volini') || name.contains('savlon') || name.contains('vitamin');
      }
      if (query.contains('home') || query.contains('cleaning') || query.contains('household')) {
        return cat.contains('home') || cat.contains('clean') || cat.contains('household') || name.contains('surf excel') || name.contains('vim') || name.contains('harpic') || name.contains('colin') || name.contains('goodknight') || name.contains('ariel');
      }
      if (query.contains('electronic') || query.contains('super mall') || query.contains('mall')) {
        return cat.contains('electronic') || cat.contains('mall') || name.contains('headphone') || name.contains('boat') || name.contains('adapter') || name.contains('earphone') || name.contains('power bank') || name.contains('battery') || name.contains('bulb');
      }
      if (query.contains('toy') || query.contains('game') || query.contains('baby')) {
        return cat.contains('toy') || cat.contains('game') || cat.contains('baby') || name.contains('diaper') || name.contains('baby') || name.contains('hot wheels') || name.contains('uno') || name.contains('cube');
      }
      if (query.contains('apparel') || query.contains('fashion') || query.contains('lifestyle') || query.contains('jewellery')) {
        return cat.contains('fashion') || cat.contains('apparel') || cat.contains('lifestyle') || name.contains('t-shirt') || name.contains('kurti') || name.contains('wallet') || name.contains('sunglasses');
      }
      if (query.contains('price drop') || query.contains('drop')) {
        return p.price <= 60 || p.offer.contains('OFF') || p.offer.contains('%');
      }

      return cat.contains(query) || name.contains(query);
    }).toList();
  }

  List<ProductModel> getValuePicks() {
    if (products.isEmpty) return [];
    return products.where((p) => p.offer.contains('OFF') || p.price < 150).take(10).toList();
  }

  List<ProductModel> getBuyAgainProducts(String tab) {
    if (products.isEmpty) return [];
    if (tab == 'Zepto Cafe') {
      return products.where((p) => p.category == 'Cafe').take(10).toList();
    } else if (tab == 'Snacks & Drinks') {
      return products.where((p) => p.category.contains('Snacks') || p.category.contains('Drinks') || p.category.contains('Munchies')).take(10).toList();
    } else if (tab == 'Sweets & Chocolates') {
      return products.where((p) => p.category.contains('Sweet') || p.category.contains('Ice Creams') || p.name.contains('Chocolate') || p.name.contains('Silk')).take(10).toList();
    }
    // All items default
    return products.take(10).toList();
  }

  List<ProductModel> getBloomProducts() {
    if (products.isEmpty) return [];
    return products.where((p) => p.category == 'Fresh' || p.category == 'Fruits & Vegetables' || p.name.contains('Fresh') || p.name.contains('Bouquet') || p.name.contains('Plant')).take(8).toList();
  }

  List<ProductModel> getStealDeals(String priceTab, String subCategory) {
    if (products.isEmpty) return [];
    List<ProductModel> filtered = products;

    // Filter by price tab
    if (priceTab == '₹9\nStore' || priceTab == '₹9 Store') {
      filtered = filtered.where((p) => p.price <= 40).toList();
    } else if (priceTab == '₹19\nStore' || priceTab == '₹19 Store') {
      filtered = filtered.where((p) => p.price > 40 && p.price <= 80).toList();
    } else if (priceTab == '₹29\nStore' || priceTab == '₹29 Store') {
      filtered = filtered.where((p) => p.price > 80 && p.price <= 130).toList();
    } else {
      // Trending
      filtered = filtered.where((p) => p.price <= 99).toList();
    }

    // Filter by subcategory chip
    if (subCategory.contains('Masala') || subCategory.contains('Dry')) {
      filtered = filtered.where((p) => p.category.contains('Masala') || p.category.contains('Dry') || p.name.contains('Masala') || p.name.contains('Almond') || p.name.contains('Mirch')).toList();
    } else if (subCategory.contains('Ice Creams') || subCategory.contains('More')) {
      filtered = filtered.where((p) => p.category.contains('Ice Cream') || p.category.contains('Sweet') || p.name.contains('Ice Cream') || p.name.contains('Chocolate')).toList();
    }

    if (filtered.isEmpty) return products.take(6).toList();
    return filtered.take(8).toList();
  }

  List<ProductModel> getFreshProducts(String tab) {
    if (products.isEmpty) return [];
    if (tab == 'Bouquets & Plants') {
      return products.where((p) => p.name.contains('Bouquet') || p.name.contains('Plant') || p.name.contains('Rose') || p.name.contains('Lily')).toList();
    } else if (tab == 'Fruits') {
      return products.where((p) => p.name.contains('Mango') || p.name.contains('Apple') || p.name.contains('Banana') || p.name.contains('Strawberry') || p.category.contains('Fruit')).toList();
    } else if (tab == 'Veggies') {
      return products.where((p) => p.name.contains('Tomato') || p.name.contains('Capsicum') || p.name.contains('Onion') || p.name.contains('Potato') || p.name.contains('Broccoli') || p.name.contains('Coriander') || p.name.contains('Finger')).toList();
    } else {
      // Season's Best
      return products.where((p) => p.category == 'Fresh' || p.category == 'Fruits & Vegetables').take(8).toList();
    }
  }

  List<ProductModel> getBlockbusterDeals() {
    if (products.isEmpty) return [];
    return products.where((p) => p.offer.contains('OFF') && p.price >= 80).take(8).toList();
  }

  List<ProductModel> getClearanceProducts(String tab) {
    if (products.isEmpty) return [];
    if (tab == 'Electronics & Appliances') {
      return products.where((p) => p.category == 'Electronics Store' || p.name.contains('boAt') || nameContains(p, ['Adapter', 'Earphone', 'Headphone', 'Power Bank', 'Bulb', 'USB'])).toList();
    } else if (tab == 'Apparel & Lifestyle') {
      return products.where((p) => p.category == 'Fashion & Lifestyle' || nameContains(p, ['T-Shirt', 'Kurti', 'Wallet', 'Sunglasses', 'Jewellery'])).toList();
    }
    // Top Deals
    return products.where((p) => p.offer.contains('OFF') || p.price > 100).take(8).toList();
  }

  List<ProductModel> getSelectProducts(String category) {
    if (products.isEmpty) return [];
    if (category == 'All Select') {
      final res = products.where((p) => 
        p.category == 'Fruits & Vegetables' ||
        p.category == 'Dairy, Bread & Eggs' ||
        p.category == 'Zepto Cafe' ||
        p.category == 'Munchies & Snacks' ||
        nameContains(p, ['Organic', 'Avocado', 'Berry', 'Almond', 'Cheese', 'Paneer', 'Butter', 'Gourmet', 'Greek', 'Olive', 'Dark Chocolate'])
      ).toList();
      return res.isNotEmpty ? res : products.take(15).toList();
    } else if (category == 'Exotic Fruits & Veg') {
      final res = products.where((p) => 
        p.category == 'Fruits & Vegetables' || 
        nameContains(p, ['Avocado', 'Kiwi', 'Blueberry', 'Dragon', 'Broccoli', 'Mushroom', 'Capsicum', 'Apple', 'Orange', 'Banana', 'Tomato'])
      ).toList();
      return res.isNotEmpty ? res : products.where((p) => p.category == 'Fruits & Vegetables').toList();
    } else if (category == 'Organic Dairy') {
      final res = products.where((p) => 
        p.category == 'Dairy, Bread & Eggs' || 
        nameContains(p, ['Milk', 'Paneer', 'Butter', 'Cheese', 'Curd', 'Yogurt', 'Ghee', 'Cream'])
      ).toList();
      return res.isNotEmpty ? res : products.where((p) => p.category == 'Dairy, Bread & Eggs').toList();
    } else if (category == 'Artisan Bakery') {
      final res = products.where((p) => 
        nameContains(p, ['Bread', 'Croissant', 'Muffin', 'Cake', 'Cookie', 'Bun', 'Toast', 'Bagel', 'Brownie']) ||
        p.category == 'Zepto Cafe'
      ).toList();
      return res.isNotEmpty ? res : products.where((p) => p.category == 'Zepto Cafe').toList();
    } else if (category == 'Meat & Protein') {
      final res = products.where((p) => 
        p.category == 'Meat, Fish & Eggs' || 
        nameContains(p, ['Egg', 'Chicken', 'Fish', 'Soya', 'Tofu', 'Paneer', 'Protein', 'Peanut Butter'])
      ).toList();
      return res.isNotEmpty ? res : products.take(10).toList();
    } else if (category == 'Gourmet Chocolates') {
      final res = products.where((p) => 
        nameContains(p, ['Chocolate', 'Ferrero', 'Nutella', 'Cadbury', 'Amul Dark', 'Silk', 'Cookie', 'Waffle']) ||
        p.category == 'Ice Creams & More' ||
        p.category == 'Munchies & Snacks'
      ).toList();
      return res.isNotEmpty ? res : products.where((p) => p.category == 'Munchies & Snacks').toList();
    }
    return products.take(12).toList();
  }

  List<ProductModel> getSuperMallProducts(String category) {
    if (products.isEmpty) return [];
    if (category == 'All') {
      final res = products.where((p) => 
        p.category == 'Electronics Store' ||
        p.category == 'Fashion & Lifestyle' ||
        p.category == 'Home & Living' ||
        p.category == 'Beauty Store' ||
        p.category == 'Baby & Toys' ||
        nameContains(p, ['boAt', 'Headphone', 'Earphone', 'Charger', 'T-Shirt', 'Serum', 'Face Wash', 'Bottle', 'Toy', 'Appliance', 'Shampoo', 'Watch'])
      ).toList();
      return res.isNotEmpty ? res : products.where((p) => p.price > 120).toList();
    } else if (category == 'Electronics & Gadgets') {
      final res = products.where((p) => 
        p.category == 'Electronics Store' || 
        nameContains(p, ['boAt', 'Headphone', 'Earphone', 'Charger', 'Cable', 'Power Bank', 'Bulb', 'USB', 'Speaker', 'Watch', 'Mouse', 'Keyboard', 'Trimmer'])
      ).toList();
      return res.isNotEmpty ? res : products.where((p) => p.category == 'Electronics Store').toList();
    } else if (category == 'Beauty & Personal Care') {
      final res = products.where((p) => 
        p.category == 'Beauty Store' || 
        nameContains(p, ['Serum', 'Face Wash', 'Sunscreen', 'Shampoo', 'Lotion', 'Lipstick', 'Cream', 'Perfume', 'Deodorant', 'Nivea', 'Garnier', 'Dove'])
      ).toList();
      return res.isNotEmpty ? res : products.where((p) => p.category == 'Beauty Store').toList();
    } else if (category == 'Home & Living') {
      final res = products.where((p) => 
        p.category == 'Home & Living' || 
        nameContains(p, ['Bottle', 'Container', 'Bedsheet', 'Towel', 'Mop', 'Hanger', 'Curtain', 'Clock', 'Mat', 'Lamp', 'Pillow'])
      ).toList();
      return res.isNotEmpty ? res : products.where((p) => p.category == 'Home & Living').toList();
    } else if (category == 'Kitchen Appliances') {
      final res = products.where((p) => 
        nameContains(p, ['Mixer', 'Grinder', 'Kettle', 'Toaster', 'Pan', 'Cooker', 'Knife', 'Blender', 'Spatula', 'Fryer', 'Plate', 'Glass'])
      ).toList();
      return res.isNotEmpty ? res : products.where((p) => p.price > 200).toList();
    } else if (category == 'Toys & Kids') {
      final res = products.where((p) => 
        p.category == 'Baby & Toys' || 
        nameContains(p, ['Toy', 'Car', 'Doll', 'Game', 'Puzzle', 'Diaper', 'Lego', 'Pencil', 'Book', 'Board'])
      ).toList();
      return res.isNotEmpty ? res : products.where((p) => p.category == 'Baby & Toys').toList();
    }
    return products.where((p) => p.category == 'Electronics Store' || p.category == 'Fashion & Lifestyle').toList();
  }

  List<ProductModel> searchProducts(String query) {
    if (query.trim().isEmpty) return [];
    final cleanQuery = query.toLowerCase().trim();
    return products.where((p) {
      final nameMatch = p.name.toLowerCase().contains(cleanQuery);
      final catMatch = p.category.toLowerCase().contains(cleanQuery);
      final descMatch = p.description.toLowerCase().contains(cleanQuery);
      final offerMatch = p.offer.toLowerCase().contains(cleanQuery);
      return nameMatch || catMatch || descMatch || offerMatch;
    }).toList();
  }

  bool nameContains(ProductModel p, List<String> keywords) {
    for (var k in keywords) {
      if (p.name.toLowerCase().contains(k.toLowerCase())) return true;
    }
    return false;
  }

  Future<void> _uploadInitialProducts() async {
    final defaultCatalog = _getInitialProductCatalog();
    Map<String, dynamic> updates = {};
    for (var product in defaultCatalog) {
      final String? key = _database.child('products_v8').push().key;
      if (key != null) {
        updates[key] = product.toMap();
      }
    }
    await _database.child('products_v8').update(updates);
  }

  List<ProductModel> _getInitialProductCatalog() {
    return [
      // ================= FRESH FRUITS & VEGETABLES =================
      ProductModel(
        id: 'fresh_1',
        name: 'Fresh Alphonso Mangoes',
        networkImage: 'https://images.unsplash.com/photo-1553279768-865429fa0078?auto=format&fit=crop&w=400&q=80',
        price: 299.0,
        offer: '20% OFF',
        description: '1 kg (Approx 4-5 pcs)',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_2',
        name: 'Farm Fresh Hybrid Tomatoes',
        networkImage: 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?auto=format&fit=crop&w=400&q=80',
        price: 38.0,
        offer: '15% OFF',
        description: '1 kg',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_3',
        name: 'Fresh Green Capsicum',
        networkImage: 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?auto=format&fit=crop&w=400&q=80',
        price: 42.0,
        offer: '10% OFF',
        description: '500 g',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_4',
        name: 'Fresh Kashmiri Apples',
        networkImage: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?auto=format&fit=crop&w=400&q=80',
        price: 149.0,
        offer: '25% OFF',
        description: '1 kg',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_5',
        name: 'Fresh Lady Finger / Bhindi',
        networkImage: 'https://images.unsplash.com/photo-1525607551316-4a8e16d1f9ba?auto=format&fit=crop&w=400&q=80',
        price: 29.0,
        offer: '20% OFF',
        description: '500 g',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_6',
        name: 'Fresh Red Onions',
        networkImage: 'https://images.unsplash.com/photo-1618512496248-a07fe83aa8cb?auto=format&fit=crop&w=400&q=80',
        price: 35.0,
        offer: '12% OFF',
        description: '1 kg',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_7',
        name: 'Fresh Potatoes / Aloo',
        networkImage: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?auto=format&fit=crop&w=400&q=80',
        price: 28.0,
        offer: '10% OFF',
        description: '1 kg',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_8',
        name: 'Fresh Green Coriander Leaves',
        networkImage: 'https://images.unsplash.com/photo-1608686207856-001b95cf60ca?auto=format&fit=crop&w=400&q=80',
        price: 12.0,
        offer: '15% OFF',
        description: '100 g bunch',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_9',
        name: 'Fresh Robusta Bananas',
        networkImage: 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=400&q=80',
        price: 45.0,
        offer: '10% OFF',
        description: '6 pcs',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_10',
        name: 'Fresh Strawberry Box',
        networkImage: 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=400&q=80',
        price: 89.0,
        offer: '30% OFF',
        description: '200 g box',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_11',
        name: 'Fresh Green Broccoli',
        networkImage: 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?auto=format&fit=crop&w=400&q=80',
        price: 65.0,
        offer: '18% OFF',
        description: '500 g',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_12',
        name: 'Red Roses Floral Bouquet',
        networkImage: 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?auto=format&fit=crop&w=400&q=80',
        price: 199.0,
        offer: '25% OFF',
        description: '1 bunch (10 stems)',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_13',
        name: 'Golden Money Plant in Pot',
        networkImage: 'https://images.unsplash.com/photo-1485955900006-10f4d324d411?auto=format&fit=crop&w=400&q=80',
        price: 149.0,
        offer: '20% OFF',
        description: '1 pc indoor plant',
        category: 'Fresh',
      ),
      ProductModel(
        id: 'fresh_14',
        name: 'White Lily Floral Bouquet',
        networkImage: 'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?auto=format&fit=crop&w=400&q=80',
        price: 249.0,
        offer: '15% OFF',
        description: '1 bunch (6 stems)',
        category: 'Fresh',
      ),

      // ================= DAIRY, BREAD & EGGS =================
      ProductModel(
        id: 'dairy_1',
        name: 'Amul Salted Butter',
        networkImage: 'https://images.unsplash.com/photo-1589985270826-4b7bb135bc9d?auto=format&fit=crop&w=400&q=80',
        price: 275.0,
        offer: '5% OFF',
        description: '500 g pack',
        category: 'Dairy, Bread & Eggs',
      ),
      ProductModel(
        id: 'dairy_2',
        name: 'Mother Dairy Toned Milk',
        networkImage: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?auto=format&fit=crop&w=400&q=80',
        price: 28.0,
        offer: '5% OFF',
        description: '500 ml pouch',
        category: 'Dairy, Bread & Eggs',
      ),
      ProductModel(
        id: 'dairy_3',
        name: 'Britannia 100% Whole Wheat Bread',
        networkImage: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=400&q=80',
        price: 50.0,
        offer: '10% OFF',
        description: '400 g pack',
        category: 'Dairy, Bread & Eggs',
      ),
      ProductModel(
        id: 'dairy_4',
        name: 'Farm Fresh White Eggs',
        networkImage: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=400&q=80',
        price: 55.0,
        offer: '12% OFF',
        description: '6 pcs pack',
        category: 'Dairy, Bread & Eggs',
      ),
      ProductModel(
        id: 'dairy_5',
        name: 'Amul Fresh Malai Paneer',
        networkImage: 'https://images.unsplash.com/photo-1631452180519-c014fe946bc7?auto=format&fit=crop&w=400&q=80',
        price: 89.0,
        offer: '10% OFF',
        description: '200 g block',
        category: 'Dairy, Bread & Eggs',
      ),
      ProductModel(
        id: 'dairy_6',
        name: 'Epigamia Greek Yogurt Strawberry',
        networkImage: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=400&q=80',
        price: 60.0,
        offer: '15% OFF',
        description: '100 g cup',
        category: 'Dairy, Bread & Eggs',
      ),

      // ================= ATTA, RICE, OIL & DALS =================
      ProductModel(
        id: 'staple_1',
        name: 'Aashirvaad Superior Shudh Chakki Atta',
        networkImage: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=400&q=80',
        price: 245.0,
        offer: '15% OFF',
        description: '5 kg bag',
        category: 'Atta, Rice, Oil & Dals',
      ),
      ProductModel(
        id: 'staple_2',
        name: 'Fortune Sunlite Refined Sunflower Oil',
        networkImage: 'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?auto=format&fit=crop&w=400&q=80',
        price: 145.0,
        offer: '18% OFF',
        description: '1 L pouch',
        category: 'Atta, Rice, Oil & Dals',
      ),
      ProductModel(
        id: 'staple_3',
        name: 'Daawat Rozana Super Basmati Rice',
        networkImage: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?auto=format&fit=crop&w=400&q=80',
        price: 385.0,
        offer: '22% OFF',
        description: '5 kg bag',
        category: 'Atta, Rice, Oil & Dals',
      ),
      ProductModel(
        id: 'staple_4',
        name: 'Tata Sampann Unpolished Toor Dal',
        networkImage: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=400&q=80',
        price: 175.0,
        offer: '12% OFF',
        description: '1 kg pack',
        category: 'Atta, Rice, Oil & Dals',
      ),

      // ================= MEAT, FISH & EGGS =================
      ProductModel(
        id: 'meat_1',
        name: 'Fresh Chicken Curry Cut Skinless',
        networkImage: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?auto=format&fit=crop&w=400&q=80',
        price: 165.0,
        offer: '15% OFF',
        description: '500 g fresh cut',
        category: 'Meat, Fish & Eggs',
      ),
      ProductModel(
        id: 'meat_2',
        name: 'Fresh Rohu Fish Bengali Cut',
        networkImage: 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?auto=format&fit=crop&w=400&q=80',
        price: 210.0,
        offer: '12% OFF',
        description: '500 g clean cut',
        category: 'Meat, Fish & Eggs',
      ),
      ProductModel(
        id: 'meat_3',
        name: 'Fresh Cleaned & Deveined Prawns',
        networkImage: 'https://images.unsplash.com/photo-1565680018434-b513d5e5fd47?auto=format&fit=crop&w=400&q=80',
        price: 249.0,
        offer: '20% OFF',
        description: '250 g pack',
        category: 'Meat, Fish & Eggs',
      ),

      // ================= MASALA & DRY FRUITS =================
      ProductModel(
        id: 'masala_1',
        name: 'Nutraj California Whole Almonds / Badam',
        networkImage: 'https://images.unsplash.com/photo-1508061253366-f7da158b6d46?auto=format&fit=crop&w=400&q=80',
        price: 399.0,
        offer: '30% OFF',
        description: '500 g pouch',
        category: 'Masala & Dry Fruits',
      ),
      ProductModel(
        id: 'masala_2',
        name: 'Nutraj Whole Cashews / Kaju',
        networkImage: 'https://images.unsplash.com/photo-1567406893414-76b7b1e5a7a5?auto=format&fit=crop&w=400&q=80',
        price: 449.0,
        offer: '25% OFF',
        description: '500 g pouch',
        category: 'Masala & Dry Fruits',
      ),
      ProductModel(
        id: 'masala_3',
        name: 'MDH Deggi Mirch Special Powder',
        networkImage: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?auto=format&fit=crop&w=400&q=80',
        price: 82.0,
        offer: '10% OFF',
        description: '100 g box',
        category: 'Masala & Dry Fruits',
      ),

      // ================= BREAKFAST & SAUCES =================
      ProductModel(
        id: 'breakfast_1',
        name: 'Kellogg\'s Corn Flakes Original',
        networkImage: 'https://images.unsplash.com/photo-1584776296944-ab6fb57b0bdd?auto=format&fit=crop&w=400&q=80',
        price: 190.0,
        offer: '15% OFF',
        description: '475 g box',
        category: 'Breakfast & Sauces',
      ),
      ProductModel(
        id: 'breakfast_2',
        name: 'Nutella Hazelnut Cocoa Spread',
        networkImage: 'https://images.unsplash.com/photo-1541781774459-bb2af2f05b55?auto=format&fit=crop&w=400&q=80',
        price: 360.0,
        offer: '10% OFF',
        description: '350 g jar',
        category: 'Breakfast & Sauces',
      ),
      ProductModel(
        id: 'breakfast_3',
        name: 'Kissan Fresh Tomato Ketchup',
        networkImage: 'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?auto=format&fit=crop&w=400&q=80',
        price: 125.0,
        offer: '25% OFF',
        description: '950 g bottle',
        category: 'Breakfast & Sauces',
      ),

      // ================= SNACKS, MUNCHIES & PACKAGED FOOD =================
      ProductModel(
        id: 'snack_1',
        name: 'Maggi 2-Minute Instant Noodles',
        networkImage: 'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?auto=format&fit=crop&w=400&q=80',
        price: 84.0,
        offer: '12% OFF',
        description: '420 g (Pack of 6)',
        category: 'Munchies',
      ),
      ProductModel(
        id: 'snack_2',
        name: 'Lay\'s India\'s Magic Masala Chips',
        networkImage: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&w=400&q=80',
        price: 20.0,
        offer: '5% OFF',
        description: '50 g pouch',
        category: 'Munchies',
      ),
      ProductModel(
        id: 'snack_3',
        name: 'Doritos Nacho Cheese Tortilla Chips',
        networkImage: 'https://images.unsplash.com/photo-1513456852971-30c0b8199d4d?auto=format&fit=crop&w=400&q=80',
        price: 30.0,
        offer: '10% OFF',
        description: '60 g pouch',
        category: 'Munchies',
      ),

      // ================= TEA, COFFEE & BEVERAGES =================
      ProductModel(
        id: 'bev_1',
        name: 'Tata Tea Gold Leaf Tea',
        networkImage: 'https://images.unsplash.com/photo-1544787219-7f47ccb76574?auto=format&fit=crop&w=400&q=80',
        price: 310.0,
        offer: '15% OFF',
        description: '500 g pack',
        category: 'Tea, Coffee & More',
      ),
      ProductModel(
        id: 'bev_2',
        name: 'Nescafe Classic Instant Coffee',
        networkImage: 'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?auto=format&fit=crop&w=400&q=80',
        price: 340.0,
        offer: '10% OFF',
        description: '100 g glass jar',
        category: 'Tea, Coffee & More',
      ),
      ProductModel(
        id: 'bev_3',
        name: 'Coca-Cola Original Taste Soft Drink',
        networkImage: 'https://images.unsplash.com/photo-1554866585-cd94860890b7?auto=format&fit=crop&w=400&q=80',
        price: 40.0,
        offer: '10% OFF',
        description: '750 ml bottle',
        category: 'Cold Drinks & Juices',
      ),
      ProductModel(
        id: 'bev_4',
        name: 'Real Fruit Power Mixed Fruit Juice',
        networkImage: 'https://images.unsplash.com/photo-1600271886742-f049cd451bba?auto=format&fit=crop&w=400&q=80',
        price: 110.0,
        offer: '20% OFF',
        description: '1 L tetrapack',
        category: 'Cold Drinks & Juices',
      ),

      // ================= SWEETS, CHOCOLATES & ICE CREAMS =================
      ProductModel(
        id: 'sweet_1',
        name: 'Cadbury Dairy Milk Silk Chocolate',
        networkImage: 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?auto=format&fit=crop&w=400&q=80',
        price: 175.0,
        offer: '10% OFF',
        description: '150 g bar',
        category: 'Sweet Cravings',
      ),
      ProductModel(
        id: 'sweet_2',
        name: 'Ferrero Rocher Premium Chocolates',
        networkImage: 'https://images.unsplash.com/photo-1549007994-cb92caebd54b?auto=format&fit=crop&w=400&q=80',
        price: 499.0,
        offer: '15% OFF',
        description: '16 pcs gift box',
        category: 'Sweet Cravings',
      ),
      ProductModel(
        id: 'sweet_3',
        name: 'Amul Vanilla Magic Ice Cream Tub',
        networkImage: 'https://images.unsplash.com/photo-1501443762994-82bd5dace89a?auto=format&fit=crop&w=400&q=80',
        price: 160.0,
        offer: '10% OFF',
        description: '1 L tub',
        category: 'Ice Creams & More',
      ),
      ProductModel(
        id: 'sweet_4',
        name: 'Kwality Walls Cornetto Double Choc',
        networkImage: 'https://images.unsplash.com/photo-1501443762994-82bd5dace89a?auto=format&fit=crop&w=400&q=80',
        price: 45.0,
        offer: '10% OFF',
        description: '105 ml cone',
        category: 'Ice Creams & More',
      ),

      // ================= BISCUITS & COOKIES =================
      ProductModel(
        id: 'bisc_1',
        name: 'Britannia Good Day Butter Cookies',
        networkImage: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?auto=format&fit=crop&w=400&q=80',
        price: 35.0,
        offer: '12% OFF',
        description: '200 g pack',
        category: 'Biscuits & Cookies',
      ),
      ProductModel(
        id: 'bisc_2',
        name: 'Sunfeast Dark Fantasy Choco Fills',
        networkImage: 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?auto=format&fit=crop&w=400&q=80',
        price: 120.0,
        offer: '25% OFF',
        description: '300 g box',
        category: 'Biscuits & Cookies',
      ),

      // ================= BEAUTY & PERSONAL CARE =================
      ProductModel(
        id: 'beauty_1',
        name: 'Nivea Soft Light Moisturizing Cream',
        networkImage: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&fit=crop&w=400&q=80',
        price: 249.0,
        offer: '25% OFF',
        description: '200 ml jar',
        category: 'Beauty & Personal Care',
      ),
      ProductModel(
        id: 'beauty_2',
        name: 'Dettol Original Liquid Handwash Refill',
        networkImage: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
        price: 99.0,
        offer: '30% OFF',
        description: '675 ml pouch',
        category: 'Beauty & Personal Care',
      ),
      ProductModel(
        id: 'beauty_3',
        name: 'Dove Daily Shine Shampoo',
        networkImage: 'https://images.unsplash.com/photo-1535585209827-a15fcdbc4c2d?auto=format&fit=crop&w=400&q=80',
        price: 299.0,
        offer: '20% OFF',
        description: '340 ml bottle',
        category: 'Beauty & Personal Care',
      ),
      ProductModel(
        id: 'beauty_4',
        name: 'Colgate MaxFresh Spicy Fresh Toothpaste',
        networkImage: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&fit=crop&w=400&q=80',
        price: 115.0,
        offer: '15% OFF',
        description: '150 g tube',
        category: 'Beauty & Personal Care',
      ),
      ProductModel(
        id: 'beauty_5',
        name: 'Maybelline New York Colossal Kajal',
        networkImage: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?auto=format&fit=crop&w=400&q=80',
        price: 165.0,
        offer: '20% OFF',
        description: '0.35 g stick',
        category: 'Beauty & Personal Care',
      ),

      // ================= PHARMACY & WELLNESS =================
      ProductModel(
        id: 'pharm_1',
        name: 'Dolo 650 Paracetamol Tablets',
        networkImage: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
        price: 32.0,
        offer: '5% OFF',
        description: '15 tablets strip',
        category: 'Pharmacy & Wellness',
      ),
      ProductModel(
        id: 'pharm_2',
        name: 'Dabur Chyawanprash 2X Immunity',
        networkImage: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
        price: 375.0,
        offer: '18% OFF',
        description: '1 kg jar',
        category: 'Pharmacy & Wellness',
      ),
      ProductModel(
        id: 'pharm_3',
        name: 'Vicks VapoRub Cold Relief Balm',
        networkImage: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=400&q=80',
        price: 145.0,
        offer: '10% OFF',
        description: '50 g jar',
        category: 'Pharmacy & Wellness',
      ),

      // ================= HOUSEHOLD & HOME NEEDS =================
      ProductModel(
        id: 'home_1',
        name: 'Surf Excel Matic Top Load Detergent',
        networkImage: 'https://images.unsplash.com/photo-1585421514738-01798e348b17?auto=format&fit=crop&w=400&q=80',
        price: 399.0,
        offer: '20% OFF',
        description: '2 kg box',
        category: 'Household Essentials',
      ),
      ProductModel(
        id: 'home_2',
        name: 'Vim Dishwash Liquid Gel Lemon',
        networkImage: 'https://images.unsplash.com/photo-1585421514738-01798e348b17?auto=format&fit=crop&w=400&q=80',
        price: 155.0,
        offer: '18% OFF',
        description: '750 ml bottle',
        category: 'Household Essentials',
      ),
      ProductModel(
        id: 'home_3',
        name: 'Harpic Power Plus Toilet Cleaner',
        networkImage: 'https://images.unsplash.com/photo-1585421514738-01798e348b17?auto=format&fit=crop&w=400&q=80',
        price: 185.0,
        offer: '15% OFF',
        description: '1 L bottle',
        category: 'Household Essentials',
      ),

      // ================= ELECTRONICS & SUPER MALL =================
      ProductModel(
        id: 'elec_1',
        name: 'boAt Rockerz 450 Bluetooth Headphones',
        networkImage: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=400&q=80',
        price: 1299.0,
        offer: '65% OFF',
        description: '1 pc (Matte Black)',
        category: 'Electronics Store',
      ),
      ProductModel(
        id: 'elec_2',
        name: 'Portronics 20W Type-C Fast Adapter',
        networkImage: 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?auto=format&fit=crop&w=400&q=80',
        price: 399.0,
        offer: '60% OFF',
        description: '1 pc fast charger',
        category: 'Electronics Store',
      ),
      ProductModel(
        id: 'elec_3',
        name: 'boAt Bassheads 100 Wired Earphones',
        networkImage: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=400&q=80',
        price: 349.0,
        offer: '65% OFF',
        description: '1 pc with mic',
        category: 'Electronics Store',
      ),

      // ================= TOYS, GAMES & BABY CARE =================
      ProductModel(
        id: 'toy_1',
        name: 'Pampers All Round Baby Diapers L',
        networkImage: 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?auto=format&fit=crop&w=400&q=80',
        price: 499.0,
        offer: '20% OFF',
        description: '34 pcs pack',
        category: 'Toys & Games',
      ),
      ProductModel(
        id: 'toy_2',
        name: 'Hot Wheels 5-Car Diecast Gift Pack',
        networkImage: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=400&q=80',
        price: 649.0,
        offer: '15% OFF',
        description: '5 cars set',
        category: 'Toys & Games',
      ),
      ProductModel(
        id: 'toy_3',
        name: 'Uno Flip Playing Card Game',
        networkImage: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=400&q=80',
        price: 199.0,
        offer: '20% OFF',
        description: '1 card deck',
        category: 'Toys & Games',
      ),

      // ================= FASHION & APPAREL =================
      ProductModel(
        id: 'fash_1',
        name: 'Men\'s Solid Cotton Crew T-Shirt',
        networkImage: 'https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=400&q=80',
        price: 349.0,
        offer: '50% OFF',
        description: '1 pc (Navy Blue - L)',
        category: 'Fashion & Lifestyle',
      ),
      ProductModel(
        id: 'fash_2',
        name: 'Wildhorn Genuine Leather Men\'s Wallet',
        networkImage: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=400&q=80',
        price: 449.0,
        offer: '60% OFF',
        description: '1 pc (Dark Brown)',
        category: 'Fashion & Lifestyle',
      ),

      // ================= CAFE =================
      ProductModel(
        id: 'cafe_1',
        name: 'Plain Maggi',
        networkImage: 'https://images.unsplash.com/photo-1612929633738-8fe44f7ec841?auto=format&fit=crop&w=400&q=80',
        price: 39.0,
        offer: '2 options',
        description: '250 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_2',
        name: 'Bull\'s-eye Eggs',
        networkImage: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=400&q=80',
        price: 39.0,
        offer: '2 options',
        description: '100 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_3',
        name: 'Veg Puff',
        networkImage: 'https://images.unsplash.com/photo-1600119280267-33f78e0f98fb?auto=format&fit=crop&w=400&q=80',
        price: 49.0,
        offer: 'Customize',
        description: '100 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_4',
        name: 'Vada Pav',
        networkImage: 'https://images.unsplash.com/photo-1626243029194-279261ed2435?auto=format&fit=crop&w=400&q=80',
        price: 59.0,
        offer: 'Customize',
        description: '120 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_5',
        name: 'Masala Chaas',
        networkImage: 'https://images.unsplash.com/photo-1626844131082-256783844137?auto=format&fit=crop&w=400&q=80',
        price: 39.0,
        offer: '2 options',
        description: '250 ml',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_6',
        name: 'Butter Maggi',
        networkImage: 'https://images.unsplash.com/photo-1602881917760-73ce59c1581e?auto=format&fit=crop&w=400&q=80',
        price: 59.0,
        offer: '4 options',
        description: '260 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_7',
        name: 'Lemon Iced Tea',
        networkImage: 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=400&q=80',
        price: 69.0,
        offer: '2 options',
        description: '250 ml',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_8',
        name: 'Tangy Kokum Sharbat',
        networkImage: 'https://images.unsplash.com/photo-1513558161293-cdaf765ed2fd?auto=format&fit=crop&w=400&q=80',
        price: 49.0,
        offer: 'ADD',
        description: '250 ml',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_9',
        name: 'Mini Butter Croissants',
        networkImage: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=400&q=80',
        price: 69.0,
        offer: '2 options',
        description: '60 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_10',
        name: 'Cheese Maggi',
        networkImage: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?auto=format&fit=crop&w=400&q=80',
        price: 69.0,
        offer: '4 options',
        description: '270 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_11',
        name: 'Chili Cheese Toast',
        networkImage: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=400&q=80',
        price: 94.0,
        offer: 'ADD',
        description: '120 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_12',
        name: 'Bhelpuri',
        networkImage: 'https://images.unsplash.com/photo-1645472856006-25916de84d1a?auto=format&fit=crop&w=400&q=80',
        price: 119.0,
        offer: 'Customize',
        description: '200 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_13',
        name: 'Choco Lava Cake',
        networkImage: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?auto=format&fit=crop&w=400&q=80',
        price: 99.0,
        offer: 'ADD',
        description: '70 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_14',
        name: 'Samosa Pav',
        networkImage: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=400&q=80',
        price: 65.0,
        offer: 'Customize',
        description: '140 g',
        category: 'Cafe',
      ),
      ProductModel(
        id: 'cafe_15',
        name: 'Butter Croissant',
        networkImage: 'https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=400&q=80',
        price: 97.0,
        offer: '2 options',
        description: '60 g',
        category: 'Cafe',
      ),
    ];
  }
}
