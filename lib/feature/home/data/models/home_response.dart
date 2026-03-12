import 'package:tavo/feature/home/data/models/category_model.dart';
import 'package:tavo/feature/home/data/models/hero_model.dart';
import 'package:tavo/feature/home/data/models/restaurant_model.dart';

class HomeResponse {
  final bool success;
  final String? message;
  final HomeData? data;

  HomeResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null ? HomeData.fromJson(json['data']) : null,
    );
  }
}

class HomeData {
  final List<HeroModel> hero;
  final List<CategoryModel> categories;
  final List<RestaurantModel> restaurants;

  HomeData({
    required this.hero,
    required this.categories,
    required this.restaurants,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      hero: (json['hero'] as List<dynamic>?)
              ?.map((e) => HeroModel.fromJson(e))
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => CategoryModel.fromJson(e))
              .toList() ??
          [],
      restaurants: (json['restaurants'] as List<dynamic>?)
              ?.map((e) => RestaurantModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}