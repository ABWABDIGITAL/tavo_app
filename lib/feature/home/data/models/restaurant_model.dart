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
    String fixImageUrl(String? url) {
      if (url == null) return '';
      return url.replaceAll('undefined', '');
    }

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
      logoUrl: fixImageUrl(json['logo']?['imageUrl']),
      images: (json['image'] as List<dynamic>?)
              ?.map((e) => RestaurantImage.fromJson(e))
              .toList() ??
          [],
      ratingsAverage: (json['ratingsAverage'] ?? 0).toDouble(),
    );
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

  String getFirstImageUrl() {
    if (images.isEmpty) return logoUrl;
    return images.first.imageUrl;
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
    String fixImageUrl(String? url) {
      if (url == null) return '';
      return url.replaceAll('undefined', '');
    }

    return RestaurantImage(
      imageUrl: fixImageUrl(json['imageUrl']),
      redirectUrl: json['redirectUrl'],
      isActive: json['isActive'] ?? true,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}