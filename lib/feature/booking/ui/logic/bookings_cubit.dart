// lib/feature/booking/ui/logic/bookings_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/core/network/api_exception.dart';
import 'package:tavo/feature/booking/data/repo/bookings_repo.dart';
import 'package:tavo/feature/booking/data/model/order_details_model.dart';
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

  Future<void> loadBookingDetails(String reservationId) async {
    if (isClosed) return;
    emit(
      state.copyWith(
        loadingDetails: true,
        detailsError: null,
        selectedBooking: null,
        orderDetails: null,
      ),
    );

    try {
      final booking = await _repo.getBookingDetails(reservationId);
      if (isClosed) return;

      OrderDetailsModel? orderDetails;
      if (booking.order != null && booking.order!.id.isNotEmpty) {
        try {
          orderDetails = await _repo.getOrderDetails(booking.order!.id);
        } catch (_) {
          // Order details failed to load, continue with reservation only
        }
      }

      if (isClosed) return;
      emit(
        state.copyWith(
          loadingDetails: false,
          selectedBooking: booking,
          orderDetails: orderDetails,
        ),
      );
    } on ApiException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loadingDetails: false, detailsError: e.message));
    } catch (e) {
      if (isClosed) return;
      emit(state.copyWith(loadingDetails: false, detailsError: e.toString()));
    }
  }

  void clearDetails() {
    emit(
      state.copyWith(
        selectedBooking: null,
        orderDetails: null,
        detailsError: null,
      ),
    );
  }

  Future<void> refresh() async {
    await loadBookings();
  }
}
