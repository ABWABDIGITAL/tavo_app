// lib/feature/booking/ui/logic/bookings_state.dart
import 'package:tavo/feature/booking/data/model/booking_model.dart';
import 'package:tavo/feature/booking/data/model/booking_status.dart';
import 'package:tavo/feature/booking/data/model/order_details_model.dart';

class BookingsState {
  final bool loading;
  final List<BookingModel> bookings;
  final String? error;
  final bool loadingDetails;
  final OrderDetailsModel? orderDetails;
  final String? detailsError;

  const BookingsState({
    this.loading = false,
    this.bookings = const [],
    this.error,
    this.loadingDetails = false,
    this.orderDetails,
    this.detailsError,
  });

  List<BookingModel> filterBy(BookingStatus status) =>
      bookings.where((b) => b.status == status).toList();

  BookingsState copyWith({
    bool? loading,
    List<BookingModel>? bookings,
    String? error,
    bool? loadingDetails,
    OrderDetailsModel? orderDetails,
    String? detailsError,
  }) {
    return BookingsState(
      loading: loading ?? this.loading,
      bookings: bookings ?? this.bookings,
      error: error,
      loadingDetails: loadingDetails ?? this.loadingDetails,
      orderDetails: orderDetails,
      detailsError: detailsError,
    );
  }
}