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
    // print("jso? ");
    // print(json);
    CartItem jsonConverted = CartItem(
      id: (json['product_id'] as num).toInt(),
      name: json['name'] as String,
      price: double.parse(json['price']),
      imageUrl: json['image_url'] as String,
      amount: (json['quantity'] as num).toInt(),
    );

    return (jsonConverted);
  }
}
