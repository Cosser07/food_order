import 'package:flutter/material.dart';
import '../model/food_item.dart';

class CartProvider with ChangeNotifier {
  List<FoodItem> _items = [];

  List<FoodItem> get items => _items;

  void addItem(FoodItem food) {
    _items.add(food);
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
    return _items.fold(0.0, (sum, item) => sum + item.price);
  }
}