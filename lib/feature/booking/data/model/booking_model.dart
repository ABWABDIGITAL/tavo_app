// lib/feature/booking/data/model/booking_model.dart
import 'package:tavo/feature/booking/data/model/booking_status.dart';

class BookingModel {
  final String id;
  final String restaurantName;
  final String restaurantLogoUrl;
  final double total;
  final String address;
  final String dateTimeText;
  final String seatsText;
  final BookingStatus status;

  const BookingModel({
    required this.id,
    required this.restaurantName,
    required this.restaurantLogoUrl,
    required this.total,
    required this.address,
    required this.dateTimeText,
    required this.seatsText,
    required this.status,
  });
}