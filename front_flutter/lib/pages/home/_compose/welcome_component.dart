import 'package:flutter/material.dart';
import 'package:front_flutter/utils/auth_provider.dart';
import 'package:provider/provider.dart';

class WelcomeComponent extends StatelessWidget {
  const WelcomeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return LayoutBuilder(
      builder: (context, constraints) {
        if (authProvider.isLoggedIn) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(Icons.account_circle, size: 36),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Seja bem vindo, ${authProvider.user?['username'] ?? 'usuário'}!",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
