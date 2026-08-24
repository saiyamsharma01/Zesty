class ProductModel {
  final String id;
  final String name;
  final String networkImage;
  final double price;
  final String offer;
  final String description;
  final String category;

  ProductModel({
    required this.id,
    required this.name,
    required this.networkImage,
    required this.price,
    required this.offer,
    required this.description,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'networkImage': networkImage,
      'price': price,
      'offer': offer,
      'description': description,
      'category': category,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) {
    return ProductModel(
      id: id,
      name: map['name'] ?? '',
      networkImage: map['networkImage'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      offer: map['offer'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
    );
  }
}
