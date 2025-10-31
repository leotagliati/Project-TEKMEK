import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';

void main() async {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  final conn = await Connection.open(
    Endpoint(
      host: env['DB_HOST'] ?? 'localhost',
      database: env['DB_NAME'] ?? 'products_db',
      username: env['DB_USER'],
      password: env['DB_PASSWORD'],
    ),
    settings: ConnectionSettings(sslMode: SslMode.disable),
  );
  print('Conectado ao PostgreSQL com sucesso');

  final router = Router();

  router.get('/api/checkout', (Request req) async {
    final userId = req.url.queryParameters['userId'];

    try {
      final result = await conn.execute(
          Sql.named('SELECT * FROM carts_tb WHERE carts_tb.user_id = @userId'),
          parameters: {'userId': userId});
      final items = result.map((row) => CartItemDto.fromRow(row)).toList();

      return Response.ok(jsonEncode(items.map((i) => i.toJson()).toList()),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response(500,
          body: jsonEncode({'error': 'Erro ao buscar carrinho: $e'}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  final handler =
      const Pipeline().addHandler(router);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 5245);
  print('Servidor rodando na porta ${server.port}');
}

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
