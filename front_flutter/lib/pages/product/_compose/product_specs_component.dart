import 'package:flutter/material.dart';
import 'package:front_flutter/models/product.dart';

class ProductSpecsComponent extends StatelessWidget {
  final Product product;

  const ProductSpecsComponent({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: 1, color: Colors.grey[400]),
        Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text('Descrição'),
            leading: Icon(Icons.help),
            iconColor: Color.fromARGB(255, 65, 72, 74),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  bottom: 16.0,
                ),
                child: Text(product.description),
              ),
            ],
          ),
        ),
        Container(height: 1, color: Colors.grey[400]),
        Theme(
          data: ThemeData().copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: Text('Características'),
            leading: Icon(Icons.brush),
            iconColor: Color.fromARGB(255, 65, 72, 74),
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 12.0,
                  right: 12.0,
                  bottom: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Conectividade: ${product.connectivity} \nLayout: ${product.layoutSize} \nTipo de keycap: ${product.keycapType}',
                        style: TextStyle(height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
