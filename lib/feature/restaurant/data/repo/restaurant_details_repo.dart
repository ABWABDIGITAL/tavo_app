import 'package:dio/dio.dart';
import 'package:tavo/core/network/api_constants.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/feature/restaurant/data/model/restaurant_details_response.dart';


class RestaurantDetailsRepo {
  final ApiService _apiService;

  RestaurantDetailsRepo(this._apiService);

  Future<RestaurantDetailsResponse> getRestaurantDetails(String id) async {
    try {
      final response = await _apiService.get(
        ApiConstants.restaurantDetails(id),
      );
      return RestaurantDetailsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  String _handleDioError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response?.data;
      if (data is String && data.contains('<!DOCTYPE html>')) {
        return 'API endpoint not found';
      }
      if (data is String) {
        return data;
      }
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'Something went wrong';
      }
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      default:
        return 'Something went wrong';
    }
  }
}