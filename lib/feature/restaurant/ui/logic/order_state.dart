// lib/feature/restaurant/ui/logic/order_state.dart
import 'package:tavo/feature/restaurant/data/model/cart_item_model.dart';

class OrderState {
  final List<CartItemModel> cartItems;
  final bool submitting;
  final bool success;
  final String? error;
  final String? orderId;

  const OrderState({
    this.cartItems = const [],
    this.submitting = false,
    this.success = false,
    this.error,
    this.orderId,
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
  }) {
    return OrderState(
      cartItems: cartItems ?? this.cartItems,
      submitting: submitting ?? this.submitting,
      success: success ?? this.success,
      error: error,
      orderId: orderId,
    );
  }
}