import 'food_item.dart';

class OrderItem {
  String id;
  List<FoodItem> items;
  double totalAmount;
  bool isApproved;
  DateTime timestamp; // เพิ่มฟิลด์ timestamp

  OrderItem({
    required this.id,
    required this.items,
    required this.totalAmount,
    this.isApproved = false,
    DateTime? timestamp, // ✅ เปลี่ยนเป็น nullable parameter
  }) : timestamp = timestamp ?? DateTime.now(); // ✅ กำหนดค่าเริ่มต้นเป็น DateTime.now()

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'isApproved': isApproved,
      'timestamp': timestamp.toIso8601String(), // ✅ แปลง timestamp เป็น string
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      items: (json['items'] as List).map((itemJson) => FoodItem.fromJson(itemJson)).toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      isApproved: json['isApproved'] as bool? ?? false,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : DateTime.now(), // ✅ ป้องกัน null error
    );
  }
}
