import 'dart:convert';
import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

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

  // GET carrinho por userid
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

  // GET produtos do carrinho por userid
  router.get('/api/checkout/products', (Request req) async {
    final userId = req.url.queryParameters['userId'];

    if (userId == null || userId.isEmpty) {
      return Response(400,
          body: jsonEncode({'error': ' userId é obrigatório'}),
          headers: {'Content-Type': 'application/json'});
    }

    try {
      final result = await conn.execute(
        Sql.named('''
        SELECT 
          c.id,
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

      final items = result
          .map((row) => {
                'product_id': row[0],
                'quantity': row[1],
                'name': row[2],
                'price': row[3],
                'image_url': row[4],
              })
          .toList();

      return Response.ok(
        jsonEncode(items),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      print('Erro ao buscar produtos do carrinho: $e');
      return Response(
        500,
        body: jsonEncode({'error': 'Erro ao buscar produtos do carrinho: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // POST item carrinho
  router.post('/api/checkout', (Request req) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);

    final userId = data['userId'];
    final productId = data['productId'];
    final quantity = data['quantity'] ?? 1;
    final price = data['price'];

    if (userId == null || productId == null || price == null) {
      return Response(400,
          body: jsonEncode(
              {'error': 'userId, productId e price são obrigatórios'}),
          headers: {'Content-Type': 'application/json'});
    }

    try {
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

      return Response.ok(jsonEncode({'message': 'Item adicionado ao carrinho'}),
          headers: {'Content-Type': 'application/json'});
    } catch (e) {
      return Response(500,
          body: jsonEncode({'error': 'Erro ao adicionar item: $e'}),
          headers: {'Content-Type': 'application/json'});
    }
  });

  // DELETE item carrinho
  router.delete('/api/checkout', (Request req) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);

    final userId = data['userId'];
    final productId = data['productId'];

    if (userId == null || productId == null) {
      return Response(400,
          body: jsonEncode({'error': 'userId e productId são obrigatórios'}),
          headers: {'Content-Type': 'application/json'});
    }

    try {
      var result = await conn.execute(
        Sql.named('''
        DELETE FROM carts_tb WHERE user_id = @userId AND product_id = @productId RETURNING id
        '''),
        parameters: {
          'userId': userId,
          'productId': productId,
        },
      );
      if (!result.isEmpty)
        return Response.ok(jsonEncode({'message': 'Item removido do carrinho'}),
            headers: {'Content-Type': 'application/json'});
      else {
        return Response.ok(jsonEncode({'message': 'Item não encontrado'}),
            headers: {'Content-Type': 'application/json'});
      }
    } catch (e) {
      return Response(500,
          body: jsonEncode({'error': 'Erro ao remover item: $e'}),
          headers: {'Content-Type': 'application/json'});
    }
  });

// PUT item carrinho
  router.put('/api/checkout', (Request req) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);

    final userId = data['userId'];
    final productId = data['productId'];
    final newQuantity = data['quantity'];

    if (userId == null || productId == null || newQuantity == null) {
      return Response(
        400,
        body: jsonEncode({'error': 'userId, productId e quantity inválidos'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    try {
      final result = await conn.execute(
        Sql.named('''
        UPDATE carts_tb
        SET quantity = @newQuantity
        WHERE user_id = @userId AND product_id = @productId
        RETURNING id
      '''),
        parameters: {
          'newQuantity': newQuantity,
          'userId': userId,
          'productId': productId,
        },
      );

      if (result.isEmpty) {
        return Response.ok(
          jsonEncode({'message': 'Item não encontrado no carrinho'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      return Response.ok(
        jsonEncode({'message': 'Quantidade atualizada com sucesso'}),
        headers: {'Content-Type': 'application/json'},
      );
    } catch (e) {
      return Response(
        500,
        body: jsonEncode({'error': 'Erro ao atualizar quantidade: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  // POST evento checkout para barramento
  router.post('/event', (Request req) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);

    final userId = data['userId'];
    if (userId == null) {
      return Response(
        400,
        body: jsonEncode({'error': 'userId é obrigatório'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    try {
      // Busca os itens do carrinho do usuário
      final result = await conn.execute(
        Sql.named('SELECT * FROM carts_tb WHERE user_id = @userId'),
        parameters: {'userId': userId},
      );

      if (result.isEmpty) {
        return Response(
          404,
          body: jsonEncode({'error': 'Carrinho vazio ou não encontrado'}),
          headers: {'Content-Type': 'application/json'},
        );
      }

      // Monta a lista de itens
      final items = result.map((row) {
        return {
          'productId': row[2], // product_id
          'quantity': row[3], // quantity
          'price': double.parse(row[4].toString()), // price
        };
      }).toList();

      // Monta o evento
      final event = {
        'type': 'CartCheckoutInitiated',
        'data': {
          'userId': userId,
          'items': items,
        },
      };

      final eventBusUrl = env['EVENT_BUS_URL'] ?? 'http://localhost:5300/event';

      final httpClient = HttpClient();
      final request = await httpClient.postUrl(Uri.parse(eventBusUrl));
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(event));
      final response = await request.close();

      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        print('Evento enviado ao Barramento com sucesso.');
        return Response.ok(
          responseBody,
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        print('Falha ao enviar evento: $responseBody');
        return Response.internalServerError(
          body: jsonEncode({
            'error': 'Falha ao enviar evento para o Order Service',
            'response': responseBody
          }),
          headers: {'Content-Type': 'application/json'},
        );
      }
    } catch (e) {
      print('Erro ao enviar evento: $e');
      return Response(
        500,
        body: jsonEncode({'error': 'Erro ao processar evento: $e'}),
        headers: {'Content-Type': 'application/json'},
      );
    }
  });

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router);
  ;

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
