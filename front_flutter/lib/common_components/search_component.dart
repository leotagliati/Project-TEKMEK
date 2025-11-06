import 'package:flutter/material.dart';
import 'package:front_flutter/api/services.dart';
import 'package:front_flutter/common_components/product.dart';
import 'package:front_flutter/common_components/search_product_component.dart';
import 'package:go_router/go_router.dart';

class SearchComponent extends StatefulWidget {
  const SearchComponent({super.key});

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  final SearchController controller = SearchController();

  ProductsService productsService = ProductsService();
  List<Product> products = [];

  Future<void> _searchProducts(String term) async {
    final List<dynamic> data = await productsService.searchProducts(term);
    try {
      final List<Product> productsList = data
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();

      setState(() {
        products = productsList;
      });
    } catch (e) {
      print('Erro ao procurar produtos: $e');
    }
  }

  // Populando a lista de produtos de maneira fixa
  // A lista deve ser populada usando um SELECT *
  // E deve ser repopulada quando clicar no submit utilizando o input como termo de busca
  @override
  void initState() {
    super.initState();
    products = [];
    products.add(
      Product(
        id: 1,
        name: 'Keychron K3 Max',
        price: 499.99,
        imageUrl: 'https://i.imgur.com/1bBhl4O.png',
        description:
            'O K3 Max é um teclado mecânico sem fio discreto com layout de 75%. Ele suporta conexões de 2,4 GHz, Bluetooth e com fio. Com suporte ao QMK/VIA, oferece infinitas possibilidades e maior produtividade no seu trabalho e jogos!',
        layoutSize: '75%',
        connectivity: 'Wireless',
        productType: 'Teclado Mecânico',
        keycapType: 'Perfil Baixo (Low Profile) ABS',
      ),
    );
    products.add(
      Product(
        id: 1,
        name: 'Keychron K3 Max',
        price: 499.99,
        imageUrl: 'https://i.imgur.com/1bBhl4O.png',
        description:
            'O K3 Max é um teclado mecânico sem fio discreto com layout de 75%. Ele suporta conexões de 2,4 GHz, Bluetooth e com fio. Com suporte ao QMK/VIA, oferece infinitas possibilidades e maior produtividade no seu trabalho e jogos!',
        layoutSize: '75%',
        connectivity: 'Wireless',
        productType: 'Teclado Mecânico',
        keycapType: 'Perfil Baixo (Low Profile) ABS',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      isFullScreen: true,
      searchController: controller,
      viewLeading: IconButton(
        onPressed: () {
          controller.closeView(null);
        },
        icon: Icon(Icons.arrow_back),
        tooltip: 'Voltar',
      ),
      viewHintText: "Pesquise aqui...",
      viewTrailing: [
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.search),
          tooltip: 'Buscar',
        ),
        IconButton(
          onPressed: () {
            controller.clear();
          },
          icon: Icon(Icons.clear),
          tooltip: 'Limpar',
        ),
      ],
      builder: (context, controller) {
        return IconButton(
          onPressed: () {
            controller.openView();
          },
          icon: Icon(Icons.search),
          tooltip: 'Buscar',
        );
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) {
        return List<ListTile>.generate(products.length, (int index) {
          return ListTile(
            title: SearchProductComponent(product: products[index]),
            onTap: () {
              setState(() {
                controller.closeView('');
                context.go('/product/${products[index].id}');
              });
            },
          );
        });
      },
      viewOnSubmitted: (value) => _searchProducts(value),
    );
  }
}
