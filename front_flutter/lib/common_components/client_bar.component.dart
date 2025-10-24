import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/login_util.dart'; // Importa seu AuthService

class ClientBarComponent extends StatelessWidget {
  final Widget child;
  const ClientBarComponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tekmek'),
        backgroundColor: Colors.blue[700],
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
      // A página (ClientDashboardPage) é inserida aqui
      body: child, 
    );
  }
}