class FoodItem {
  String id;
  String name;
  String description;
  double price;
  String imageUrl;
  int quantity;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.quantity = 1, 
  });
}