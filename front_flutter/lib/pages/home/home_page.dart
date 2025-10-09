import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/app_bar_mobile.dart';
import 'package:front_flutter/pages/home/_compose/filters_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
      ),
      appBar: AppBarMobile(),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Seja bem vindo, {nome}!",
                    style: TextStyle(
                      fontSize: 20,
                      // fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
              HomeFiltersComponent(),
              Container(
                constraints: BoxConstraints(maxWidth: 1200, maxHeight: 800),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  // child: Column(
                  //   children: [
                  //     Expanded(child: Image.asset('assets/images/keyboard.png')),
                  //     Text("Nome do teclado"),
                  //     Text("Descrição"),
                  //   ],
                  // ),
                  child: Expanded(child: SizedBox()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
