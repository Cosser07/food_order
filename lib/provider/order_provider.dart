import 'package:flutter/material.dart';
import '../model/order_item.dart';
import '../model/food_item.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => _orders;

  void addOrder(List<FoodItem> cartItems) {
    // ตรวจสอบว่า cartItems ไม่ว่าง
    if (cartItems.isEmpty) {
      print('Warning: cartItems is empty, no order added.');
      return;
    }
    // คำนวณ totalAmount จาก cartItems
    double totalAmount = cartItems.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
    _orders.add(OrderItem(
      id: DateTime.now().toString(),
      items: List<FoodItem>.from(cartItems), // ใช้ List.from เพื่อสร้างสำเนาใหม่
      totalAmount: totalAmount,
    ));
    notifyListeners();
    print('Order added with items: $cartItems, Total Amount: $totalAmount');
  }

  void deleteOrder(String id) {
    _orders.removeWhere((order) => order.id == id);
    notifyListeners();
  }
}