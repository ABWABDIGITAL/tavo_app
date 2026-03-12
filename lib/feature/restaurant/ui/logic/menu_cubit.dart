import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/feature/restaurant/data/model/menu_item_model.dart';
import 'package:tavo/feature/restaurant/data/model/menu_response.dart';
import 'package:tavo/feature/restaurant/data/repo/menu_repo.dart';
import 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepo _menuRepo;
  final String restaurantId;

  MenuCubit(this._menuRepo, {required this.restaurantId}) : super(const MenuState());

  Future<void> loadMenu() async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final response = await _menuRepo.getMenu(
        restaurantId: restaurantId,
        categoryId: state.selectedCategoryId,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        emit(state.copyWith(
          categories: data.categories,
          items: data.items,
          filteredItems: data.items,
          pagination: data.pagination,
          loading: false,
        ));
      } else {
        emit(state.copyWith(
          loading: false,
          error: response.message ?? 'Failed to load menu',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> loadMoreItems() async {
    if (!state.canLoadMore || state.loadingMore) return;

    emit(state.copyWith(loadingMore: true));

    try {
      final nextPage = (state.pagination?.page ?? 1) + 1;
      
      final response = await _menuRepo.getMenu(
        restaurantId: restaurantId,
        categoryId: state.selectedCategoryId,
        page: nextPage,
      );

      if (response.success && response.data != null) {
        final data = response.data!;
        final allItems = [...state.items, ...data.items];
        
        emit(state.copyWith(
          items: allItems,
          filteredItems: _filterItems(allItems, state.selectedCategoryId),
          pagination: data.pagination,
          loadingMore: false,
        ));
      } else {
        emit(state.copyWith(loadingMore: false));
      }
    } catch (e) {
      emit(state.copyWith(loadingMore: false));
    }
  }

  void selectCategory(String? categoryId) {
    if (categoryId == state.selectedCategoryId) return;

    emit(state.copyWith(
      selectedCategoryId: categoryId,
      clearCategory: categoryId == null,
      filteredItems: _filterItems(state.items, categoryId),
    ));
  }

  List<MenuItemModel> _filterItems(List<MenuItemModel> items, String? categoryId) {
    if (categoryId == null || categoryId.isEmpty) {
      return items;
    }
    return items.where((item) => item.categoryId == categoryId).toList();
  }

  void add(String itemId) {
    final newCart = Map<String, int>.from(state.cart);
    newCart[itemId] = (newCart[itemId] ?? 0) + 1;
    emit(state.copyWith(cart: newCart));
  }

  void remove(String itemId) {
    final newCart = Map<String, int>.from(state.cart);
    final current = newCart[itemId] ?? 0;
    if (current > 0) {
      newCart[itemId] = current - 1;
      if (newCart[itemId] == 0) {
        newCart.remove(itemId);
      }
    }
    emit(state.copyWith(cart: newCart));
  }

  void clearCart() {
    emit(state.copyWith(cart: {}));
  }

  Future<void> refresh() async {
    await loadMenu();
  }
}