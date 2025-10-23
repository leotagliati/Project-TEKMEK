import 'package:flutter/material.dart';
import 'package:front_flutter/pages/home/home_page.dart';
import 'package:front_flutter/pages/product/product_page.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  App({super.key});

  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => HomePage()),
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
          return ProductPage(productId: int.parse(state.pathParameters['id']!));
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "Tekmek",
      theme: ThemeData(
        textTheme: GoogleFonts.interTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 255, 255, 255),
        ),
      ),
      routerConfig: _router,
    );
  }
}
