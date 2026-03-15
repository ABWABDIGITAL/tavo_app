// lib/feature/restaurant/ui/logic/order_state.dart
import 'package:tavo/feature/restaurant/data/model/cart_item_model.dart';

class CreatedOrder {
  final String id;
  final String orderNumber;
  final List<CreatedOrderItem> items;
  final double subtotal;
  final double tax;
  final double totalPrice;
  final DateTime createdAt;

  CreatedOrder({
    this.id = '',
    this.orderNumber = '',
    this.items = const [],
    this.subtotal = 0,
    this.tax = 0,
    this.totalPrice = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory CreatedOrder.fromJson(Map<String, dynamic> json) {
    final items =
        (json['menuItems'] as List<dynamic>?)
            ?.map((e) => CreatedOrderItem.fromJson(e))
            .toList() ??
        [];

    return CreatedOrder(
      id: json['_id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      items: items,
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }
}

class CreatedOrderItem {
  final String name;
  final int quantity;
  final double unitPrice;
  final double lineTotal;
  final List<OrderSpec> specifications;

  const CreatedOrderItem({
    this.name = '',
    this.quantity = 1,
    this.unitPrice = 0,
    this.lineTotal = 0,
    this.specifications = const [],
  });

  factory CreatedOrderItem.fromJson(Map<String, dynamic> json) {
    return CreatedOrderItem(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      lineTotal: (json['lineTotal'] ?? 0).toDouble(),
      specifications:
          (json['specifications'] as List<dynamic>?)
              ?.map((e) => OrderSpec.fromJson(e))
              .toList() ??
          [],
    );
  }

  double get totalPrice => lineTotal > 0 ? lineTotal : unitPrice * quantity;
}

class OrderSpec {
  final String name;
  final double price;

  const OrderSpec({this.name = '', this.price = 0});

  factory OrderSpec.fromJson(Map<String, dynamic> json) {
    return OrderSpec(
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}

class OrderState {
  final List<CartItemModel> cartItems;
  final bool submitting;
  final bool success;
  final String? error;
  final String? orderId;
  final CreatedOrder? createdOrder;

  const OrderState({
    this.cartItems = const [],
    this.submitting = false,
    this.success = false,
    this.error,
    this.orderId,
    this.createdOrder,
  });

  double get totalPrice {
    double total = 0;
    for (final item in cartItems) {
      total += item.totalPrice;
    }
    return total;
  }

  int get totalItems {
    int count = 0;
    for (final item in cartItems) {
      count += item.quantity;
    }
    return count;
  }

  bool get hasItems => cartItems.isNotEmpty;

  int getItemQuantity(String menuItemId) {
    final item = cartItems.where((e) => e.menuItemId == menuItemId).toList();
    if (item.isEmpty) return 0;
    int total = 0;
    for (final i in item) {
      total += i.quantity;
    }
    return total;
  }

  OrderState copyWith({
    List<CartItemModel>? cartItems,
    bool? submitting,
    bool? success,
    String? error,
    String? orderId,
    CreatedOrder? createdOrder,
  }) {
    return OrderState(
      cartItems: cartItems ?? this.cartItems,
      submitting: submitting ?? this.submitting,
      success: success ?? this.success,
      error: error,
      orderId: orderId,
      createdOrder: createdOrder,
    );
  }
}
