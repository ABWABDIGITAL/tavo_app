// lib/feature/restaurant/data/model/menu_item_specification_model.dart
class MenuItemSpecificationModel {
  final String id;
  final String nameAr;
  final String nameEn;
  final String descriptionAr;
  final String descriptionEn;
  final double price;
  final String imageUrl;
  final List<SpecificationGroup> specificationsAr;
  final List<SpecificationGroup> specificationsEn;

  MenuItemSpecificationModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.price,
    required this.imageUrl,
    required this.specificationsAr,
    required this.specificationsEn,
  });

  factory MenuItemSpecificationModel.fromJson(Map<String, dynamic> json) {
    final arData = json['ar'] as Map<String, dynamic>? ?? {};
    final enData = json['en'] as Map<String, dynamic>? ?? {};

    return MenuItemSpecificationModel(
      id: json['_id'] ?? '',
      nameAr: arData['name'] ?? '',
      nameEn: enData['name'] ?? '',
      descriptionAr: arData['description'] ?? '',
      descriptionEn: enData['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      imageUrl: json['image']?['url'] ?? '',
      specificationsAr: (arData['specifications'] as List<dynamic>?)
              ?.map((e) => SpecificationGroup.fromJson(e))
              .toList() ??
          [],
      specificationsEn: (enData['specifications'] as List<dynamic>?)
              ?.map((e) => SpecificationGroup.fromJson(e))
              .toList() ??
          [],
    );
  }

  String getName(String locale) => locale == 'ar' ? nameAr : nameEn;
  String getDescription(String locale) => locale == 'ar' ? descriptionAr : descriptionEn;
  List<SpecificationGroup> getSpecifications(String locale) =>
      locale == 'ar' ? specificationsAr : specificationsEn;
}

class SpecificationGroup {
  final String key;
  final String title;
  final SpecificationType type;
  final bool required;
  final List<SpecificationOption> options;

  SpecificationGroup({
    required this.key,
    required this.title,
    required this.type,
    required this.required,
    required this.options,
  });

  factory SpecificationGroup.fromJson(Map<String, dynamic> json) {
    return SpecificationGroup(
      key: json['key'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] == 'multiple'
          ? SpecificationType.multiple
          : SpecificationType.single,
      required: json['required'] ?? false,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => SpecificationOption.fromJson(e))
              .toList() ??
          [],
    );
  }
}

enum SpecificationType { single, multiple }

class SpecificationOption {
  final String title;
  final double price;

  SpecificationOption({
    required this.title,
    required this.price,
  });

  factory SpecificationOption.fromJson(Map<String, dynamic> json) {
    return SpecificationOption(
      title: json['title'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpecificationOption &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          price == other.price;

  @override
  int get hashCode => title.hashCode ^ price.hashCode;
}