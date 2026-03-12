import 'package:dio/dio.dart';
import 'package:tavo/core/network/api_constants.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/feature/home/data/models/restaurant_model.dart';
import 'package:tavo/feature/restaurant/data/model/restaurants_response.dart';


class RestaurantsRepo {
  final ApiService _apiService;

  RestaurantsRepo(this._apiService);

  Future<RestaurantsResponse> getRestaurants({
    String? categoryId,
    double? minRating,
    int? page,
    int? limit,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      
      if (categoryId != null) {
        queryParams['categoryId'] = categoryId;
      }
      if (minRating != null) {
        queryParams['minRating'] = minRating;
      }
      if (page != null) {
        queryParams['page'] = page;
      }
      if (limit != null) {
        queryParams['limit'] = limit;
      }

      final response = await _apiService.get(
        ApiConstants.restaurants,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );
      
      return RestaurantsResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<RestaurantModel?> getRestaurantById(String id) async {
    try {
      final response = await _apiService.get('${ApiConstants.restaurants}/$id');
      
      if (response.data['success'] == true && response.data['data'] != null) {
        return RestaurantModel.fromJson(response.data['data']);
      }
      return null;
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