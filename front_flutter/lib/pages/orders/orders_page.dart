import 'package:flutter/material.dart';
import 'package:front_flutter/api/services.dart';
import 'package:front_flutter/common_components/app_bar_component.dart';
import 'package:front_flutter/common_components/navigation_menu.dart';
import 'package:front_flutter/pages/cart/cart_component.dart';
import 'package:front_flutter/pages/orders/_compose/order_component.dart';
import 'package:front_flutter/models/order.dart';
import 'package:front_flutter/utils/auth_provider.dart';
import 'package:provider/provider.dart';
class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final OrdersService ordersService = OrdersService();
  List<Order> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }
  int? _getUserId(BuildContext context) {
    return context.read<AuthProvider>().user?['idlogin'];
  }



  Future<void> _loadOrders() async {
    try {
      final userId = _getUserId(context);
      if (userId == null) return;

      final List<dynamic> data = await ordersService.getUserItems(userId);
      
      final List<Order> ordersList = data.reversed
          .map((item) => Order.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        orders = ordersList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao carregar pedidos.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      print('Erro ao carregar pedidos: $e');
    }
  }

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
                constraints: const BoxConstraints(maxWidth: 960),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 32,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    spacing: 16,
                    children: [
                      const Row(
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
                      if (orders.isEmpty)
                        const Text('Nenhum pedido encontrado.'),
                      for (final order in orders) OrderComponent(order: order),
                      const SizedBox(height: 128),
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
