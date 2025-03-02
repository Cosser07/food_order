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

  void approveOrder(String id) {
    final index = _orders.indexWhere((order) => order.id == id);
    if (index != -1) {
      _orders[index].isApproved = true;
      notifyListeners();
    }
  }
}