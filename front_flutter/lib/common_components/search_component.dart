import 'package:flutter/material.dart';

class SearchComponent extends StatefulWidget {
  const SearchComponent({super.key});

  @override
  State<SearchComponent> createState() => _SearchComponentState();
}

class _SearchComponentState extends State<SearchComponent> {
  final SearchController controller = SearchController();

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      isFullScreen: true,
      searchController: controller,
      viewHintText: "Pesquise aqui...",
      viewTrailing: [
        IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        IconButton(
          onPressed: () {
            controller.clear();
          },
          icon: Icon(Icons.clear),
        ),
      ],
      builder: (context, controller) {
        return IconButton(
          onPressed: () {
            controller.openView();
          },
          icon: Icon(Icons.search),
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
    );
  }
}
