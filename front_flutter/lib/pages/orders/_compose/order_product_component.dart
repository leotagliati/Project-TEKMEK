import 'package:flutter/material.dart';
import 'package:front_flutter/models/order.dart';
import 'package:intl/intl.dart';

class OrderProductComponent extends StatelessWidget {
  final OrderItem product;
  final int amount;

  const OrderProductComponent({
    super.key,
    required this.product,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    var currency = NumberFormat('#,##0.00', 'pt_BR');

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Column(
          children: [
            Container(color: Colors.grey.shade500, height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(8),
                    child: Image.network(
                      product.imageUrl,
                      width: constraints.maxWidth > 600 ? 144 : 120,
                      height: constraints.maxWidth > 600 ? 144 : 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Quantidade: $amount',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'R\$${currency.format(product.price * amount)}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
