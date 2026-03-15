// lib/feature/booking/data/repo/bookings_repo.dart
import 'package:dio/dio.dart';
import 'package:tavo/core/network/api_constants.dart';
import 'package:tavo/core/network/api_exception.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/feature/booking/data/model/available_table_model.dart';
import 'package:tavo/feature/booking/data/model/booking_model.dart';
import 'package:tavo/feature/booking/data/model/order_details_model.dart';

class BookingsRepo {
  final ApiService _apiService;

  BookingsRepo(this._apiService);

  Future<List<BookingModel>> getBookings() async {
    try {
      final response = await _apiService.get(ApiConstants.myReservations);
      final data = response.data;

      if (data['success'] == true && data['data'] is Map) {
        final reservations =
            data['data']['reservations'] as List<dynamic>? ?? [];
        return reservations.map((e) => BookingModel.fromJson(e)).toList();
      }

      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BookingModel> getBookingDetails(String reservationId) async {
    try {
      final response = await _apiService.get(
        ApiConstants.reservationDetails(reservationId),
      );
      final data = response.data;

      if (data['success'] == true && data['data'] != null) {
        return BookingModel.fromJson(data['data']);
      }

      throw ApiException(
        message: 'Failed to load booking details',
        type: ApiErrorType.unknown,
      );
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

  Future<AvailabilityResponse> checkAvailability({
    required String restaurantId,
    required String date,
    required String time,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.checkAvailability(restaurantId, date, time),
      );
      final data = response.data;

      if (data['success'] == true) {
        return AvailabilityResponse.fromJson(data['data']);
      }

      throw ApiException(
        message: data['message'] ?? 'Failed to check availability',
        type: ApiErrorType.unknown,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<BookingModel> createReservation({
    required String restaurantId,
    String? orderId,
    required List<String> physicalTableIds,
    required DateTime startAt,
    required DateTime endAt,
    required int guestsCount,
    String? customerName,
    String? customerPhone,
    String? specialRequests,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.createReservation,
        data: {
          'restaurantId': restaurantId,
          if (orderId != null) 'orderId': orderId,
          'physicalTableIds': physicalTableIds,
          'startAt': startAt.toIso8601String(),
          'endAt': endAt.toIso8601String(),
          'guestsCount': guestsCount,
          if (customerName != null || customerPhone != null)
            'customer': {
              'name': customerName ?? '',
              'phone': customerPhone ?? '',
            },
          if (specialRequests != null) 'specialRequests': specialRequests,
        },
      );
      final data = response.data;

      if (data['success'] == true && data['data'] != null) {
        return BookingModel.fromJson(data['data']);
      }

      throw ApiException(
        message: data['message'] ?? 'Failed to create reservation',
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
        return ApiException(
          message: 'Connection timeout',
          type: ApiErrorType.timeout,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection',
          type: ApiErrorType.network,
        );
      default:
        return ApiException(
          message: 'Something went wrong',
          type: ApiErrorType.unknown,
        );
    }
  }
}
