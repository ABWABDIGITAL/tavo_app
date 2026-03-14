import 'package:dio/dio.dart';
import 'package:tavo/core/network/api_constants.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/feature/restaurant/data/model/restaurant_details_response.dart';

class RestaurantDetailsRepo {
  final ApiService _apiService;

  RestaurantDetailsRepo(this._apiService);

  Future<RestaurantDetailsResponse> getRestaurantDetails(String restaurantId) async {
    try {
      final response = await _apiService.get(
        ApiConstants.restaurantDetails(restaurantId),
      );

      final data = response.data as Map<String, dynamic>;
      return RestaurantDetailsResponse.fromJson(data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? 'حدث خطأ';
      }
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال';
      case DioExceptionType.connectionError:
        return 'لا يوجد اتصال بالإنترنت';
      default:
        return 'حدث خطأ';
    }
  }
}