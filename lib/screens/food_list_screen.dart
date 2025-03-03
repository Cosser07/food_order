import 'package:foodonlineshop/model/food_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/food_provider.dart';
import '../provider/cart_provider.dart';
import 'food_form_screen.dart';
import 'order_food_screen.dart';
import 'dart:io';

class FoodListScreen extends StatefulWidget {
  final bool isAdmin;
  final bool showPrice;

  const FoodListScreen({Key? key, required this.isAdmin, this.showPrice = false}) : super(key: key);

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  Future<void> _loadFoods() async {
    final foodProvider = Provider.of<FoodProvider>(context, listen: false);
    await foodProvider.loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return ListView.builder(
      itemCount: foodProvider.items.length,
      itemBuilder: (context, index) {
        final food = foodProvider.items[index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            leading: food.imageUrl.isNotEmpty
                ? (food.imageUrl.startsWith('http')
                    ? Image.network(food.imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                    : Image.file(File(food.imageUrl), width: 50, height: 50, fit: BoxFit.cover))
                : null,
            title: Text(
              food.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(food.description),
                if (widget.showPrice) Text('฿${food.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            trailing: widget.isAdmin
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FoodFormScreen(food: food),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        tooltip: 'ลบเมนูอาหาร',
                        onPressed: () {
                          _showDeleteConfirmationDialog(context, foodProvider, food.id);
                        },
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      cartProvider.addItem(
                        food.id,
                        food.name,
                        food.price,
                        1, // ปริมาณเริ่มต้น 1
                        food.imageUrl, // ส่ง imageUrl ไปยัง CartProvider
                      );
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderFoodScreen(food: food),
                        ),
                      );
                    },
                    child: const Text('สั่ง'), // แปลเป็นไทย
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, FoodProvider foodProvider, String foodId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบเมนูนี้?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              foodProvider.deleteFood(foodId);
              Navigator.of(ctx).pop();
            },
            child: const Text('ลบ', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}