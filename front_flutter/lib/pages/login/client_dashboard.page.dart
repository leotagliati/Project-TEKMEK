import 'package:flutter/material.dart';

class ClientDashboardPage extends StatelessWidget {
  const ClientDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Adicionado um Container com cor de fundo para teste
    return Container(
      color: Colors.amber[100], // Cor de fundo para garantir que o body está aqui
      child: const Center(
        child: Text(
          'Dashboard do Cliente (TESTE)',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black, // Cor explícita para garantir a visibilidade
          ),
        ),
      ),
    );
  }
}