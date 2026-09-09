import 'package:tavo/feature/restaurant/data/model/menu_category_model.dart';
import 'package:tavo/feature/restaurant/data/model/menu_item_model.dart';

class MenuState {
  final bool loading;
  final bool loadingMore;
  final String? error;
  final List<MenuCategoryModel> categories;
  final List<MenuItemModel> items;
  final String? selectedCategoryId;
  final Map<String, int> cart;
  final int currentPage;
  final bool hasMore;

  const MenuState({
    this.loading = false,
    this.loadingMore = false,
    this.error,
    this.categories = const [],
    this.items = const [],
    this.selectedCategoryId,
    this.cart = const {},
    this.currentPage = 1,
    this.hasMore = true,
  });

  MenuState copyWith({
    bool? loading,
    bool? loadingMore,
    String? error,
    List<MenuCategoryModel>? categories,
    List<MenuItemModel>? items,
    String? selectedCategoryId,
    Map<String, int>? cart,
    int? currentPage,
    bool? hasMore,
  }) {
    return MenuState(
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      error: error,
      categories: categories ?? this.categories,
      items: items ?? this.items,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      cart: cart ?? this.cart,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  List<MenuItemModel> get filteredItems {
    if (selectedCategoryId == null) return items;
    return items.where((item) => item.categoryId == selectedCategoryId).toList();
  }

  int qty(String itemId) => cart[itemId] ?? 0;

  double get total {
    double sum = 0;
    for (final item in items) {
      final q = cart[item.id] ?? 0;
      if (q > 0) sum += item.price * q;
    }
    return sum;
  }

  bool get hasItemsInCart => cart.values.any((q) => q > 0);

  int get totalCartItems => cart.values.fold(0, (sum, q) => sum + q);
}