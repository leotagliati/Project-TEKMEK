import 'package:flutter/material.dart';
import 'package:front_flutter/pages/cart/cart_product.dart';
import 'package:intl/intl.dart';

class CartProductComponent extends StatefulWidget {
  final CartProduct product;
  final VoidCallback onDelete;
  final ValueChanged<int> onAmountChanged;

  const CartProductComponent({
    super.key,
    required this.product,
    required this.onDelete,
    required this.onAmountChanged,
  });

  @override
  State<CartProductComponent> createState() => _CartProductComponentState();
}

class _CartProductComponentState extends State<CartProductComponent> {
  var currency = NumberFormat('#,##0.00', 'pt_BR');
  bool isHoveringDelete = false;

  final ButtonStyle amountButtonStyle = IconButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: Color.fromARGB(255, 65, 72, 74),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide(color: Color.fromARGB(255, 135, 149, 154)),
    ),
    fixedSize: Size(24, 24),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.product.imagePath,
                    fit: BoxFit.fitWidth,
                    width: 80,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.type,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        widget.product.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => widget.onAmountChanged(
                              widget.product.amount - 1,
                            ),
                            icon: Icon(Icons.remove),
                            iconSize: 12,
                            constraints: BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            padding: EdgeInsets.zero,
                            style: amountButtonStyle,
                          ),
                          Container(
                            constraints: BoxConstraints(minWidth: 24),
                            alignment: Alignment.center,
                            child: Text('${widget.product.amount}'),
                          ),
                          IconButton(
                            onPressed: () => widget.onAmountChanged(
                              widget.product.amount + 1,
                            ),
                            icon: Icon(Icons.add),
                            iconSize: 12,
                            constraints: BoxConstraints(
                              minWidth: 0,
                              minHeight: 0,
                            ),
                            padding: EdgeInsets.zero,
                            style: amountButtonStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  onEnter: (event) => setState(() {
                    isHoveringDelete = true;
                  }),
                  onExit: (event) => setState(() {
                    isHoveringDelete = false;
                  }),
                  child: GestureDetector(
                    onTap: () => widget.onDelete(),
                    child: Icon(
                      Icons.delete,
                      color: isHoveringDelete
                          ? const Color.fromRGBO(255, 100, 100, 1)
                          : Color.fromARGB(255, 65, 72, 74),
                      size: 24,
                    ),
                  ),
                ),
                Text(
                  'R\$${currency.format(widget.product.price * widget.product.amount)}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
