import 'package:flutter/material.dart';

class ProductComponent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width < 600 ? 160 : 192,
      height: MediaQuery.of(context).size.width < 600 ? 192 : 256,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Expanded(
              child: Image.asset(
                width: double.infinity,
                imagePath,
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
                        title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(description),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
