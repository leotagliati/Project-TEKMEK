import 'package:flexible_wrap/flexible_wrap.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/app_bar_component.dart';
import 'package:front_flutter/common_components/search_component.dart';
import 'package:front_flutter/models/product.dart';
import 'package:front_flutter/pages/cart/cart_component.dart';
import 'package:front_flutter/common_components/navigation_menu.dart';
import 'package:front_flutter/pages/home/_compose/banner_component.dart';
import 'package:front_flutter/pages/home/_compose/filters_button.dart';
import 'package:front_flutter/pages/home/_compose/product_component.dart';
import 'package:front_flutter/api/services.dart';
import 'package:front_flutter/utils/auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductsService productsService = ProductsService();
  List<Product> products = [];

  Future<void> _loadProducts() async {
    try {
      final List<dynamic> data = await productsService.getProducts();

      final List<Product> productsList = data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        products = productsList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar produtos.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      print('Erro ao carregar produtos: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    List<Widget> productComponents = [];
    for (var product in products) {
      productComponents.add(ProductComponent(product: product));
    }

    return Scaffold(
      drawer: NavigationMenu(),
      endDrawer: CartComponent(),
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
                    authProvider.isLoggedIn
                        ? "Seja bem vindo, ${authProvider.user?['username'] ?? 'usuário'}!"
                        : "Seja bem vindo!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

                    // fontWeight: FontWeight.bold
                  ),
                ],
              ),
              SizedBox(height: 20),
              BannerComponent(),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Meus pedidos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SearchComponent(),
                ],
              ),
              SizedBox(height: 16),
              HomeFiltersComponent(),
              SizedBox(height: 24),
              FlexibleWrap(
                isOneRowExpanded: true,
                spacing: 16,
                runSpacing: 16,
                children: productComponents,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
