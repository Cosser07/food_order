import 'package:flutter/material.dart';
import '../model/food_item.dart';

class CartProvider with ChangeNotifier {
  List<FoodItem> _items = [];

  List<FoodItem> get items => _items;

  void addItem(String id, String name, double price, int quantity, String imageUrl) {
    final existingIndex = _items.indexWhere((item) => item.id == id);
    if (existingIndex >= 0) {
      // อัปเดตจำนวนสำหรับรายการที่มีอยู่
      _items[existingIndex].quantity = quantity;
    } else {
      // เพิ่มรายการใหม่ พร้อม imageUrl
      final foodItem = FoodItem(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        description: '', // หากไม่มี description สามารถกำหนดเป็นค่าว่าง
        imageUrl: imageUrl, // เก็บ imageUrl (พาธหรือ URL)
      );
      _items.add(foodItem);
    }
    notifyListeners();
     // ดีบั๊กเพื่อตรวจสอบข้อมูล
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