import 'package:postgres/postgres.dart';

class CartItemDto {
  final int id;
  final int userId;
  final int productId;
  final int quantity;
  final double price;
  final DateTime createdAt;

  CartItemDto({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.price,
    required this.createdAt,
  });

  factory CartItemDto.fromRow(ResultRow row) {
    return CartItemDto(
      id: row[0] as int,
      userId: row[1] as int,
      productId: row[2] as int,
      quantity: row[3] as int,
      price: double.parse(row[4] as String),
      createdAt: row[5] as DateTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'quantity': quantity,
      'price': price,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
