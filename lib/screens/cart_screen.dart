import 'package:account/model/food_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_provider.dart';
import '../provider/order_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final cartItems = cartProvider.items; // ใช้ cartProvider.items โดยตรง

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.titleLarge?.color ?? Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: cartItems.isEmpty
                        ? null
                        : () {
                            orderProvider.addOrder(
                              cartItems,
                              cartProvider.totalAmount,
                            );
                            cartProvider.clear();
                          },
                    child: const Text('ORDER NOW'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text("No items in the cart"))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) => ListTile(
                      leading: CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: FittedBox(
                            child: Text('\$${cartItems[i].price}'),
                          ),
                        ),
                      ),
                      title: Text(cartItems[i].name),
                      subtitle: Text(
                          'Total: \$${(cartItems[i].price * cartItems[i].quantity).toStringAsFixed(2)}'),
                      trailing: Text('${cartItems[i].quantity} x'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}