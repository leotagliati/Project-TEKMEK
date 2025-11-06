import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front_flutter/api/services.dart';
import 'package:front_flutter/models/cart_item.dart';
import 'package:front_flutter/models/product.dart';
import 'package:front_flutter/pages/cart/cart_product_component.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:front_flutter/utils/auth_provider.dart';
import 'package:go_router/go_router.dart';

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
  bool _isLoading = true;
  bool _isInit = true;

  late AuthProvider authProvider;
  int? get _userId => authProvider.user?['idlogin'];

  @override
  void didChangeDependencies() {
    if (_isInit) {
      authProvider = Provider.of<AuthProvider>(context);
      if (authProvider.isLoggedIn && _userId != null) {
        _loadUserCartItens(_userId.toString());
      } else {
        setState(() {
          _isLoading = false;
          products = [];
        });
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _loadUserCartItens(String userId) async {
    if (!mounted) return;
    setState(() { _isLoading = true; });

    try {
      final List<dynamic> data = await cartService.getUserItems(userId);
      if (!mounted) return;

      final List<CartItem> cartItemList = data
          .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        products = cartItemList;
        _calculateSubtotal();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar itens do carrinho'),
          backgroundColor: Colors.redAccent,
        ),
      );
      print('Erro ao carregar itens do carrinho: $e');
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _checkoutCart() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Você precisa estar logado para finalizar o pedido.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      final Map<String, dynamic> body = {'userId': _userId};
      await cartService.checkoutItems(body);

      setState(() {
        products = [];
        _calculateSubtotal();
      });
      if (mounted) {
        Scaffold.of(context).closeEndDrawer();
        context.go('/orders');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao finalizar carrinho'),
          backgroundColor: Colors.redAccent,
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
      } else {
        products.remove(product);
        _calculateSubtotal();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isLoading) {
      return Drawer(child: Center(child: CircularProgressIndicator()));
    }

    if (!auth.isLoading && (auth.isLoggedIn != (authProvider.user != null))) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() { _isInit = true; });
      });
    }

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
                    _isLoading
                        ? Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : !auth.isLoggedIn
                            ? Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('Faça login para ver seu carrinho.')
                                  ],
                                ),
                              )
                            : Column(
                                spacing: 16,
                                children: products.isNotEmpty
                                    ? productComponents
                                    : [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text('O carrinho está vazio.')
                                          ],
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
                      onPressed: (!auth.isLoggedIn || products.isEmpty)
                          ? null
                          : () {
                              _checkoutCart();
                            },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: (!auth.isLoggedIn || products.isEmpty)
                            ? Colors.grey[400]
                            : Color.fromARGB(255, 65, 72, 74),
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