import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
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
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.local_mall),
            title: Text("Meus pedidos"),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Minha conta"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
