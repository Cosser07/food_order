import 'package:foodonlineshop/database/FoodDB.dart';
import 'package:flutter/material.dart';
import '../model/food_item.dart';
import '../database/FoodDB.dart';

class FoodProvider with ChangeNotifier {
  List<FoodItem> _items = [];
  final FoodDB _foodDB = FoodDB(dbName: 'foods.db');

  List<FoodItem> get items => _items;

  Future<void> loadFoods() async {
    _items = await _foodDB.loadAllFoods();
    notifyListeners();
  }

  Future<void> addFood(FoodItem food) async {
    final keyID = await _foodDB.insertFood(food);
    food.id = keyID.toString(); // อัปเดต id จาก Sembast
    _items.add(food);
    notifyListeners();
  }

  Future<void> updateFood(String id, FoodItem newFood) async {
    final index = _items.indexWhere((food) => food.id == id);
    if (index != -1) {
      _items[index] = newFood;
      await _foodDB.updateFood(newFood);
      notifyListeners();
    }
  }

  Future<void> deleteFood(String id) async {
    _items.removeWhere((food) => food.id == id);
    await _foodDB.deleteFood(id);
    notifyListeners();
  }
}