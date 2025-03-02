import 'package:flutter/material.dart';
import '../model/food_item.dart';

class FoodProvider with ChangeNotifier {
  List<FoodItem> _items = [];

  List<FoodItem> get items => _items;

  void addFood(FoodItem food) {
    _items.add(food);
    notifyListeners();
  }

  void updateFood(String id, FoodItem newFood) {
    final index = _items.indexWhere((food) => food.id == id);
    if (index != -1) {
      _items[index] = newFood;
      notifyListeners();
    }
  }

  void deleteFood(String id) {
    _items.removeWhere((food) => food.id == id);
    notifyListeners();
  }
}