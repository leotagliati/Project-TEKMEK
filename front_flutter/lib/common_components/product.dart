class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  // final Map<String, String> specifications; // estou removendo o campo do objeto pq o banco nao ta desenhado assim, quando alterar o banco, esse campo volta!
  int amount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    // required this.specifications,
    this.amount =
        1, // esse campo precisa ser feito no banco pra juntar com a questao do carrinho
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // print("CAMPOS RECEBIDOS:");
    // print("id: ${json['id']}");
    // print("name: ${json['name']}");
    // print("price: ${json['price']}: ${json['price'].runtimeType}");
    // print("imageUrl: ${json['image_url']}");
    // print("description: ${json['description']}");

    Product jsonConverted = Product(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      price: double.parse(json['price']),
      imageUrl: json['image_url'] as String,
      description: json['description'] as String,
      // specifications: Map<String, String>.from(json['specifications']),
    );

    return (jsonConverted);
  }
}
