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
  final double subtotal;
  final double tax;
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
    required this.subtotal,
    required this.tax,
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

    final items =
        (json['menuItems'] as List<dynamic>?)
            ?.map((e) => OrderMenuItem.fromJson(e))
            .toList() ??
        [];

    final subtotalValue = (json['subtotal'] ?? 0).toDouble();
    final taxValue = (json['tax'] ?? 0).toDouble();
    final totalValue = (json['totalPrice'] ?? 0).toDouble();

    return OrderDetailsModel(
      id: json['_id'] ?? '',
      orderNumber: json['orderNumber'] ?? '',
      status: json['orderStatus'] ?? 'draft',
      restaurantNameAr: nameAr,
      restaurantNameEn: nameEn,
      restaurantLogo: logoUrl,
      restaurantId: restId,
      menuItems: items,
      subtotal: subtotalValue,
      tax: taxValue,
      totalPrice: totalValue,
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
        'ديسمبر',
      ];
      final hour = date.hour > 12
          ? date.hour - 12
          : (date.hour == 0 ? 12 : date.hour);
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
  final String name;
  final double unitPrice;
  final double lineTotal;
  final int quantity;
  final List<OrderSpecification> specifications;

  OrderMenuItem({
    required this.id,
    required this.name,
    required this.unitPrice,
    required this.lineTotal,
    required this.quantity,
    required this.specifications,
  });

  factory OrderMenuItem.fromJson(Map<String, dynamic> json) {
    String id = '';
    String name = '';
    double unitPrice = 0;
    double lineTotal = 0;

    final menuItem = json['menuItemId'];
    if (menuItem is Map<String, dynamic>) {
      id = menuItem['_id'] ?? '';
      name = menuItem['en']?['name'] ?? menuItem['ar']?['name'] ?? '';
      unitPrice = (menuItem['price'] ?? 0).toDouble();
    } else if (menuItem is String) {
      id = menuItem;
    }

    if (json['name'] != null) {
      name = json['name'];
    }
    if (json['unitPrice'] != null) {
      unitPrice = (json['unitPrice'] as num).toDouble();
    }
    if (json['lineTotal'] != null) {
      lineTotal = (json['lineTotal'] as num).toDouble();
    }

    return OrderMenuItem(
      id: id,
      name: name,
      unitPrice: unitPrice,
      lineTotal: lineTotal,
      quantity: json['quantity'] ?? 1,
      specifications:
          (json['specifications'] as List<dynamic>?)
              ?.map((e) => OrderSpecification.fromJson(e))
              .toList() ??
          [],
    );
  }

  String getName(String locale) => name;

  double get totalPrice => lineTotal > 0 ? lineTotal : unitPrice * quantity;
}

class OrderSpecification {
  final String key;
  final String name;
  final double price;

  OrderSpecification({required this.key, required this.name, this.price = 0});

  factory OrderSpecification.fromJson(Map<String, dynamic> json) {
    return OrderSpecification(
      key: json['key'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
