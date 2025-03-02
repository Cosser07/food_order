import 'package:flutter/material.dart';
import 'food_list_screen.dart';
import 'cart_screen.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: const FoodListScreen(isAdmin: false), // กำหนดเป็น false เพื่อให้ UI สำหรับผู้ใช้
    );
  }
}