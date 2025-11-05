import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/app_bar_component.dart';
import 'package:front_flutter/common_components/navigation_menu.dart';
import 'package:front_flutter/pages/cart/cart_component.dart';
import 'package:front_flutter/pages/orders/_compose/order_component.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          appBar: AppBarComponent(),
          drawer: NavigationMenu(),
          endDrawer: CartComponent(),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 960),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    spacing: 16,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Meus pedidos',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      OrderComponent(),
                      OrderComponent(),
                      OrderComponent(),
                      OrderComponent(),
                      SizedBox(height: 192),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
