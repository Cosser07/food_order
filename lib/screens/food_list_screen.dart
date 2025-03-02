import 'package:account/model/food_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/food_provider.dart';
import '../provider/cart_provider.dart';
import 'food_form_screen.dart';
import 'order_food_screen.dart';
import 'dart:io';

class FoodListScreen extends StatelessWidget {
  final bool isAdmin;

  const FoodListScreen({Key? key, required this.isAdmin}) : super(key: key);

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
            subtitle: Text(food.description),
            trailing: isAdmin
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
                        onPressed: () {
                          foodProvider.deleteFood(food.id);
                        },
                      ),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      cartProvider.addItem(food.id, food.name, food.price, 1);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => OrderFoodScreen(food: food),
                        ),
                      );
                    },
                    child: const Text('Order'),
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
}