// lib/feature/restaurant/data/repo/menu_item_specification_repo.dart
import 'package:dio/dio.dart';
import 'package:tavo/core/network/api_exception.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/feature/restaurant/data/model/menu_item_specification_model.dart';

class MenuItemSpecificationRepo {
  final ApiService _apiService;

  MenuItemSpecificationRepo(this._apiService);

  Future<MenuItemSpecificationModel> getSpecification({
    required String restaurantId,
    required String menuItemId,
  }) async {
    try {
      final response = await _apiService.get(
        '/v1/api/menu-item-specification/$restaurantId/$menuItemId',
      );

      final data = response.data;
      if (data['success'] == true && data['data'] != null) {
        return MenuItemSpecificationModel.fromJson(data['data']);
      }
      throw ApiException(
        message: 'Failed to load specification',
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
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'connection_timeout'.tr(),
          type: ApiErrorType.timeout,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'no_internet'.tr(),
          type: ApiErrorType.network,
        );
      case DioExceptionType.badResponse:
        return ApiException.fromStatusCode(
          e.response?.statusCode ?? 500,
          e.response?.data,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'request_cancelled'.tr(),
          type: ApiErrorType.cancelled,
        );
      default:
        return ApiException(
          message: 'something_went_wrong'.tr(),
          type: ApiErrorType.unknown,
        );
    }
  }
}

// Helper extension for translation
extension _StringExt on String {
  String tr() => this; // Will be replaced by easy_localization
}