class CartItem {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  int amount;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.amount,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    print(
      "=== DEBUG: Tipos dos campos recebidos no JSON ===",
    ); // isso é intencional, muitas vezes temos error de conversao de objeto
    json.forEach((key, value) {
      print("$key -> ${value.runtimeType}: $value");
    });
    print("===============================================");
    CartItem jsonConverted = CartItem(
      id: (json['product_id'] as num).toInt(),
      name: json['name'] as String,
      price: json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.parse(json['price'].toString()),
      imageUrl: json['image_url'] as String,
      amount: (json['quantity'] as num).toInt(),
    );

    return (jsonConverted);
  }
}
