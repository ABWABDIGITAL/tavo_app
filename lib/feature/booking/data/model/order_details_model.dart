// lib/feature/booking/data/model/order_details_model.dart
class OrderDetailsModel {
  final String id;
  final String orderNumber;
  final String status;
  final String restaurantNameAr;
  final String restaurantNameEn;
  final String restaurantLogo;
  final String restaurantId;
  final List<OrderMenuItem> menuItems;
  final double totalPrice;
  final String createdAt;
  final String formattedDate;

  OrderDetailsModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.restaurantNameAr,
    required this.restaurantNameEn,
    required this.restaurantLogo,
    required this.restaurantId,
    required this.menuItems,
    required this.totalPrice,
    required this.createdAt,
    required this.formattedDate,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
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
    } else if (restaurant is String) {
      restId = restaurant;
    }

    final items = (json['menuItems'] as List<dynamic>?)
            ?.map((e) => OrderMenuItem.fromJson(e))
            .toList() ??
        [];

    double total = (json['totalPrice'] ?? 0).toDouble();
    if (total == 0) {
      for (final item in items) {
        total += item.price * item.quantity;
      }
    }

    return OrderDetailsModel(
      id: json['_id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      status: json['orderStatus'] ?? 'draft',
      restaurantNameAr: nameAr,
      restaurantNameEn: nameEn,
      restaurantLogo: logoUrl,
      restaurantId: restId,
      menuItems: items,
      totalPrice: total,
      createdAt: json['createdAt'] ?? '',
      formattedDate: _formatDate(json['createdAt']),
    );
  }

  String getRestaurantName(String locale) {
    if (locale == 'ar') return restaurantNameAr;
    return restaurantNameEn.isNotEmpty ? restaurantNameEn : restaurantNameAr;
  }

  String getStatusText(String locale) {
    if (locale == 'ar') {
      switch (status) {
        case 'draft':
          return 'مسودة';
        case 'pending':
          return 'قيد الانتظار';
        case 'confirmed':
          return 'مؤكد';
        case 'in_progress':
          return 'قيد التنفيذ';
        case 'completed':
          return 'مكتمل';
        case 'cancelled':
          return 'ملغي';
        default:
          return status;
      }
    } else {
      switch (status) {
        case 'draft':
          return 'Draft';
        case 'pending':
          return 'Pending';
        case 'confirmed':
          return 'Confirmed';
        case 'in_progress':
          return 'In Progress';
        case 'completed':
          return 'Completed';
        case 'cancelled':
          return 'Cancelled';
        default:
          return status;
      }
    }
  }

  static String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        '',
        'يناير',
        'فبراير',
        'مارس',
        'أبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر'
      ];
      final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      final period = date.hour >= 12 ? 'م' : 'ص';
      final minute = date.minute.toString().padLeft(2, '0');
      return '${date.day} ${months[date.month]} ${date.year} - $hour:$minute $period';
    } catch (_) {
      return dateStr;
    }
  }
}

class OrderMenuItem {
  final String id;
  final String nameAr;
  final String nameEn;
  final double price;
  final String imageUrl;
  final int quantity;
  final List<OrderSpecification> specifications;

  OrderMenuItem({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.specifications,
  });

  factory OrderMenuItem.fromJson(Map<String, dynamic> json) {
    final menuItem = json['menuItemId'];
    String id = '';
    String nameAr = '';
    String nameEn = '';
    double price = 0;
    String imageUrl = '';

    if (menuItem is Map<String, dynamic>) {
      id = menuItem['_id'] ?? '';
      nameAr = menuItem['ar']?['name'] ?? '';
      nameEn = menuItem['en']?['name'] ?? '';
      price = (menuItem['price'] ?? 0).toDouble();
      imageUrl = menuItem['image']?['url'] ?? '';
    } else if (menuItem is String) {
      id = menuItem;
    }

    return OrderMenuItem(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      price: price,
      imageUrl: imageUrl,
      quantity: json['quantity'] ?? 1,
      specifications: (json['specifications'] as List<dynamic>?)
              ?.map((e) => OrderSpecification.fromJson(e))
              .toList() ??
          [],
    );
  }

  String getName(String locale) {
    if (locale == 'ar') return nameAr;
    return nameEn.isNotEmpty ? nameEn : nameAr;
  }

  double get totalPrice => price * quantity;
}

class OrderSpecification {
  final String key;
  final String name;

  OrderSpecification({
    required this.key,
    required this.name,
  });

  factory OrderSpecification.fromJson(Map<String, dynamic> json) {
    return OrderSpecification(
      key: json['key'] ?? '',
      name: json['name'] ?? '',
    );
  }
}