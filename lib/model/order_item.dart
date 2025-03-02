import 'food_item.dart';

class OrderItem {
  String id;
  List<FoodItem> items;
  double totalAmount;
  bool isApproved;

  OrderItem({
    required this.id,
    required this.items,
    required this.totalAmount,
    this.isApproved = false,
  });

  get amount => null;
}