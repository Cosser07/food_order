class FoodItem {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;
  int quantity; // เพิ่มฟิลด์ quantity

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.quantity = 1, // กำหนดค่าเริ่มต้นให้ quantity
  });
}