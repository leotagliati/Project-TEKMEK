import 'package:flutter/material.dart';
import 'package:front_flutter/api/services.dart';
import 'package:front_flutter/models/cart_item.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:front_flutter/utils/auth_provider.dart';

class CartProductComponent extends StatefulWidget {
  final CartItem cartItem;
  final VoidCallback onDelete;
  final ValueChanged<int> onAmountChanged;

  const CartProductComponent({
    super.key,
    required this.cartItem,
    required this.onDelete,
    required this.onAmountChanged,
  });

  @override
  State<CartProductComponent> createState() => _CartProductComponentState();
}

class _CartProductComponentState extends State<CartProductComponent> {
  CartService cartService = CartService();

  var currency = NumberFormat('#,##0.00', 'pt_BR');
  bool isHoveringDelete = false;
  bool _isLoading = false;

  int? _getUserId(BuildContext context) {
    return context.read<AuthProvider>().user?['idlogin'];
  }

  Future<void> _updateCartItem(int newAmount) async {
    final userId = _getUserId(context);
    if (userId == null) return;

    if (newAmount <= 0) {
      _deleteCartItem();
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final Map<String, dynamic> body = {
        'userId': userId,
        'productId': widget.cartItem.id,
        'quantity': newAmount,
        'price': widget.cartItem.price * newAmount,
      };
      await cartService.updateCartItem(body);

      widget.onAmountChanged(newAmount);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao alterar quantidade do produto'),
          backgroundColor: Colors.redAccent,
        ),
      );
      print('Erro ao modificar produto do carrinho: $e');
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  Future<void> _deleteCartItem() async {
    final userId = _getUserId(context);
    if (userId == null) return;

    setState(() { _isLoading = true; });
    try {
      final Map<String, dynamic> body = {
        'userId': userId,
        'productId': widget.cartItem.id,
      };
      await cartService.removeCartItem(body);

      widget.onDelete();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao remover produto do carrinho'),
          backgroundColor: Colors.redAccent,
        ),
      );
      print('Erro ao remover produto do carrinho: $e');
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

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
      child: Opacity(
        opacity: _isLoading ? 0.5 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.cartItem.imageUrl,
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
                          widget.cartItem.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _updateCartItem(
                                      widget.cartItem.amount - 1),
                              icon: Icon(Icons.remove),
                              iconSize: 12,
                              constraints: BoxConstraints(minWidth: 0, minHeight: 0),
                              padding: EdgeInsets.zero,
                              style: amountButtonStyle,
                            ),
                            Container(
                              constraints: BoxConstraints(minWidth: 24),
                              alignment: Alignment.center,
                              child: _isLoading
                                  ? SizedBox(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : Text('${widget.cartItem.amount}'),
                            ),
                            IconButton(
                              onPressed: _isLoading
                                  ? null
                                  : () => _updateCartItem(
                                      widget.cartItem.amount + 1),
                              icon: Icon(Icons.add),
                              iconSize: 12,
                              constraints: BoxConstraints(minWidth: 0, minHeight: 0),
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
                    onEnter: (event) => setState(() { isHoveringDelete = true; }),
                    onExit: (event) => setState(() { isHoveringDelete = false; }),
                    child: GestureDetector(
                      onTap: _isLoading ? null : () => _deleteCartItem(),
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
                    'R\$${currency.format(widget.cartItem.price * widget.cartItem.amount)}',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}