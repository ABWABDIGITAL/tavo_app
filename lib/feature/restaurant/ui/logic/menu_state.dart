

import 'package:tavo/feature/restaurant/data/model/menu_item_model.dart';
import 'package:tavo/feature/restaurant/data/model/menu_response.dart';

class MenuState {
  final List<MenuCategoryModel> categories;
  final List<MenuItemModel> items;
  final List<MenuItemModel> filteredItems;
  final PaginationModel? pagination;
  final bool loading;
  final bool loadingMore;
  final String? error;
  final String? selectedCategoryId;
  final Map<String, int> cart;

  const MenuState({
    this.categories = const [],
    this.items = const [],
    this.filteredItems = const [],
    this.pagination,
    this.loading = false,
    this.loadingMore = false,
    this.error,
    this.selectedCategoryId,
    this.cart = const {},
  });

  int qty(String itemId) => cart[itemId] ?? 0;

  double get total {
    double sum = 0;
    for (final item in items) {
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

  bool get canLoadMore => pagination?.hasNext ?? false;

  MenuState copyWith({
    List<MenuCategoryModel>? categories,
    List<MenuItemModel>? items,
    List<MenuItemModel>? filteredItems,
    PaginationModel? pagination,
    bool? loading,
    bool? loadingMore,
    String? error,
    String? selectedCategoryId,
    Map<String, int>? cart,
    bool clearError = false,
    bool clearCategory = false,
  }) {
    return MenuState(
      categories: categories ?? this.categories,
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      pagination: pagination ?? this.pagination,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: clearError ? null : (error ?? this.error),
      selectedCategoryId: clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      cart: cart ?? this.cart,
    );
  }
}