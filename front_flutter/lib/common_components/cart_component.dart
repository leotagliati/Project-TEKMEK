import 'package:flutter/material.dart';
import 'package:front_flutter/pages/home/_compose/product_component.dart';

class CartComponent extends StatelessWidget {
  const CartComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Scaffold.of(context).closeEndDrawer(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Meu carrinho ({qtd})",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Container(color: Colors.grey[400], height: 2),
                    ProductComponent(
                      imagePath: "assets/images/keyboard.png",
                      title: "Nome do teclado",
                      description: "R\$999,99",
                    ),
                    Container(color: Colors.grey[400], height: 2),
                    Row(
                      children: [
                        Expanded(child: Text("Subtotal")),
                        Text("R\$999,99"),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 65, 72, 74),
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.transparent),
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Text("Finalizar pedido", textAlign: TextAlign.center)),
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
    );
  }
}
