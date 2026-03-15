// lib/feature/booking/ui/logic/bookings_state.dart
import 'package:tavo/feature/booking/data/model/booking_model.dart';
import 'package:tavo/feature/booking/data/model/booking_status.dart';
import 'package:tavo/feature/booking/data/model/order_details_model.dart';

class BookingsState {
  final bool loading;
  final List<BookingModel> bookings;
  final String? error;
  final bool loadingDetails;
  final BookingModel? selectedBooking;
  final OrderDetailsModel? orderDetails;
  final String? detailsError;

  const BookingsState({
    this.loading = false,
    this.bookings = const [],
    this.error,
    this.loadingDetails = false,
    this.selectedBooking,
    this.orderDetails,
    this.detailsError,
  });

  List<BookingModel> filterBy(BookingStatus status) {
    switch (status) {
      case BookingStatus.inProgress:
        return bookings
            .where(
              (b) =>
                  b.status == 'pending' ||
                  b.status == 'confirmed' ||
                  b.status == 'seated' ||
                  b.status == 'finished_meal' ||
                  b.status == 'draft',
            )
            .toList();
      case BookingStatus.completed:
        return bookings.where((b) => b.status == 'completed').toList();
      case BookingStatus.cancelled:
        return bookings
            .where((b) => b.status == 'cancelled' || b.status == 'no_show')
            .toList();
    }
  }

  BookingsState copyWith({
    bool? loading,
    List<BookingModel>? bookings,
    String? error,
    bool? loadingDetails,
    BookingModel? selectedBooking,
    OrderDetailsModel? orderDetails,
    String? detailsError,
  }) {
    return BookingsState(
      loading: loading ?? this.loading,
      bookings: bookings ?? this.bookings,
      error: error,
      loadingDetails: loadingDetails ?? this.loadingDetails,
      selectedBooking: selectedBooking,
      orderDetails: orderDetails,
      detailsError: detailsError,
    );
  }
}
