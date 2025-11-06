import 'package:flutter/material.dart';
import 'package:front_flutter/pages/admin/_compose/admin_app_bar_component.dart';
import 'package:front_flutter/common_components/navigation_menu.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AdminAppBarComponent(), 
      drawer: const NavigationMenu(), 
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.admin_panel_settings, size: 80, color: Colors.indigo),
              SizedBox(height: 20),
              Text(
                'Painel do Administrador',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Esta é a página de administração',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}