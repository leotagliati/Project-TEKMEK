// lib/config/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:front_flutter/pages/home/home_page.dart';
import 'package:front_flutter/pages/product/product_page.dart';
import 'package:go_router/go_router.dart';
import '../pages/login/login_page.dart';

class AppRouter {

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(), 
      ),
      GoRoute(
        path: '/product/:id',
        redirect: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null || int.tryParse(id) == null) {
            return '/';
          }
          return null;
        },
        builder: (context, state) {
          // A validação do redirect garante que 'id' não é nulo
          final productId = int.parse(state.pathParameters['id']!);
          return ProductPage(productId: productId);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Adicione suas outras rotas aqui (ex: /login, /profile, /cart)
    ],

    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Página Não Encontrada')),
      body: Center(
        child: Text('Erro: ${state.error?.message ?? 'Rota não existe'}'),
      ),
    ),
  );
}