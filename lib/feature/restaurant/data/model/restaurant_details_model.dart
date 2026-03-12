import 'menu_item_model.dart';

class RestaurantDetailsModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final String addressAr;
  final String addressEn;
  final String logoUrl;
  final List<RestaurantImageModel> images;
  final List<RestaurantCategoryModel> categories;
  final double ratingsAverage;
  final int ratingsQuantity;
  final String phone;
  final List<TableModel> tables;
  final List<WorkingHourModel> workingHours;
  final ReservationSettingsModel? reservationSettings;
  final String status;
  final List<MenuItemModel> menu;

  RestaurantDetailsModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.addressAr,
    required this.addressEn,
    required this.logoUrl,
    required this.images,
    required this.categories,
    required this.ratingsAverage,
    required this.ratingsQuantity,
    required this.phone,
    required this.tables,
    required this.workingHours,
    this.reservationSettings,
    required this.status,
    required this.menu,
  });

  factory RestaurantDetailsModel.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsModel(
      id: json['_id'] ?? json['id'] ?? '',
      nameAr: json['ar']?['name'] ?? '',
      nameEn: json['en']?['name'] ?? '',
      descriptionAr: json['ar']?['description'] ?? '',
      descriptionEn: json['en']?['description'] ?? '',
      addressAr: json['ar']?['address'] ?? '',
      addressEn: json['en']?['address'] ?? '',
      logoUrl: _fixImageUrl(json['logo']?['imageUrl']),
      images: (json['image'] as List<dynamic>?)
              ?.map((e) => RestaurantImageModel.fromJson(e))
              .toList() ??
          [],
      categories: (json['categoryIds'] as List<dynamic>?)
              ?.map((e) => RestaurantCategoryModel.fromJson(e))
              .toList() ??
          [],
      ratingsAverage: (json['ratingsAverage'] ?? 0).toDouble(),
      ratingsQuantity: json['ratingsQuantity'] ?? 0,
      phone: json['phone'] ?? '',
      tables: (json['tables'] as List<dynamic>?)
              ?.map((e) => TableModel.fromJson(e))
              .toList() ??
          [],
      workingHours: (json['workingHours'] as List<dynamic>?)
              ?.map((e) => WorkingHourModel.fromJson(e))
              .toList() ??
          [],
      reservationSettings: json['reservationSettings'] != null
          ? ReservationSettingsModel.fromJson(json['reservationSettings'])
          : null,
      status: json['status'] ?? 'active',
      menu: (json['menu'] as List<dynamic>?)
              ?.map((e) => MenuItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  static String _fixImageUrl(String? url) {
    if (url == null) return '';
    return url.replaceAll('undefined', '');
  }

  String getName(String locale) => locale == 'ar' ? nameAr : nameEn;
  String getDescription(String locale) => locale == 'ar' ? descriptionAr : descriptionEn;
  String getAddress(String locale) => locale == 'ar' ? addressAr : addressEn;

  String getFirstCategoryName(String locale) {
    if (categories.isEmpty) return '';
    return categories.first.getName(locale);
  }

  List<String> getAllImageUrls() {
    if (images.isEmpty) return [logoUrl];
    return images.map((e) => e.imageUrl).toList();
  }

  bool get isOpen {
    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final todayHours = workingHours.firstWhere(
      (h) => h.day.toLowerCase() == dayName.toLowerCase(),
      orElse: () => WorkingHourModel(
        day: dayName,
        openTime: '00:00',
        closeTime: '00:00',
        isClosed: true,
      ),
    );

    if (todayHours.isClosed) return false;

    final nowMinutes = now.hour * 60 + now.minute;
    final openMinutes = _parseTime(todayHours.openTime);
    final closeMinutes = _parseTime(todayHours.closeTime);

    if (closeMinutes < openMinutes) {
      return nowMinutes >= openMinutes || nowMinutes < closeMinutes;
    }
    return nowMinutes >= openMinutes && nowMinutes < closeMinutes;
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'monday';
      case 2: return 'tuesday';
      case 3: return 'wednesday';
      case 4: return 'thursday';
      case 5: return 'friday';
      case 6: return 'saturday';
      case 7: return 'sunday';
      default: return 'monday';
    }
  }

  int _parseTime(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  int get availableSeats {
    return tables.fold(0, (sum, table) => sum + table.seats);
  }
}

class RestaurantImageModel {
  final String imageUrl;
  final String? redirectUrl;
  final bool isActive;
  final int sortOrder;

  RestaurantImageModel({
    required this.imageUrl,
    this.redirectUrl,
    required this.isActive,
    required this.sortOrder,
  });

  factory RestaurantImageModel.fromJson(Map<String, dynamic> json) {
    return RestaurantImageModel(
      imageUrl: _fixImageUrl(json['imageUrl']),
      redirectUrl: json['redirectUrl'],
      isActive: json['isActive'] ?? true,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }

  static String _fixImageUrl(String? url) {
    if (url == null) return '';
    return url.replaceAll('undefined', '');
  }
}

class RestaurantCategoryModel {
  final String id;
  final String nameAr;
  final String nameEn;

  RestaurantCategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory RestaurantCategoryModel.fromJson(Map<String, dynamic> json) {
    return RestaurantCategoryModel(
      id: json['_id'] ?? '',
      nameAr: json['ar']?['name'] ?? '',
      nameEn: json['en']?['name'] ?? '',
    );
  }

  String getName(String locale) => locale == 'ar' ? nameAr : nameEn;
}

class TableModel {
  final String id;
  final int seats;
  final String status;

  TableModel({
    required this.id,
    required this.seats,
    required this.status,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['_id'] ?? json['id'] ?? '',
      seats: json['seats'] ?? 0,
      status: json['status'] ?? 'available',
    );
  }
}

class WorkingHourModel {
  final String day;
  final String openTime;
  final String closeTime;
  final bool isClosed;

  WorkingHourModel({
    required this.day,
    required this.openTime,
    required this.closeTime,
    required this.isClosed,
  });

  factory WorkingHourModel.fromJson(Map<String, dynamic> json) {
    return WorkingHourModel(
      day: json['day'] ?? '',
      openTime: json['openTime'] ?? '00:00',
      closeTime: json['closeTime'] ?? '00:00',
      isClosed: json['isClosed'] ?? false,
    );
  }

  String getDayNameAr() {
    switch (day.toLowerCase()) {
      case 'sunday': return 'الأحد';
      case 'monday': return 'الإثنين';
      case 'tuesday': return 'الثلاثاء';
      case 'wednesday': return 'الأربعاء';
      case 'thursday': return 'الخميس';
      case 'friday': return 'الجمعة';
      case 'saturday': return 'السبت';
      default: return day;
    }
  }

  String getDayName(String locale) {
    if (locale == 'ar') return getDayNameAr();
    return day[0].toUpperCase() + day.substring(1);
  }
}

class ReservationSettingsModel {
  final int slotDurationMinutes;
  final int maxDaysInAdvance;

  ReservationSettingsModel({
    required this.slotDurationMinutes,
    required this.maxDaysInAdvance,
  });

  factory ReservationSettingsModel.fromJson(Map<String, dynamic> json) {
    return ReservationSettingsModel(
      slotDurationMinutes: json['slotDurationMinutes'] ?? 30,
      maxDaysInAdvance: json['maxDaysInAdvance'] ?? 7,
    );
  }
}