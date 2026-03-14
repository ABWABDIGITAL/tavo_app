// lib/feature/restaurant/data/repo/order_repo.dart
import 'package:dio/dio.dart';
import 'package:tavo/core/network/api_exception.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/feature/restaurant/data/model/cart_item_model.dart';

class OrderRepo {
  final ApiService _apiService;

  OrderRepo(this._apiService);

  Future<Map<String, dynamic>> placeOrder({
    required String restaurantId,
    required List<CartItemModel> items,
  }) async {
    try {
      // ✅ Build JSON body (NOT FormData)
      final body = {
        'restaurantId': restaurantId,
        'menuItems': items.map((item) {
          return {
            'menuItemId': item.menuItemId,
            'quantity': item.quantity,
            'specifications': item.specifications.map((spec) {
              return {
                'key': spec.key,
                'name': spec.name,
              };
            }).toList(),
          };
        }).toList(),
      };

      final response = await _apiService.post(
        '/v1/api/order',
        data: body, // ✅ Send as JSON Map, not FormData
      );

      final data = response.data;
      if (data['success'] == true) {
        return data;
      }

      throw ApiException(
        message: data['message'] ?? 'Failed to place order',
        type: ApiErrorType.unknown,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: e.toString(),
        type: ApiErrorType.unknown,
      );
    }
  }

  ApiException _handleDioError(DioException e) {
    // Extract error messages from validation errors
    if (e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        // Handle validation errors array
        if (data['errors'] is List) {
          final errors = data['errors'] as List;
          final messages = errors
              .map((e) => e['msg']?.toString() ?? '')
              .where((m) => m.isNotEmpty)
              .toList();
          if (messages.isNotEmpty) {
            return ApiException(
              message: messages.first,
              statusCode: e.response?.statusCode,
              data: data,
              type: ApiErrorType.validation,
            );
          }
        }
        // Handle single message
        if (data['message'] is String) {
          return ApiException(
            message: data['message'],
            statusCode: e.response?.statusCode,
            type: ApiErrorType.badRequest,
          );
        }
      }
    }

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