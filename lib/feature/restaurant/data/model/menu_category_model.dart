class MenuCategoryModel {
  final String id;
  final String nameAr;
  final String nameEn;

  MenuCategoryModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['_id'] ?? json['id'] ?? '',
      nameAr: json['ar']?['name'] ?? '',
      nameEn: json['en']?['name'] ?? '',
    );
  }

  String getName(String locale) => locale == 'ar' ? nameAr : nameEn;
}