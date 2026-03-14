// lib/feature/booking/data/model/booking_model.dart
import 'package:tavo/feature/booking/data/model/booking_status.dart';

class BookingModel {
  final String id;
  final String orderNumber;
  final String restaurantId;
  final String restaurantName;
  final String restaurantNameEn;
  final String restaurantLogoUrl;
  final double total;
  final String address;
  final String dateTimeText;
  final String seatsText;
  final BookingStatus status;

  const BookingModel({
    required this.id,
    this.orderNumber = '',
    this.restaurantId = '',
    required this.restaurantName,
    this.restaurantNameEn = '',
    required this.restaurantLogoUrl,
    this.total = 0,
    this.address = '',
    this.dateTimeText = '',
    this.seatsText = '',
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final restaurant = json['restaurantId'];
    String nameAr = '';
    String nameEn = '';
    String logoUrl = '';
    String restId = '';

    if (restaurant is Map<String, dynamic>) {
      restId = restaurant['_id'] ?? '';
      nameAr = restaurant['ar']?['name'] ?? '';
      nameEn = restaurant['en']?['name'] ?? '';
      logoUrl = restaurant['logo']?['imageUrl'] ?? '';
    }

    return BookingModel(
      id: json['_id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      restaurantId: restId,
      restaurantName: nameAr,
      restaurantNameEn: nameEn,
      restaurantLogoUrl: logoUrl,
      total: (json['totalPrice'] ?? 0).toDouble(),
      address: json['address'] ?? '',
      dateTimeText: _formatDate(json['createdAt']),
      seatsText: json['seatsText'] ?? '',
      status: _parseStatus(json['orderStatus']),
    );
  }

  String getName(String locale) {
    if (locale == 'ar') return restaurantName;
    return restaurantNameEn.isNotEmpty ? restaurantNameEn : restaurantName;
  }

  static BookingStatus _parseStatus(String? status) {
    switch (status) {
      case 'completed':
        return BookingStatus.completed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'draft':
      case 'pending':
      case 'confirmed':
      case 'in_progress':
      default:
        return BookingStatus.inProgress;
    }
  }

  static String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      final hour = date.hour > 12 ? date.hour - 12 : date.hour;
      final period = date.hour >= 12 ? 'م' : 'ص';
      final minute = date.minute.toString().padLeft(2, '0');
      return '${date.day} ${months[date.month]} ${date.year} - $hour:$minute $period';
    } catch (_) {
      return dateStr;
    }
  }
}