class HeroModel {
  final String imageUrl;
  final String? redirectUrl;
  final bool isActive;
  final int sortOrder;

  HeroModel({
    required this.imageUrl,
    this.redirectUrl,
    required this.isActive,
    required this.sortOrder,
  });

  factory HeroModel.fromJson(Map<String, dynamic> json) {
    return HeroModel(
      imageUrl: json['imageUrl'] ?? '',
      redirectUrl: json['redirectUrl'],
      isActive: json['isActive'] ?? true,
      sortOrder: json['sortOrder'] ?? 0,
    );
  }
}