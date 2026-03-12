import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/feature/restaurant/data/repo/restaurant_details_repo.dart';
import 'restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  final RestaurantDetailsRepo _repo;

  RestaurantDetailsCubit(this._repo) : super(const RestaurantDetailsState());

  Future<void> loadRestaurantDetails(String restaurantId) async {
    emit(state.copyWith(loading: true, clearError: true));

    try {
      final response = await _repo.getRestaurantDetails(restaurantId);

      if (response.success && response.data != null) {
        emit(state.copyWith(
          restaurant: response.data,
          loading: false,
        ));
      } else {
        emit(state.copyWith(
          loading: false,
          error: response.message ?? 'Failed to load restaurant details',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }

  void selectImage(int index) {
    emit(state.copyWith(selectedImageIndex: index));
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

  Future<void> refresh(String restaurantId) async {
    await loadRestaurantDetails(restaurantId);
  }
}