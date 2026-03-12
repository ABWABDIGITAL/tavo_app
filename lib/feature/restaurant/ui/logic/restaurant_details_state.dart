

import 'package:tavo/feature/restaurant/data/model/menu_item_model.dart';
import 'package:tavo/feature/restaurant/data/model/restaurant_details_model.dart';

class RestaurantDetailsState {
  final RestaurantDetailsModel? restaurant;
  final bool loading;
  final String? error;
  final Map<String, int> cart;
  final int selectedImageIndex;

  const RestaurantDetailsState({
    this.restaurant,
    this.loading = false,
    this.error,
    this.cart = const {},
    this.selectedImageIndex = 0,
  });

  List<MenuItemModel> get menu => restaurant?.menu ?? [];

  int qty(String itemId) => cart[itemId] ?? 0;

  double get total {
    double sum = 0;
    for (final item in menu) {
      final q = cart[item.id] ?? 0;
      sum += item.price * q;
    }
    return sum;
  }

  int get totalItems {
    int count = 0;
    for (final q in cart.values) {
      count += q;
    }
    return count;
  }

  bool get hasItemsInCart => cart.values.any((q) => q > 0);

  RestaurantDetailsState copyWith({
    RestaurantDetailsModel? restaurant,
    bool? loading,
    String? error,
    Map<String, int>? cart,
    int? selectedImageIndex,
    bool clearError = false,
  }) {
    return RestaurantDetailsState(
      restaurant: restaurant ?? this.restaurant,
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      cart: cart ?? this.cart,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
    );
  }
}