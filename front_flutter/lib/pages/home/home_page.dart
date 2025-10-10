import 'package:flexible_wrap/flexible_wrap.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/app_bar_component.dart';
import 'package:front_flutter/common_components/drawer_menu.dart';
import 'package:front_flutter/pages/home/_compose/filters_button.dart';
import 'package:front_flutter/pages/home/_compose/product_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBarComponent(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              SizedBox(height: 24),
              HomeFiltersComponent(),
              SizedBox(height: 24),
              FlexibleWrap(
                isOneRowExpanded: true,
                spacing: 16,
                runSpacing: 16,
                children: [
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                  ProductComponent(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
