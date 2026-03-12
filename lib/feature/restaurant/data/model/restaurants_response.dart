import 'package:tavo/feature/home/data/models/restaurant_model.dart';


class RestaurantsResponse {
  final bool success;
  final String? message;
  final List<RestaurantModel> data;

  RestaurantsResponse({
    required this.success,
    this.message,
    required this.data,
  });

  factory RestaurantsResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantsResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => RestaurantModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}