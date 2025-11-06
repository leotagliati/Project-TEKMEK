import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:front_flutter/utils/auth_provider.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bool isLoggedIn = authProvider.isLoggedIn;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.all(8),
            child: Image.asset(
              'assets/images/tekmek-logo-clear.png',
              fit: BoxFit.contain,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Início"),

            onTap: () {
              Navigator.pop(context);
              context.go('/');
            },
          ),
          if (isLoggedIn) ...[
            ListTile(
              leading: Icon(Icons.local_mall),
              title: Text("Meus pedidos"),
              onTap: () {
                Navigator.pop(context);
                context.go('/meus-pedidos');
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () async {
                Navigator.pop(context);
                await authProvider.logout();
                context.go('/');
              },
            ),
          ] else ...[
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text("Login"),
              onTap: () {
                if (authProvider.isLoggedIn) {
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text("Já Autenticado"),
                      content: Text("Você já está logado no sistema."),
                      actions: [
                        TextButton(
                          child: Text("Fechar"),
                          onPressed: () {
                            Navigator.pop(dialogContext);
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  Navigator.pop(context);
                  context.go('/login');
                }
              },
            ),
          ],
       
        
        ],
      ),
    );
  }
}