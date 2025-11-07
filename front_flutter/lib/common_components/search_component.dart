import 'package:flutter/material.dart';
import 'package:front_flutter/api/services.dart';
import 'package:front_flutter/common_components/search_product_component.dart';
import 'package:go_router/go_router.dart';
import 'package:front_flutter/models/product.dart';

class SearchComponent extends StatefulWidget {
  const SearchComponent({super.key});

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  final SearchController controller = SearchController();

  ProductsService productsService = ProductsService();

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
          onPressed: () => {},
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
      suggestionsBuilder:
          (BuildContext context, SearchController controller) async {
            final String searchTerm = controller.text.trim();

            if (searchTerm.isEmpty) {
              return [];
            }

            try {
              final List<dynamic> data = await productsService.searchProducts(
                searchTerm,
              );

              if (data.isEmpty) {
                return [
                  const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text('Nenhum resultado.'),
                  ),
                ];
              }

              final List<Product> productsList = data
                  .map((item) => Product.fromJson(item as Map<String, dynamic>))
                  .toList();

              return List<ListTile>.generate(productsList.length, (int index) {
                return ListTile(
                  title: SearchProductComponent(product: productsList[index]),
                  onTap: () {
                    setState(() {
                      controller.closeView('');
                      context.go('/product/${productsList[index].id}');
                    });
                  },
                );
              });
            } catch (e) {
              print('Erro ao procurar produtos: $e');
              return [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text('Nenhum resultado'),
                ),
              ];
            }
          },
      viewOnSubmitted: (searchTerm) {},
    );
  }
}
