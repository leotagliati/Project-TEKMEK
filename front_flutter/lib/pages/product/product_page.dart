import 'package:flutter/material.dart';
import 'package:front_flutter/api/services.dart';
import 'package:front_flutter/common_components/app_bar_component.dart';
import 'package:front_flutter/common_components/navigation_menu.dart';
import 'package:front_flutter/models/product.dart';
import 'package:front_flutter/pages/cart/cart_component.dart';
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

  final List<String> radioOptions = ['Cabo', 'Wireless'];
  String? _selectedOption;

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
    _selectedOption = radioOptions[0];
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

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
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 512),
                          child: Image.network(product.imageUrl),
                        ),
                        SizedBox(height: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(product.name, style: TextStyle(fontSize: 24)),
                            Row(
                              spacing: 4,
                              children: [
                                Icon(Icons.star_border),
                                Icon(Icons.star_border),
                                Icon(Icons.star_border),
                                Icon(Icons.star_border),
                                Icon(Icons.star_border),
                                Text('(0 avaliações)'),
                              ],
                            ),
                            Text(
                              'R\$${currency.format(product.price)}',
                              style: TextStyle(fontSize: 24),
                            ),
                            Container(color: Colors.grey[400], height: 2),
                            Text('Tipo'),
                            Row(
                              spacing: 8,
                              children: radioOptions.map((option) {
                                final bool isSelected =
                                    _selectedOption == option;
                                return OutlinedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedOption = option;
                                    });
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: isSelected
                                        ? Colors.black
                                        : Colors.grey,
                                    side: BorderSide(
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(128),
                                    ),
                                  ),
                                  child: Text(option),
                                );
                              }).toList(),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 40.0,
                              ),
                              child: Builder(
                                builder: (BuildContext innerContext) {
                                  return OutlinedButton(
                                    onPressed: () {
                                      _addCartItem(product).then((success) {
                                        if (success && mounted) {
                                          Scaffold.of(innerContext)
                                              .openEndDrawer();
                                        }
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Color.fromARGB(
                                        255,
                                        65,
                                        72,
                                        74,
                                      ),
                                      foregroundColor: Colors.white,
                                      side:
                                          BorderSide(color: Colors.transparent),
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
                                  );
                                },
                              ),
                            ),
                            Column(
                              children: [
                                Container(height: 1, color: Colors.grey[400]),
                                Theme(
                                  data: ThemeData().copyWith(
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: ExpansionTile(
                                    title: Text('Descrição'),
                                    leading: Icon(Icons.help),
                                    iconColor: Color.fromARGB(255, 65, 72, 74),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(product.description),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(height: 1, color: Colors.grey[400]),
                                Theme(
                                  data: ThemeData().copyWith(
                                    dividerColor: Colors.transparent,
                                  ),
                                  child: ExpansionTile(
                                    title: Text('Características'),
                                    leading: Icon(Icons.brush),
                                    iconColor: Color.fromARGB(255, 65, 72, 74),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Conectividade: ${product.connectivity} \nLayout: ${product.layoutSize} \nTipo de keycap: ${product.keycapType}',
                                              style: TextStyle(height: 1.5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 256),
                          ],
                        ),
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