import 'dart:io';
import 'package:cart_service/config/database.dart';
import 'package:cart_service/controllers/cart_controller.dart';
import 'package:cart_service/repositories/cart_repo.dart';
import 'package:cart_service/routes/cart_routes.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

void main() async {
  final conn = await Database.connect();
  final repository = CartRepository(conn);
  final controller = CartController(repository);

  final router = cartRoutes(controller);

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(router);

  final server = await io.serve(handler, InternetAddress.anyIPv4, 5245);
  print('--------------------------------------------');
  print('Servidor rodando na porta ${server.port}');
  print('--------------------------------------------');
}
