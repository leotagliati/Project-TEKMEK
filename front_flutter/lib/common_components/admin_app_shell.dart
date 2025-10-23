import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../auth_service.dart';

class AdminAppShell extends StatelessWidget {
  final Widget child;
  const AdminAppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tekmek - ADMIN'),
        backgroundColor: Colors.red[100],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Chama o logout do AuthService
              context.read<AuthService>().logout();
            },
          )
        ],
      ),
      body: child,
      // Você pode adicionar um NavigationRail/Menu lateral de admin aqui
    );
  }
}