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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(icon, color: Colors.purple.shade300),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.purple, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      isEditing ? Icons.edit_note : Icons.add_box_outlined,
                      size: 48,
                      color: Colors.purple,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isEditing ? 'Update the details below' : 'Fill details to add a new product',
                      style: TextStyle(color: Colors.purple.shade700, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                icon: Icons.shopping_bag_outlined,
                validator: (value) => value!.isEmpty ? 'Enter product name' : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: 'Price (₹)',
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Enter price' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _offerController,
                      label: 'Offer (e.g., 10%)',
                      icon: Icons.local_offer_outlined,
                    ),
                  ),
                ],
              ),
              _buildTextField(
                controller: _categoryController,
                label: 'Category',
                icon: Icons.category_outlined,
                validator: (value) => value!.isEmpty ? 'Enter category' : null,
              ),
              _buildTextField(
                controller: _imageController,
                label: 'Image URL',
                icon: Icons.image_outlined,
                validator: (value) => value!.isEmpty ? 'Enter image URL' : null,
              ),
              _buildTextField(
                controller: _descController,
                label: 'Description',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                        )
                      : Text(
                          isEditing ? 'Update Product' : 'Save Product',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
