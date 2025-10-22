import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter/pages/cart/cart_product.dart';
import 'package:front_flutter/pages/cart/cart_product_component.dart';
import 'package:intl/intl.dart';

class CartComponent extends StatefulWidget {
  const CartComponent({super.key});

  @override
  State<CartComponent> createState() => _CartComponentState();
}

class _CartComponentState extends State<CartComponent> {
  double subtotal = 0;
  var currency = NumberFormat('#,##0.00', 'pt_BR');

  List<CartProduct> products = [];

  @override
  void initState() {
    super.initState();
    _loadDataFromJson();
    _calculateSubtotal();
  }

  // Temporário
  void _loadDataFromJson() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'assets/data/products.json',
      );
      final List<dynamic> parsedList = jsonDecode(jsonString);
      final List<CartProduct> items = parsedList
          .map((item) => CartProduct.fromJson(item as Map<String, dynamic>))
          .toList();
      setState(() {
        products = items;
        _calculateSubtotal();
      });
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao carregar o data.json: $e');
    }
  }

  void _calculateSubtotal() {
    subtotal = products.fold(
      0,
      (sum, product) => sum + (product.price * product.amount),
    );
  }

  void _removeProduct(CartProduct product) {
    setState(() {
      products.remove(product);
      _calculateSubtotal();
    });
  }

  void _updateAmount(CartProduct product, int newAmount) {
    setState(() {
      if (newAmount > 0) {
        product.amount = newAmount;
        _calculateSubtotal();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> productComponents = [];
    for (var product in products) {
      productComponents.add(
        CartProductComponent(
          product: product,
          onDelete: () => _removeProduct(product),
          onAmountChanged: (newAmount) => _updateAmount(product, newAmount),
        ),
      );
    }

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
                          "Meu carrinho (${products.length})",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Container(color: Colors.grey[400], height: 2),
                    Column(
                      spacing: 16,
                      children: products.isNotEmpty
                          ? productComponents
                          : [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [Text('O carrinho está vazio.')],
                              ),
                            ],
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
