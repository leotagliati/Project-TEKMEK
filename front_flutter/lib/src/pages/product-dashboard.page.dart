import 'package:flutter/material.dart';
import 'package:front_flutter/src/_compose/top-navigation-bar.dart';

class ProductDashboardPage extends StatelessWidget {
  const ProductDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [SizedBox(width: 600, child: TopNavigationBar())]),
    );
  }
}
