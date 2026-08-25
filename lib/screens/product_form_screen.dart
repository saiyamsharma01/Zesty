import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';
import '../models/product_model.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductModel? product; // If null, it's Add mode. If provided, it's Edit mode.

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductController _productController = Get.find<ProductController>();

  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _offerController;
  late TextEditingController _imageController;
  late TextEditingController _categoryController;
  late TextEditingController _descController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _offerController = TextEditingController(text: widget.product?.offer ?? '');
    _imageController = TextEditingController(text: widget.product?.networkImage ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? 'Beauty'); // default to a valid category
    _descController = TextEditingController(text: widget.product?.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _offerController.dispose();
    _imageController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final newProduct = ProductModel(
        id: widget.product?.id ?? '', // Leave empty for new, Firebase push will generate key
        name: _nameController.text.trim(),
        networkImage: _imageController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        offer: _offerController.text.trim(),
        description: _descController.text.trim(),
        category: _categoryController.text.trim(),
      );

      if (widget.product == null) {
        // Add Product
        await _productController.addProduct(newProduct);
      } else {
        // Edit Product
        await _productController.updateProduct(newProduct);
      }

      setState(() {
        _isLoading = false;
      });
      
      Get.back(); // Return to previous screen
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter product name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (₹)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty ? 'Enter product price' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter product category' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _offerController,
                decoration: const InputDecoration(
                  labelText: 'Offer (e.g., 10% OFF)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Enter product image URL' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          isEditing ? 'Update Product' : 'Save Product',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
