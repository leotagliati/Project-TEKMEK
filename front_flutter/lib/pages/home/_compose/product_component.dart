import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductComponent extends StatefulWidget {
  final String imagePath;
  final String title;
  final String description;

  const ProductComponent({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  State<ProductComponent> createState() => _ProductComponentState();
}

class _ProductComponentState extends State<ProductComponent> {
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
          context.go('/product/1');
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
                  child: Image.asset(
                    width: double.infinity,
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.description),
                        ],
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
