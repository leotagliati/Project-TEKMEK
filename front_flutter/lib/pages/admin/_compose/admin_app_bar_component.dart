import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminAppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text("TEKMEK - ADMIN"),
      backgroundColor: Colors.indigo[900], // A distinct admin color
      foregroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
      actions: [
        // Button to go to the public Homepage
        IconButton(
          icon: const Icon(Icons.home),
          tooltip: 'Ver Loja',
          onPressed: () => context.go('/'),
        ),
        // Button to go to the Admin Dashboard
        IconButton(
          icon: const Icon(Icons.admin_panel_settings),
          tooltip: 'Admin Home',
          onPressed: () => context.go('/admin'),
        ),
        
        // You can add a logout button here later
        IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Sair',
          onPressed: () {
            // TODO: Call AuthService.logout()
            context.go('/login');
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
