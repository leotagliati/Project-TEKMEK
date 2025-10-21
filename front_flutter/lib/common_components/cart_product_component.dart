import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CartProductComponent extends StatefulWidget {
  final String productName;
  final String productType;
  final String imagePath;
  final double price;

  const CartProductComponent({
    super.key,
    required this.productName,
    required this.productType,
    required this.imagePath,
    required this.price,
  });

  @override
  State<CartProductComponent> createState() => _CartProductComponentState();
}

class _CartProductComponentState extends State<CartProductComponent> {
  int amount = 1;
  var currency = NumberFormat('#,##0.00', 'pt_BR');

  final ButtonStyle amountButtonStyle = IconButton.styleFrom(
    padding: EdgeInsets.zero,
    backgroundColor: Colors.white,
    foregroundColor: Color.fromARGB(255, 65, 72, 74),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Color.fromARGB(255, 135, 149, 154)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.fitWidth,
                    width: 80,
                  ),
                ),
                SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productType,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    Text(widget.productName),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => setState(() {
                            if (amount > 1) {
                              amount = amount - 1;
                            }
                          }),
                          icon: Icon(Icons.remove),
                          iconSize: 16,
                          style: amountButtonStyle,
                        ),
                        Container(
                          constraints: BoxConstraints(minWidth: 24),
                          alignment: Alignment.center,
                          child: Text('$amount'),
                        ),
                        IconButton(
                          onPressed: () => setState(() {
                            amount = amount + 1;
                          }),
                          icon: Icon(Icons.add),
                          iconSize: 16,
                          style: amountButtonStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text('R\$${currency.format(widget.price * amount)}')],
            ),
          ],
        ),
      ),
    );
  }
}
