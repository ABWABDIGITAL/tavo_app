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
    required this.isAvailable,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['_id'] ?? json['id'] ?? '',
      titleAr: json['ar']?['title'] ?? json['ar']?['name'] ?? json['title'] ?? '',
      titleEn: json['en']?['title'] ?? json['en']?['name'] ?? json['title'] ?? '',
      descriptionAr: json['ar']?['description'] ?? json['description'] ?? '',
      descriptionEn: json['en']?['description'] ?? json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      oldPrice: json['oldPrice'] != null ? (json['oldPrice']).toDouble() : null,
      imageUrl: _fixImageUrl(json['imageUrl'] ?? json['image']),
      categoryId: json['categoryId'] ?? json['category'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  static String _fixImageUrl(String? url) {
    if (url == null) return '';
    return url.replaceAll('undefined', '');
  }

  // ✅ Add these getters for backward compatibility
  String get title => titleAr.isNotEmpty ? titleAr : titleEn;
  String get description => descriptionAr.isNotEmpty ? descriptionAr : descriptionEn;

  String getTitle(String locale) => locale == 'ar' ? titleAr : titleEn;
  String getDescription(String locale) => locale == 'ar' ? descriptionAr : descriptionEn;

  bool get hasDiscount => oldPrice != null && oldPrice! > price;
}