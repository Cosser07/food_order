import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/food_item.dart';
import '../provider/cart_provider.dart';

class OrderFoodScreen extends StatefulWidget {
  final FoodItem food;

  const OrderFoodScreen({required this.food});

  @override
  _OrderFoodScreenState createState() => _OrderFoodScreenState();
}

class _OrderFoodScreenState extends State<OrderFoodScreen> {
  int _quantity = 1;

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = widget.food.price * _quantity;
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('สั่ง ${widget.food.name}'), // แปลเป็นไทย
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.food.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(widget.food.description),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ราคา: ฿${widget.food.price.toStringAsFixed(2)}'), // แปลและใช้ "฿"
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: _decrementQuantity,
                    ),
                    Text('$_quantity'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _incrementQuantity,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'รวม: ฿${totalPrice.toStringAsFixed(2)}', // แปลและใช้ "฿"
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                cartProvider.addItem(
                  widget.food.id,
                  widget.food.name,
                  widget.food.price,
                  _quantity,
                  widget.food.imageUrl, // ส่ง imageUrl ไปยัง CartProvider
                );
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
              child: const Center(
                child: Text('เพิ่มในตะกร้า'), // แปลเป็นไทย
              ),
            ),
          ],
        ),
      ),
    );
  }
}