import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'login_util.dart'; 

import '../pages/login/login.page.dart';
import '../pages/login/admin_dashboard.page.dart';
import '../pages/login/client_dashboard.page.dart';
import '../common_components/client_bar.component.dart'; 
import '../common_components/admin_bar.component.dart';

class LoginRoutes {
  final AuthService authService; 
  GoRouter? _router;

  LoginRoutes(this.authService);

  GoRouter get router {
    _router ??= GoRouter(
      debugLogDiagnostics: true,
      refreshListenable: authService,
      // O ponto de entrada agora é /dashboard
      // Mas o redirect vai cuidar de quem não está logado
      initialLocation: '/dashboard', 

      // Lógica de redirect
      redirect: (BuildContext context, GoRouterState state) {
        final isLoggedIn = authService.isLoggedIn;
        final role = authService.role;
        final goingTo = state.matchedLocation;

        if (!isLoggedIn) {
          return (goingTo == '/login') ? null : '/login';
        }

        // Se logado e tentando ir para /login, manda para
        // /admin ou /dashboard
        if (goingTo == '/login' && isLoggedIn) {
          return (role == UserRole.admin) ? '/admin' : '/dashboard';
        }

        // Se for usuário comum tentando acessar /admin,
        // manda para /dashboard
        if (role == UserRole.user && goingTo.startsWith('/admin')) {
          return '/dashboard';
        }
        
        // Se for usuário comum e tentar ir para a rota
        // raiz '/', manda para /dashboard
        if (role == UserRole.user && goingTo == '/') {
          return '/dashboard';
        }

        // Se for admin e tentar ir para a rota raiz '/',
        // manda para /admin
        if (role == UserRole.admin && goingTo == '/') {
          return '/admin';
        }

        return null;
      },

      // Lista de rotas
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),

        // Rotas de Usuário (Cliente) ATUALIZADO
        ShellRoute(
          builder: (context, state, child) => ClientBarComponent(child: child),
          routes: [
            GoRoute(
              //A rota principal do cliente é /dashboard
              path: '/dashboard', 
              builder: (context, state) => const ClientDashboardPage(),
              routes: [
                // ex: /dashboard/profile
              ],
            ),
          ],
        ),

        // Rotas de Administrador /admin
        ShellRoute(
          builder: (context, state, child) => AdminBarComponent(child: child),
          routes: [
            GoRoute(
              path: '/admin',
              builder: (context, state) => const AdminDashboardPage(),
              routes: [
                // ex: /admin/users
              ],
            ),
          ],
        ),
      ],
    );
    return _router!;
  }
}