import 'package:flutter/material.dart';
import 'package:front_flutter/common_components/product.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ProductComponent extends StatefulWidget {
  final Product product;

  const ProductComponent({super.key, required this.product});

  @override
  State<ProductComponent> createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
  var currency = NumberFormat('#,##0.00', 'pt_BR');
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (event) => setState(() {
        isHovering = true;
      }),
      onExit: (event) => setState(() {
        isHovering = false;
      }),
      child: GestureDetector(
        onTap: () {
          context.go('/product/${widget.product.id}');
        },
        child: Container(
          width: MediaQuery.of(context).size.width < 600 ? 160 : 192,
          height: MediaQuery.of(context).size.width < 600 ? 192 : 256,
          decoration: BoxDecoration(
            color: Colors.white,
            border: isHovering
                ? Border.all(color: Colors.black, width: 1)
                : Border.all(color: Colors.grey.shade300, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    widget.product.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.product.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('R\$${currency.format(widget.product.price)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
