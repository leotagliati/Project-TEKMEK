import 'package:carousel_slider/carousel_slider.dart';
import 'package:flexible_wrap/flexible_wrap.dart';
import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/app_bar_component.dart';
import 'package:front_flutter/common_components/cart_component.dart';
import 'package:front_flutter/common_components/drawer_menu.dart';
import 'package:front_flutter/pages/home/_compose/banner_component.dart';
import 'package:front_flutter/pages/home/_compose/filters_button.dart';
import 'package:front_flutter/pages/home/_compose/product_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final carouselController = CarouselSliderController();
  int current = 0;

  final List<Widget> banners = [
    BannerComponent(
      imageUrl:
          "https://images.pexels.com/photos/13094372/pexels-photo-13094372.jpeg",
      title: "Nome do teclado 1",
      description: "Descrição 1",
    ),
    BannerComponent(
      imageUrl:
          "https://images.pexels.com/photos/17479950/pexels-photo-17479950.jpeg",
      title: "Nome do teclado 2",
      description: "Descrição 2",
    ),
    BannerComponent(
      imageUrl:
          "https://images.pexels.com/photos/6782533/pexels-photo-6782533.jpeg",
      title: "Nome do teclado 3",
      description: "Descrição 3",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      endDrawer: CartComponent(),
      appBar: AppBarComponent(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Stack(
                fit: StackFit.loose,
                children: [
                  CarouselSlider(
                    items: banners,
                    carouselController: carouselController,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.width < 600
                          ? 200
                          : 320,
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
              SizedBox(height: 20),
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
                children: List<Widget>.generate(16, (int index) {
                  return ProductComponent(
                    imagePath: "assets/images/keyboard.png",
                    title: "Nome do teclado",
                    description: "R\$999,99",
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
