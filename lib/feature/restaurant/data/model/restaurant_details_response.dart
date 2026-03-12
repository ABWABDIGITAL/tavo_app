import 'restaurant_details_model.dart';

class RestaurantDetailsResponse {
  final bool success;
  final String? message;
  final RestaurantDetailsModel? data;

  RestaurantDetailsResponse({
    required this.success,
    this.message,
    this.data,
  });

  factory RestaurantDetailsResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailsResponse(
      success: json['success'] ?? false,
      message: json['message'],
      data: json['data'] != null
          ? RestaurantDetailsModel.fromJson(json['data'])
          : null,
    );
  }
}