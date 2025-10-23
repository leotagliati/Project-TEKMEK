import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/app_bar_component.dart';
import 'package:front_flutter/common_components/navigation_menu.dart';
import 'package:front_flutter/pages/cart/cart_component.dart';

class ProductPage extends StatelessWidget {
  final int productId;

  const ProductPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationMenu(),
      endDrawer: CartComponent(),
      appBar: AppBarComponent(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [Image.network('https://images.pexels.com/photos/13094372/pexels-photo-13094372.jpeg')],
          ),
        ),
      ),
    );
  }
}
