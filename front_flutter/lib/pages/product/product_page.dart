import 'package:flutter/material.dart';
import 'package:front_flutter/api/services.dart';
import 'package:front_flutter/common_components/app_bar_component.dart';
import 'package:front_flutter/common_components/navigation_menu.dart';
import 'package:front_flutter/models/product.dart';
import 'package:front_flutter/pages/cart/cart_component.dart';
import 'package:front_flutter/pages/product/_compose/product_display_component.dart';
import 'package:front_flutter/pages/product/_compose/product_specs_component.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:front_flutter/utils/auth_provider.dart';

class ProductPage extends StatefulWidget {
  final int productId;

  const ProductPage({super.key, required this.productId});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductsService productsService = ProductsService();
  CartService cartService = CartService();

  Future<bool> _addCartItem(Product product) async {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?['idlogin'];

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Você precisa estar logado para adicionar itens.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }

    try {
      final Map<String, dynamic> body = {
        'userId': userId,
        'productId': product.id,
        'quantity': 1,
        'price': product.price,
      };

      final response = await cartService.addItemToCart(body);
      print(response);
      return true;
    } catch (e) {
      print('Erro ao adicionar produto ao carrinho: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar produto: $e'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return false;
    }
  }

  var currency = NumberFormat('#,##0.00', 'pt_BR');
  late final Future<Product> _productFuture;

  Future<Product> _loadProduct(int id) async {
    try {
      final Product fetchedProduct = await productsService.getProductById(
        '$id',
      );
      return fetchedProduct;
    } catch (e) {
      print('Erro ao carregar produto pelo ID: $e');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _productFuture = _loadProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationMenu(),
      endDrawer: CartComponent(),
      appBar: AppBarComponent(),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          // Carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Erro
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          // Successo!
          if (snapshot.hasData) {
            final Product product = snapshot.data!;
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 960),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        ProductDisplayComponent(product: product),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48.0),
                          child: OutlinedButton(
                            onPressed: () {
                              _addCartItem(product).then((success) {
                                if (success && mounted) {
                                  Scaffold.of(context).openEndDrawer();
                                }
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 65, 72, 74),
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.transparent),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Text(
                                      "Adicionar ao carrinho",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ProductSpecsComponent(product: product),
                        SizedBox(height: 256),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('Iniciando...'));
        },
      ),
    );
  }
}
