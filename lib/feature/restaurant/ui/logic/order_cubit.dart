// lib/feature/restaurant/ui/logic/order_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/core/network/api_exception.dart';
import 'package:tavo/feature/restaurant/data/model/cart_item_model.dart';
import 'package:tavo/feature/restaurant/data/repo/order_repo.dart';
import 'package:tavo/feature/restaurant/ui/logic/order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderRepo _repo;
  final String restaurantId;

  OrderCubit(this._repo, {required this.restaurantId})
      : super(const OrderState());

  /// Add item with specifications to cart
  void addToCart(CartItemModel item) {
    final newItems = List<CartItemModel>.from(state.cartItems);
    newItems.add(item);
    emit(state.copyWith(cartItems: newItems));
  }

  /// Add simple item (no specifications)
  void addSimpleItem({
    required String menuItemId,
    required String name,
    required String imageUrl,
    required double price,
  }) {
    final newItems = List<CartItemModel>.from(state.cartItems);

    // Check if same item without specs exists
    final existingIndex = newItems.indexWhere(
      (e) => e.menuItemId == menuItemId && e.specifications.isEmpty,
    );

    if (existingIndex != -1) {
      newItems[existingIndex].quantity++;
    } else {
      newItems.add(CartItemModel(
        menuItemId: menuItemId,
        name: name,
        imageUrl: imageUrl,
        price: price,
        quantity: 1,
      ));
    }

    emit(state.copyWith(cartItems: newItems));
  }

  /// Remove item from cart
  void removeFromCart(String menuItemId) {
    final newItems = List<CartItemModel>.from(state.cartItems);

    // Find last item with this ID
    final lastIndex = newItems.lastIndexWhere(
      (e) => e.menuItemId == menuItemId,
    );

    if (lastIndex != -1) {
      if (newItems[lastIndex].quantity > 1) {
        newItems[lastIndex].quantity--;
      } else {
        newItems.removeAt(lastIndex);
      }
    }

    emit(state.copyWith(cartItems: newItems));
  }

  /// Clear cart
  void clearCart() {
    emit(state.copyWith(cartItems: []));
  }

  /// Submit order
  Future<void> placeOrder() async {
    if (state.cartItems.isEmpty) return;
    if (isClosed) return;

    emit(state.copyWith(submitting: true, error: null, success: false));

    try {
      final response = await _repo.placeOrder(
        restaurantId: restaurantId,
        items: state.cartItems,
      );

      if (isClosed) return;

      emit(state.copyWith(
        submitting: false,
        success: true,
        orderId: response['data']?['_id'] ?? response['data']?['orderId'] ?? '',
      ));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(submitting: false, error: e.message));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(submitting: false, error: e.toString()));
    }
  }

  void clearError() {
    emit(state.copyWith(error: null));
  }

  void clearSuccess() {
    emit(state.copyWith(success: false, orderId: null));
  }
}