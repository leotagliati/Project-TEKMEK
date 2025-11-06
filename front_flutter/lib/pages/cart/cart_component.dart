import 'package:flutter/material.dart';
import 'package:front_flutter/api/services.dart';
import 'package:front_flutter/models/cart_item.dart';
import 'package:front_flutter/pages/cart/cart_product_component.dart';
import 'package:intl/intl.dart';

class CartComponent extends StatefulWidget {
  const CartComponent({super.key});

  @override
  State<CartComponent> createState() => _CartComponentState();
}

class _CartComponentState extends State<CartComponent> {
  CartService cartService = CartService();

  double subtotal = 0;
  var currency = NumberFormat('#,##0.00', 'pt_BR');

  List<CartItem> products = [];

  @override
  void initState() {
    super.initState();
    _loadUserCartItens();
    _calculateSubtotal();
  }

  void _loadUserCartItens() async {
    final List<dynamic> data = await cartService.getUserItems(
      '1',
    ); // usuario chumbado, preciso do servico de login
    try {
      final List<CartItem> cartItemList = data
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        products = cartItemList;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar itens do carrinho'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      print('Erro ao carregar itens do carrinho: $e');
    }
  }

  Future<void> _checkoutCart() async {
    try {
      final Map<String, dynamic> body = {'userId': 1};
      await cartService.checkoutItems(body);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao finalizar carrinho'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
        ),
      );
      print('Erro ao finalizar carrinho: $e');
    }
  }

  void _calculateSubtotal() {
    subtotal = products.fold(
      0,
      (sum, product) => sum + (product.price * product.amount),
    );
  }

  void _removeProduct(CartItem product) {
    setState(() {
      products.remove(product);
      _calculateSubtotal();
    });
  }

  void _updateAmount(CartItem product, int newAmount) {
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
          cartItem: product,
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
                      onPressed: () {
                        // jogar na rota da pagina de pedidos CODE:01
                        _checkoutCart();
                      },
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
