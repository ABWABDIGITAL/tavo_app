// lib/feature/booking/ui/logic/create_booking_state.dart
import 'package:tavo/feature/booking/data/model/available_table_model.dart';
import 'package:tavo/feature/booking/data/model/booking_model.dart';

class CreateBookingState {
  final String restaurantId;
  final String? orderId;
  final String restaurantName;
  final String restaurantLogo;
  final int? maxGuests;

  final DateTime? selectedDate;
  final String? selectedTime;
  final int guestsCount;
  final Set<String> selectedTableIds;

  final bool loadingAvailability;
  final bool creatingReservation;
  final bool availabilityChecked;
  final AvailabilityResponse? availability;
  final String? error;
  final BookingModel? createdReservation;

  const CreateBookingState({
    this.restaurantId = '',
    this.orderId,
    this.restaurantName = '',
    this.restaurantLogo = '',
    this.maxGuests,
    this.selectedDate,
    this.selectedTime,
    this.guestsCount = 1,
    this.selectedTableIds = const {},
    this.loadingAvailability = false,
    this.creatingReservation = false,
    this.availabilityChecked = false,
    this.availability,
    this.error,
    this.createdReservation,
  });

  List<AvailableTable> get availableTables =>
      availability?.availability?.tables ?? [];

  bool get canProceed =>
      selectedDate != null &&
      selectedTime != null &&
      selectedTableIds.isNotEmpty &&
      guestsCount > 0;

  int get totalSeatsSelected {
    return availableTables
        .where((t) => selectedTableIds.contains(t.id))
        .fold(0, (sum, t) => sum + t.seats);
  }

  bool get hasEnoughSeats => totalSeatsSelected >= guestsCount;

  CreateBookingState copyWith({
    String? restaurantId,
    String? orderId,
    String? restaurantName,
    String? restaurantLogo,
    int? maxGuests,
    DateTime? selectedDate,
    String? selectedTime,
    int? guestsCount,
    Set<String>? selectedTableIds,
    bool? loadingAvailability,
    bool? creatingReservation,
    bool? availabilityChecked,
    AvailabilityResponse? availability,
    String? error,
    BookingModel? createdReservation,
    bool clearError = false,
    bool clearAvailability = false,
  }) {
    return CreateBookingState(
      restaurantId: restaurantId ?? this.restaurantId,
      orderId: orderId ?? this.orderId,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantLogo: restaurantLogo ?? this.restaurantLogo,
      maxGuests: maxGuests ?? this.maxGuests,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      guestsCount: guestsCount ?? this.guestsCount,
      selectedTableIds: selectedTableIds ?? this.selectedTableIds,
      loadingAvailability: loadingAvailability ?? this.loadingAvailability,
      creatingReservation: creatingReservation ?? this.creatingReservation,
      availabilityChecked: availabilityChecked ?? this.availabilityChecked,
      availability: clearAvailability
          ? null
          : (availability ?? this.availability),
      error: clearError ? null : (error ?? this.error),
      createdReservation: createdReservation ?? this.createdReservation,
    );
  }
}
