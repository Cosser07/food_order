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
    final cartItems = cartProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตะกร้าสินค้า'),
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
                    'ยอดรวม',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '${cartProvider.totalAmount.toStringAsFixed(2)} บาท',
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
                            // ตรวจสอบและพิมพ์ข้อมูลก่อนส่ง
                            print('Cart Items before ordering: $cartItems');
                            if (cartItems.isNotEmpty) {
                              orderProvider.addOrder(cartItems);
                              cartProvider.clear();
                            } else {
                              print('Error: Cart is empty, cannot place order.');
                            }
                          },
                    child: const Text('สั่งซื้อเลย'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text("ไม่มีสินค้าในตะกร้า"))
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (ctx, i) => ListTile(
                      leading: CircleAvatar(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: FittedBox(
                            child: Text('฿${cartItems[i].price}'),
                          ),
                        ),
                      ),
                      title: Text(cartItems[i].name),
                      subtitle: Text(
                          'รวม: ฿${(cartItems[i].price * cartItems[i].quantity).toStringAsFixed(2)}'),
                      trailing: Text('${cartItems[i].quantity} x'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}