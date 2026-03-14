// lib/feature/booking/ui/logic/bookings_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/core/network/api_exception.dart';
import 'package:tavo/feature/booking/data/repo/bookings_repo.dart';
import 'package:tavo/feature/booking/ui/logic/bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState> {
  final BookingsRepo _repo;

  BookingsCubit(this._repo) : super(const BookingsState());

  Future<void> loadBookings() async {
    if (isClosed) return;
    emit(state.copyWith(loading: true, error: null));

    try {
      final bookings = await _repo.getBookings();
      if (isClosed) return;
      emit(state.copyWith(loading: false, bookings: bookings));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.message));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> loadOrderDetails(String orderId) async {
    if (isClosed) return;
    emit(state.copyWith(loadingDetails: true, detailsError: null, orderDetails: null));

    try {
      final details = await _repo.getOrderDetails(orderId);
      if (isClosed) return;
      emit(state.copyWith(loadingDetails: false, orderDetails: details));
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loadingDetails: false, detailsError: e.message));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loadingDetails: false, detailsError: e.toString()));
    }
  }

  void clearDetails() {
    emit(state.copyWith(orderDetails: null, detailsError: null));
  }

  Future<void> refresh() async {
    await loadBookings();
  }
}