import 'package:carousel_slider/carousel_slider.dart';
import 'package:flexible_wrap/flexible_wrap.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/app_bar_component.dart';
import 'package:front_flutter/models/product.dart';
import 'package:front_flutter/common_components/search_component.dart';
import 'package:front_flutter/pages/cart/cart_component.dart';
import 'package:front_flutter/common_components/navigation_menu.dart';
import 'package:front_flutter/pages/home/_compose/banner_component.dart';
import 'package:front_flutter/pages/home/_compose/filters_button.dart';
import 'package:front_flutter/pages/home/_compose/product_component.dart';
import 'package:front_flutter/api/services.dart';

import 'package:front_flutter/utils/auth_provider.dart';
import 'package:provider/provider.dart';


import 'package:front_flutter/utils/breakpoints.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final carouselController = CarouselSliderController();

  ProductsService productsService = ProductsService();

  int current = 0;
  List<Product> products = [];

  final List<Widget> banners = [
    BannerComponent(
      imageUrl:
          'https://images.pexels.com/photos/13094372/pexels-photo-13094372.jpeg',
      title: 'Seu setup, suas regras',
      description: 'Switches, keycaps e bases para um teclado único',
    ),
    BannerComponent(
      imageUrl:
          'https://images.pexels.com/photos/17479950/pexels-photo-17479950.jpeg',
      title: 'Monte. Modifique. Domine.',
      description: 'Liberdade total com teclados hot-swappable',
    ),
    BannerComponent(
      imageUrl:
          'https://images.pexels.com/photos/6782533/pexels-photo-6782533.jpeg',
      title: 'Design que Inspira',
      description: 'A peça central que faltava na sua mesa',
    ),
  ];

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
              Stack(
                fit: StackFit.loose,
                children: [
                  CarouselSlider(
                    items: banners,
                    carouselController: carouselController,
                    options: CarouselOptions(
                      height:
                          MediaQuery.of(context).size.width > breakpointMobile
                          ? 320
                          : MediaQuery.of(context).size.width > 460
                          ? 200
                          : 240,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 5),
                      autoPlayAnimationDuration: Duration(milliseconds: 1200),
                      enlargeCenterPage: true,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          current = current = index;
                        });
                      },
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: banners.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: () =>
                              carouselController.animateToPage(entry.key),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 4.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.black
                                          : Colors.white)
                                      .withOpacity(
                                        current == entry.key ? 0.9 : 0.4,
                                      ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [

                  //Text(
                  //  authProvider.isLoggedIn
                  //  ? "Seja bem vindo, ${authProvider.user?['username'] ?? 'usuário'}!"
                  //  : "Seja bem vindo!",
                  // style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      // fontWeight: FontWeight.bold

                  //),
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
