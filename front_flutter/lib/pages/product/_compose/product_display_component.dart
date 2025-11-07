import 'package:flutter/material.dart';
import 'package:front_flutter/models/product.dart';
import 'package:intl/intl.dart';

class ProductDisplayComponent extends StatefulWidget {
  final Product product;
  const ProductDisplayComponent({super.key, required this.product});

  @override
  State<ProductDisplayComponent> createState() =>
      _ProductDisplayComponentState();
}

class _ProductDisplayComponentState extends State<ProductDisplayComponent> {
  var currency = NumberFormat('#,##0.00', 'pt_BR');

  final List<String> radioOptions = ['Normal', 'Expressa', 'Agendada'];
  String? _selectedOption;

  @override
  void initState() {
    super.initState();
    _selectedOption = radioOptions[0];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 512),
            child: Image.network(widget.product.imageUrl),
          ),
        ),
        SizedBox(height: 16),
        Text(
          widget.product.name,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_border),
                Icon(Icons.star_border),
                Icon(Icons.star_border),
                Icon(Icons.star_border),
                Icon(Icons.star_border),
              ],
            ),
            Text('(0 avaliações)'),
          ],
        ),
        Text(
          'R\$${currency.format(widget.product.price)}',
          style: TextStyle(fontSize: 24),
        ),
        Container(color: Colors.grey[400], height: 2),
        Text('Entrega'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: radioOptions.map((option) {
            final bool isSelected = _selectedOption == option;
            return OutlinedButton(
              onPressed: () {
                setState(() {
                  _selectedOption = option;
                });
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: isSelected ? Colors.black : Colors.grey,
                side: BorderSide(
                  color: isSelected ? Colors.black : Colors.grey,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(128),
                ),
              ),
              child: Text(option),
            );
          }).toList(),
        ),
      ],
    );
  }
}
