import 'package:flutter/material.dart';
import 'food_form_screen.dart';
import 'food_list_screen.dart';
import 'order_approval_screen.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const FoodFormScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Expanded(child: FoodListScreen(isAdmin: true)), // ส่ง isAdmin เพื่อแยกระหว่าง Admin กับ User
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => OrderApprovalScreen()),
                );
              },
              child: const Text('Approve Orders'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}