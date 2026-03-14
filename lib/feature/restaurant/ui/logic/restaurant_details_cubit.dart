import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/feature/restaurant/data/repo/restaurant_details_repo.dart';
import 'package:tavo/feature/restaurant/ui/logic/restaurant_details_state.dart';

class RestaurantDetailsCubit extends Cubit<RestaurantDetailsState> {
  final RestaurantDetailsRepo _repo;

  RestaurantDetailsCubit(this._repo) : super(const RestaurantDetailsState());

  Future<void> loadRestaurantDetails(String restaurantId) async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));

    try {
      final response = await _repo.getRestaurantDetails(restaurantId);

      if (isClosed) return;

      if (response.success && response.data != null) {
        emit(state.copyWith(
          loading: false,
          restaurant: response.data,
        ));
      } else {
        emit(state.copyWith(
          loading: false,
          error: response.message ?? 'فشل في تحميل بيانات المطعم',
        ));
      }
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void selectImage(int index) {
    if (isClosed) return;
    emit(state.copyWith(selectedImageIndex: index));
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