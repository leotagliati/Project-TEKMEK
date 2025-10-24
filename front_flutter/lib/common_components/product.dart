class Product {
  final int id;
  final String name;
  final String type;
  final double price;
  final String imageUrl;
  final String description;
  final Map<String, String> specifications;
  int amount;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.specifications,
    this.amount = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: json['type'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      specifications: Map<String, String>.from(json['specifications']),
    );
  }
}
