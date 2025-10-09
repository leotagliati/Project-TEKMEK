import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/search_component.dart';

class AppBarComponent extends StatelessWidget implements PreferredSizeWidget {
  const AppBarComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Expanded(child: Text("TEKMEK", textAlign: TextAlign.center)),
          SearchComponent(),
        ],
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
