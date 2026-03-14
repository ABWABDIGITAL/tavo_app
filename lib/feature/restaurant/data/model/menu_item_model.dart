class MenuItemModel {
  final String id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final String categoryId;
  final String categoryNameAr;
  final String categoryNameEn;
  final bool isAvailable;

  MenuItemModel({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    required this.categoryId,
    this.categoryNameAr = '',
    this.categoryNameEn = '',
    this.isAvailable = true,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    String imageUrl = '';
    if (json['image'] != null) {
      if (json['image'] is Map) {
        imageUrl = json['image']['url'] ?? '';
      } else if (json['image'] is String) {
        imageUrl = json['image'];
      }
    }
    imageUrl = _fixImageUrl(imageUrl);

    String categoryId = '';
    String categoryNameAr = '';
    String categoryNameEn = '';

    if (json['menuCategoryId'] != null) {
      if (json['menuCategoryId'] is Map) {
        categoryId = json['menuCategoryId']['_id'] ?? '';
        categoryNameAr = json['menuCategoryId']['ar']?['name'] ?? '';
        categoryNameEn = json['menuCategoryId']['en']?['name'] ?? '';
      } else if (json['menuCategoryId'] is String) {
        categoryId = json['menuCategoryId'];
      }
    }

    return MenuItemModel(
      id: json['_id'] ?? json['id'] ?? '',
      titleAr: json['ar']?['name'] ?? json['ar']?['title'] ?? '',
      titleEn: json['en']?['name'] ?? json['en']?['title'] ?? '',
      descriptionAr: json['ar']?['description'] ?? '',
      descriptionEn: json['en']?['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: json['oldPrice'] != null ? (json['oldPrice']).toDouble() : null,
      imageUrl: imageUrl,
      categoryId: categoryId,
      categoryNameAr: categoryNameAr,
      categoryNameEn: categoryNameEn,
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  static String _fixImageUrl(String? url) {
    if (url == null || url.isEmpty) return '';
    return url.replaceAll('undefined', '');
  }

  String get title => titleAr.isNotEmpty ? titleAr : titleEn;
  String get description => descriptionAr.isNotEmpty ? descriptionAr : descriptionEn;

  String getTitle(String locale) => locale == 'ar' ? titleAr : titleEn;
  String getDescription(String locale) => locale == 'ar' ? descriptionAr : descriptionEn;
  String getCategoryName(String locale) => locale == 'ar' ? categoryNameAr : categoryNameEn;

  bool get hasDiscount => oldPrice != null && oldPrice! > price;
}