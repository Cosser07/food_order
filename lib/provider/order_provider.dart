import 'package:flutter/material.dart';
import '../model/order_item.dart';
import '../model/food_item.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => _orders;

  void addOrder(List<FoodItem> cartItems, double totalAmount) {
    _orders.add(OrderItem(
      id: DateTime.now().toString(),
      items: List.from(cartItems), // เพิ่มรายการอาหารเข้าไปในคำสั่งซื้อ
      totalAmount: totalAmount,
      timestamp: DateTime.now(), // กำหนดค่า timestamp
    ));
    notifyListeners();
  }

  Future<void> loadOrders() async {
    // โหลดคำสั่งซื้อจากฐานข้อมูลหรือแหล่งข้อมูลอื่นๆ
    // ตัวอย่าง:
    // _orders = await _orderDB.loadAllOrders();
    notifyListeners();
  }
}