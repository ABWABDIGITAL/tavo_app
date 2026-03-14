import 'package:dio/dio.dart';
import 'package:tavo/core/network/api_constants.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/feature/restaurant/data/model/menu_item_model.dart';
import 'package:tavo/feature/restaurant/data/model/menu_response.dart';

class MenuRepo {
  final ApiService _apiService;

  MenuRepo(this._apiService);

  Future<MenuResponse> getMenu({
    required String restaurantId,
    int page = 1,
    int limit = 12,
    String? categoryId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['categoryId'] = categoryId;
      }

      final response = await _apiService.get(
        ApiConstants.restaurantMenu(restaurantId),
        queryParameters: queryParams,
      );

      final data = response.data as Map<String, dynamic>;
      return MenuResponse.fromJson(data);
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