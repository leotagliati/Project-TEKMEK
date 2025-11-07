import 'package:flutter/material.dart';
import 'package:front_flutter/models/order.dart';
import 'package:front_flutter/pages/orders/_compose/order_product_component.dart';
import 'package:intl/intl.dart';

class OrderComponent extends StatelessWidget {
  final Order order;

  const OrderComponent({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    var currency = NumberFormat('#,##0.00', 'pt_BR');
    var dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedido #${order.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dateFormat.format(order.createdAt),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            Column(
              children: [
                Column(
                  children: order.items
                      .map(
                        (orderProduct) => OrderProductComponent(
                          product: orderProduct,
                          amount: orderProduct.quantity,
                        ),
                      )
                      .toList(),
                ),
                Container(color: Colors.grey.shade500, height: 1),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total: R\$${currency.format(order.totalPrice)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
