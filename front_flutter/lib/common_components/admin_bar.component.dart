import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/login_util.dart'; // Importa seu AuthService

class AdminBarComponent extends StatelessWidget {
  final Widget child;
  const AdminBarComponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Administrador'),
        backgroundColor: Colors.red[700], // Cor diferente para admin
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: () {
              // Chama o logout do AuthService
              context.read<AuthService>().logout();
            },
          ),
        ],
      ),
      // A mágica do ShellRoute:
      // A página (AdminDashboardPage) é inserida aqui
      body: child,
    );
  }
}