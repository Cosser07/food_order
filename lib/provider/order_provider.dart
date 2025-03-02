import 'package:flutter/material.dart';
import '../model/order_item.dart';
import '../model/food_item.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => _orders;

  void addOrder(List<FoodItem> cartItems, double totalAmount) {
    _orders.add(OrderItem(
      id: DateTime.now().toString(),
      items: cartItems,
      totalAmount: totalAmount,
    ));
    notifyListeners();
  }

  // ฟังก์ชัน approveOrder ถูกลบออกเนื่องจากไม่จำเป็นอีกต่อไป
}