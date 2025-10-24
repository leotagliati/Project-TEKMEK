import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Este vai dentro do AdminBarComponent.
    // Também não precisa de Scaffold.
    return const Center(
      child: Text(
        'Dashboard do Administrador',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}