import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/feature/restaurant/data/repo/menu_repo.dart';
import 'package:tavo/feature/restaurant/ui/logic/menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepo _repo;
  final String restaurantId;

  MenuCubit(this._repo, {required this.restaurantId}) : super(const MenuState());

  Future<void> loadMenu() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));

    try {
      final response = await _repo.getMenu(
        restaurantId: restaurantId,
        page: 1,
      );

      if (isClosed) return;

      if (response.success && response.data != null) {
        emit(state.copyWith(
          loading: false,
          categories: response.data!.categories,
          items: response.data!.items,
          currentPage: 1,
          hasMore: response.data!.pagination?.hasNext ?? false,
        ));
      } else {
        emit(state.copyWith(
          loading: false,
          error: response.message ?? 'فشل في تحميل القائمة',
        ));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> loadMoreItems() async {
    if (isClosed || state.loadingMore || !state.hasMore) return;

    emit(state.copyWith(loadingMore: true));

    try {
      final nextPage = state.currentPage + 1;
      final response = await _repo.getMenu(
        restaurantId: restaurantId,
        page: nextPage,
        categoryId: state.selectedCategoryId,
      );

      if (isClosed) return;

      if (response.success && response.data != null) {
        final newItems = [...state.items, ...response.data!.items];
        emit(state.copyWith(
          loadingMore: false,
          items: newItems,
          currentPage: nextPage,
          hasMore: response.data!.pagination?.hasNext ?? false,
        ));
      } else {
        emit(state.copyWith(loadingMore: false));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loadingMore: false));
    }
  }

  Future<void> refresh() async {
    emit(state.copyWith(
      selectedCategoryId: null,
      currentPage: 1,
      hasMore: true,
    ));
    await loadMenu();
  }

  void selectCategory(String? categoryId) {
    if (isClosed) return;
    emit(state.copyWith(
      selectedCategoryId: categoryId,
    ));
  }

  void add(String itemId) {
    if (isClosed) return;
    final newCart = Map<String, int>.from(state.cart);
    newCart[itemId] = (newCart[itemId] ?? 0) + 1;
    emit(state.copyWith(cart: newCart));
  }

  void remove(String itemId) {
    if (isClosed) return;
    final newCart = Map<String, int>.from(state.cart);
    final current = newCart[itemId] ?? 0;
    if (current > 1) {
      newCart[itemId] = current - 1;
    } else {
      newCart.remove(itemId);
    }
    emit(state.copyWith(cart: newCart));
  }

  void clearCart() {
    if (isClosed) return;
    emit(state.copyWith(cart: {}));
  }
}