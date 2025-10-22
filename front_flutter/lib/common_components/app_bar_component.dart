import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/search_component.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          SizedBox(width: 56),
          Expanded(child: Text("TEKMEK", textAlign: TextAlign.center)),
        ],
      ),
      backgroundColor: Colors.grey[300],
      leading: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 56,
          maxWidth: 56,
          minHeight: 56,
          maxHeight: 56
        ),
        child: Builder(
          builder: (BuildContext context) {
            return Center(
              child: IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: Icon(Icons.menu),
                tooltip: 'Menu',
              ),
            );
          },
        ),
      ),
      actions: [
        SearchComponent(),
        Builder(
          builder: (context) => ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 56,
              maxWidth: 56,
              minHeight: 56,
              maxHeight: 56,
            ),
            child: Center(
              child: IconButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                icon: Icon(Icons.shopping_cart),
                tooltip: 'Carrinho',
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
