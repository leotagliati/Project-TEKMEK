import 'package:cart_service/models/cart_item.dart';
import 'package:postgres/postgres.dart';

class CartRepository {
  final Connection conn;

  CartRepository(this.conn);

  Future<List<CartItemDto>> getCartByUser(int userId) async {
    final result = await conn.execute(
      Sql.named('SELECT * FROM carts_tb WHERE user_id = @userId'),
      parameters: {'userId': userId},
    );
    return result.map((row) => CartItemDto.fromRow(row)).toList();
  }

  Future<List<Map<String, dynamic>>> getCartProductsByUser(int userId) async {
    final result = await conn.execute(
      Sql.named('''
      SELECT 
        c.product_id,
        c.quantity,
        p.name,
        p.price,
        p.image_url
      FROM carts_tb c
      JOIN cart_products_tb p ON c.product_id = p.id
      WHERE c.user_id = @userId
    '''),
      parameters: {'userId': userId},
    );

    return result
        .map((row) => {
              'product_id': row[0],
              'quantity': row[1],
              'name': row[2],
              'price': row[3],
              'image_url': row[4],
            })
        .toList();
  }

  Future<void> addItem(
      int userId, int productId, int quantity, double price) async {
    final result = await conn.execute(
      Sql.named('''
      SELECT quantity FROM carts_tb
      WHERE user_id = @userId AND product_id = @productId
    '''),
      parameters: {'userId': userId, 'productId': productId},
    );

    if (result.isNotEmpty) {
      await conn.execute(
        Sql.named('''
        UPDATE carts_tb
        SET quantity = quantity + @quantity
        WHERE user_id = @userId AND product_id = @productId
      '''),
        parameters: {
          'userId': userId,
          'productId': productId,
          'quantity': quantity,
        },
      );
    } else {
      await conn.execute(
        Sql.named('''
        INSERT INTO carts_tb (user_id, product_id, quantity, price)
        VALUES (@userId, @productId, @quantity, @price)
      '''),
        parameters: {
          'userId': userId,
          'productId': productId,
          'quantity': quantity,
          'price': price,
        },
      );
    }
  }

  Future<void> updateItem(
      int userId, int productId, double newPrice, int quantity) async {
    await conn.execute(
      Sql.named('''
      UPDATE carts_tb
        SET quantity = @newQuantity,
            price = @newPrice
        WHERE user_id = @userId AND product_id = @productId
      '''),
      parameters: {
        'userId': userId,
        'productId': productId,
        'newPrice': newPrice,
        'newQuantity': quantity,
      },
    );
  }

  Future<void> deleteItem(int userId, int productId) async {
    await conn.execute(
      Sql.named(
          'DELETE FROM carts_tb WHERE user_id = @userId AND product_id = @productId'),
      parameters: {'userId': userId, 'productId': productId},
    );
  }

  Future<void> clearCart(int userId) async {
    await conn.execute(
      Sql.named('DELETE FROM carts_tb WHERE user_id = @userId'),
      parameters: {'userId': userId},
    );
  }
}
