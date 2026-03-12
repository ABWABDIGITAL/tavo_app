class CategoryModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final int restaurantCount;

  CategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.restaurantCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      nameAr: json['ar']?['name'] ?? '',
      nameEn: json['en']?['name'] ?? '',
      restaurantCount: json['restaurantCount'] ?? 0,
    );
  }

  String getName(String locale) {
    return locale == 'ar' ? nameAr : nameEn;
  }
}