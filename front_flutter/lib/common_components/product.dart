class Product {
  final String name;
  final String type;
  final String imagePath;
  final double price;
  int amount;

  Product({
    required this.name,
    required this.type,
    required this.imagePath,
    required this.price,
    this.amount = 1,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] as String,
      type: json['type'] as String,
      imagePath: json['imagePath'] as String,
      price: (json['price'] as num).toDouble(),
    );
  }
}
