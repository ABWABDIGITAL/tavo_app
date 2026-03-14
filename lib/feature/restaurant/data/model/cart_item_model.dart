// lib/feature/restaurant/data/model/cart_item_model.dart
import 'package:tavo/feature/restaurant/data/model/menu_item_specification_model.dart';

class CartItemModel {
  final String menuItemId;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;
  final List<CartSpecification> specifications;

  CartItemModel({
    required this.menuItemId,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    this.specifications = const [],
  });

  double get totalPrice {
    double specPrice = 0;
    for (final spec in specifications) {
      specPrice += spec.price;
    }
    return (price + specPrice) * quantity;
  }
}

class CartSpecification {
  final String key;
  final String name;
  final double price;

  CartSpecification({
    required this.key,
    required this.name,
    this.price = 0,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'name': name,
      };
}