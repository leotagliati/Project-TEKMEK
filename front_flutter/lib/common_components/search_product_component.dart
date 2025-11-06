import 'package:flutter/material.dart';
import 'package:front_flutter/models/product.dart';

class SearchProductComponent extends StatelessWidget {
  final Product product;

  const SearchProductComponent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        spacing: 12,
        children: [
          Image.network(
            product.imageUrl,
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
          Expanded(child: Text(product.name)),
        ],
      ),
    );
  }
}
