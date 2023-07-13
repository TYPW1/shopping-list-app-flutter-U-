import 'package:new_app/models/category.dart';

class GroceryItem {
  final String id;
  final String name;
  final int quantity;
  final Category category;
  final String description; // new field
  final double price; // new field
  final bool isPurchased; // new field

  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
    this.description = '', // new field
    this.price = 0.0, // new field
    this.isPurchased = false, // new field
  });
}
