import 'package:flutter/material.dart';
import 'package:front_flutter/api/services.dart';
import 'package:front_flutter/models/product.dart';

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

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      isFullScreen: true,
      searchController: controller,
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
        return List<ListTile>.generate(5, (int index) {
          final String item = 'item $index';
          return ListTile(
            title: Text(item),
            onTap: () {
              setState(() {
                controller.closeView(item);
              });
            },
          );
        });
      },
      viewOnSubmitted: (value) => _searchProducts(value),
    );
  }
}
