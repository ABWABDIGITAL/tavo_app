import 'package:tavo/feature/restaurant/data/model/menu_item_model.dart';
import 'package:tavo/feature/restaurant/data/model/restaurant_details_model.dart';

class RestaurantDetailsState {
  final bool loading;
  final String? error;
  final RestaurantDetailsModel? restaurant;
  final int selectedImageIndex;
  final Map<String, int> cart;

  const RestaurantDetailsState({
    this.loading = false,
    this.error,
    this.restaurant,
    this.selectedImageIndex = 0,
    this.cart = const {},
  });

  RestaurantDetailsState copyWith({
    bool? loading,
    String? error,
    RestaurantDetailsModel? restaurant,
    int? selectedImageIndex,
    Map<String, int>? cart,
  }) {
    return RestaurantDetailsState(
      loading: loading ?? this.loading,
      error: error,
      restaurant: restaurant ?? this.restaurant,
      selectedImageIndex: selectedImageIndex ?? this.selectedImageIndex,
      cart: cart ?? this.cart,
    );
  }

  List<MenuItemModel> get menu => restaurant?.menu ?? [];

  int qty(String itemId) => cart[itemId] ?? 0;

  double get total {
    double sum = 0;
    for (final item in menu) {
      final q = cart[item.id] ?? 0;
      if (q > 0) sum += item.price * q;
    }
    return sum;
  }

  bool get hasItemsInCart => cart.values.any((q) => q > 0);
}