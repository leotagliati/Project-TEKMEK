class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String layoutSize;
  final String connectivity;
  final String productType;
  final String keycapType;
  int amount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.layoutSize,
    required this.connectivity,
    required this.productType,
    required this.keycapType,
    this.amount =
        1, // esse campo precisa ser feito no banco pra juntar com a questao do carrinho
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // print(
    //   "=== DEBUG: Tipos dos campos recebidos no JSON ===",
    // ); // isso é intencional, muitas vezes temos error de conversao de objeto
    // json.forEach((key, value) {
    //   print("$key -> ${value.runtimeType}: $value");
    // });
    // print("===============================================");

    Product jsonConverted = Product(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: double.parse(json['price']),
      imageUrl: json['image_url'] as String,
      description: json['description'] as String,
      layoutSize: json['layout_size'] as String,
      connectivity: json['connectivity'] as String,
      productType: json['product_type'] as String,
      keycapType: json['keycaps_type'] as String,
    );
    return (jsonConverted);
  }
}
