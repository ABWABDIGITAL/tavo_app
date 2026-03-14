// lib/feature/booking/data/repo/bookings_repo.dart
import 'package:dio/dio.dart';
import 'package:tavo/core/network/api_exception.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/feature/booking/data/model/booking_model.dart';
import 'package:tavo/feature/booking/data/model/order_details_model.dart';

class BookingsRepo {
  final ApiService _apiService;

  BookingsRepo(this._apiService);

  Future<List<BookingModel>> getBookings() async {
    try {
      final response = await _apiService.get('/v1/api/order');
      final data = response.data;

      if (data['success'] == true && data['data'] is List) {
        return (data['data'] as List)
            .map((e) => BookingModel.fromJson(e))
            .toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<OrderDetailsModel> getOrderDetails(String orderId) async {
    try {
      final response = await _apiService.get('/v1/api/order/$orderId');
      final data = response.data;

      if (data['success'] == true && data['data'] != null) {
        return OrderDetailsModel.fromJson(data['data']);
      }

      throw ApiException(
        message: 'Failed to load order details',
        type: ApiErrorType.unknown,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.response?.statusCode != null) {
      return ApiException.fromStatusCode(
        e.response!.statusCode!,
        e.response?.data,
      );
    }
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(message: 'Connection timeout', type: ApiErrorType.timeout);
      case DioExceptionType.connectionError:
        return ApiException(message: 'No internet connection', type: ApiErrorType.network);
      default:
        return ApiException(message: 'Something went wrong', type: ApiErrorType.unknown);
    }
  }
}