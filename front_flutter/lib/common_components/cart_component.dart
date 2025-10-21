import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/cart_product_component.dart';
import 'package:intl/intl.dart';

class CartComponent extends StatefulWidget {
  const CartComponent({super.key});

  @override
  State<CartComponent> createState() => _CartComponentState();
}

class _CartComponentState extends State<CartComponent> {
  double subtotal = 0;
  var currency = NumberFormat('#,##0.00', 'pt_BR');

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Scaffold.of(context).closeEndDrawer(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Meu carrinho ({qtd})",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Container(color: Colors.grey[400], height: 2),
                    CartProductComponent(
                      productName: 'Keychron K3 Max',
                      productType: 'Teclado',
                      imagePath: 'assets/images/keyboard.png',
                      price: 499.99,
                    ),
                    Column(
                      children: List<Widget>.generate(6, (int index) {
                        return CartProductComponent(
                          productName: 'Keychron K3 Max',
                          productType: 'Teclado',
                          imagePath: 'assets/images/keyboard.png',
                          price: 499.99,
                        );
                      }),
                    ),
                    Container(color: Colors.grey[400], height: 2),
                    Row(
                      children: [
                        Expanded(child: Text('Subtotal')),
                        Text('R\$${currency.format(subtotal)}'),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 65, 72, 74),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Finalizar pedido",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
