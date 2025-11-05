import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/product.dart';
import 'package:front_flutter/pages/orders/_compose/order_product_component.dart';
import 'package:intl/intl.dart';

class OrderComponent extends StatelessWidget {
  const OrderComponent({super.key});

  @override
  Widget build(BuildContext context) {
    var currency = NumberFormat('#,##0.00', 'pt_BR');
    final Product product = Product(
      id: 1,
      name: 'Nome do produto',
      price: 499.99,
      imageUrl:
          'https://images.pexels.com/photos/13094372/pexels-photo-13094372.jpeg',
      description: 'Descrição',
      layoutSize: 'layoutSize',
      connectivity: 'connectivity',
      productType: 'productType',
      keycapType: 'keycapType',
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [Text('Pedido #{id}', style: TextStyle(fontSize: 16))],
            ),
            SizedBox(height: 4),
            Column(
              children: [
                OrderProductComponent(product: product, amount: 1),
                OrderProductComponent(product: product, amount: 1),
                OrderProductComponent(product: product, amount: 1),
              ],
            ),
            Container(color: Colors.grey.shade500, height: 1),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Subtotal: R\$${currency.format(product.price)}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
