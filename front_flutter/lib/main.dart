// lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// Imports corrigidos baseados na sua estrutura
import '/auth_service.dart';
import 'pages/login/login.page.dart';
import 'pages/home/dashboard_screen.dart';
import 'pages/admin/admin_dashboard_screen.dart';
import 'common_components/user_app_shell.dart';
import 'common_components/admin_app_shell.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthService(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    final _router = GoRouter(
      refreshListenable: authService,
      
      redirect: (BuildContext context, GoRouterState state) {
        final isLoggedIn = authService.isLoggedIn;
        final role = authService.role;
        final goingTo = state.matchedLocation;

        if (!isLoggedIn) {
          return (goingTo == '/login') ? null : '/login';
        }

        if (goingTo == '/login' && isLoggedIn) {
           return (role == UserRole.admin) ? '/admin' : '/';
        }
        
        if (role == UserRole.user && goingTo.startsWith('/admin')) {
          return '/';
        }
        
         if (role == UserRole.admin && goingTo == '/') {
          return '/admin';
        }

        return null;
      },
      
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),

        ShellRoute(
          builder: (context, state, child) => UserAppShell(child: child),
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),

        ShellRoute(
          builder: (context, state, child) => AdminAppShell(child: child),
          routes: [
            GoRoute(
              path: '/admin',
              builder: (context, state) => const AdminDashboardScreen(),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      title: "Tekmek",
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
    );
  }
}