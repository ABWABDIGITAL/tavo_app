class RestaurantModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String addressAr;
  final String addressEn;
  final List<RestaurantCategory> categories;
  final String logoUrl;
  final List<RestaurantImage> images;
  final double ratingsAverage;

  RestaurantModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.addressAr,
    required this.addressEn,
    required this.categories,
    required this.logoUrl,
    required this.images,
    required this.ratingsAverage,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['_id'] ?? json['id'] ?? '',
      nameAr: json['ar']?['name'] ?? '',
      nameEn: json['en']?['name'] ?? '',
      addressAr: json['ar']?['address'] ?? '',
      addressEn: json['en']?['address'] ?? '',
      categories: (json['categoryIds'] as List<dynamic>?)
              ?.map((e) => RestaurantCategory.fromJson(e))
              .toList() ??
          [],
      logoUrl: _fixImageUrl(json['logo']?['imageUrl']),
      images: (json['image'] as List<dynamic>?)
              ?.map((e) => RestaurantImage.fromJson(e))
              .toList() ??
          [],
      ratingsAverage: (json['ratingsAverage'] ?? 0).toDouble(),
    );
  }

  static String _fixImageUrl(String? url) {
    if (url == null) return '';
    return url.replaceAll('undefined', '');
  }

  String getName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }

  String getAddress(String locale) {
    return locale == 'ar' ? addressAr : addressEn;
  }

  String getFirstCategoryName(String locale) {
    if (categories.isEmpty) return '';
    return categories.first.getName(locale);
  }

  List<String> getCategoryNames(String locale) {
    return categories.map((c) => c.getName(locale)).toList();
  }

  String getFirstImageUrl() {
    if (images.isEmpty) return logoUrl;
    return images.first.imageUrl;
  }

  List<String> getAllImageUrls() {
    if (images.isEmpty) return [logoUrl];
    return images.map((e) => e.imageUrl).toList();
  }
}

class RestaurantCategory {
  final String id;
  final String nameAr;
  final String nameEn;

  RestaurantCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory RestaurantCategory.fromJson(Map<String, dynamic> json) {
    return RestaurantCategory(
      id: json['_id'] ?? '',
      nameAr: json['ar']?['name'] ?? '',
      nameEn: json['en']?['name'] ?? '',
    );
  }

  String getName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }
}

class RestaurantImage {
  final String imageUrl;
  final String? redirectUrl;
  final bool isActive;
  final int sortOrder;

  RestaurantImage({
    required this.imageUrl,
    this.redirectUrl,
    required this.isActive,
    required this.sortOrder,
  });

  factory RestaurantImage.fromJson(Map<String, dynamic> json) {
    return RestaurantImage(
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