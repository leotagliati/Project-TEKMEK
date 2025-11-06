import 'package:flutter/material.dart';
import 'package:front_flutter/pages/home/home_page.dart';
import 'package:front_flutter/pages/product/product_page.dart';
import 'package:go_router/go_router.dart';
import '../pages/login/login_page.dart';
import '../pages/admin/admin_page.dart';
import 'package:front_flutter/pages/orders/orders_page.dart'; // <-- MUDANÇA: Importar a página de pedidos
import 'package:front_flutter/utils/auth_provider.dart'; 

class AppRouter {
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      refreshListenable: authProvider,
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
            final productId = int.parse(state.pathParameters['id']!);
            return ProductPage(productId: productId);
          },
        ),
        
        // --- MUDANÇA: Rota de Pedidos Adicionada ---
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrdersPage(),
          redirect: (context, state) {
            // Protege a rota, assim como o menu faz
            if (!authProvider.isLoggedIn) return '/login';
            return null;
          },
        ),
        // --- FIM DA MUDANÇA ---

        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminPage(),
          redirect: (context, state) {
            if (!authProvider.isLoggedIn) return '/login'; // Não logado
            if (!authProvider.isAdmin) return '/'; // Logado mas não é admin
            return null; // Ok
          },
        ),
      ],
      redirect: (context, state) {
        final isLoggedIn = authProvider.isLoggedIn;

        if (state.matchedLocation == '/login' && isLoggedIn) {
          return '/';
        }
        return null;
      },
      errorBuilder: (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Página Não Encontrada')),
        body: Center(
          child: Text('Erro: ${state.error?.message ?? 'Rota não existe'}'),
        ),
      ),
    );
  }
}