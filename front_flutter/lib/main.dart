// lib/main.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// Importe o utilitário que contém o AuthService
import 'utils/login_util.dart'; 
import 'utils/routes_util.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      // O AuthService vem do login_util.dart
      create: (context) => AuthService(),
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AuthService _authService;
  late final LoginRoutes _appRoutes;

  @override
  void initState() {
    super.initState();
    // Pega o AuthService que o Provider criou
    _authService = context.read<AuthService>();
    //Cria a classe de rotas, passando o AuthService
    _appRoutes = LoginRoutes(_authService);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // Usa o router do routes_util.dart
      routerConfig: _appRoutes.router, 
      
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