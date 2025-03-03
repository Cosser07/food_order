import 'package:flutter/material.dart';
import '../model/food_item.dart';

class CartProvider with ChangeNotifier {
  List<FoodItem> _items = [];

  List<FoodItem> get items => _items;

  void addItem(String id, String name, double price, int quantity, String imageUrl) {
    final existingIndex = _items.indexWhere((item) => item.id == id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity = quantity;
    } else {
      final foodItem = FoodItem(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        description: '',
        imageUrl: imageUrl,
      );
      _items.add(foodItem);
    }
    notifyListeners();
    
  }

  void removeItem(String id) {
    _items.removeWhere((food) => food.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}