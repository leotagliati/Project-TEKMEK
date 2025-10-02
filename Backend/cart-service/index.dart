import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:http/http.dart' as http;

void main() async {
  final router = Router();

  router.post('/checkout', (req) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);
    final userId = data['userId'];
    final items = data['items'];

    if (userId == null || items == null || items is! List || items.isEmpty) {
      return Response(400, body: jsonEncode({'message': 'Dados incompletos.'}));
    }

    final event = {'type': 'CartCheckoutInitiated', 'data': {'userId': userId, 'items': items}};
    await http.post(Uri.parse('http://localhost:5300/event'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(event));

    return Response.ok(jsonEncode({'message': 'Checkout iniciado.'}));
  });

  router.post('/event', (req) async {
    final body = await req.readAsString();
    if (body.isNotEmpty) {
      final event = jsonDecode(body);
      if (event['type'] == 'OrderCreated') {
        final d = event['data'];
        print('Pedido ${d['orderId']} criado para ${d['userId']}.');
      }
    }
    return Response.ok('');
  });

  const port = 5316;
  final server = await io.serve(router, InternetAddress.anyIPv4, port);
  print('--------------------------------------------');
  print('Cart Service escutando na porta ${server.port}');
  print('--------------------------------------------');
}