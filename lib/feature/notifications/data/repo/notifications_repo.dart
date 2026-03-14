// lib/feature/notifications/data/repo/notifications_repo.dart
import 'package:dio/dio.dart';
import 'package:tavo/core/network/api_exception.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/feature/notifications/data/model/app_notification.dart';

class NotificationsRepo {
  final ApiService _apiService;

  NotificationsRepo(this._apiService);

  Future<List<AppNotification>> getNotifications(String locale) async {
    try {
      final response = await _apiService.get('/v1/api/notification');
      final data = response.data;

      if (data['success'] == true && data['data'] != null) {
        final list = data['data']['notifications'] as List<dynamic>?;
        if (list != null) {
          return list.map((e) => AppNotification.fromJson(e, locale)).toList();
        }
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final response = await _apiService.get('/v1/api/notification/unread-count');
      final data = response.data;
      if (data['success'] == true) {
        return data['data']?['count'] ?? data['data'] ?? 0;
      }
      return 0;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _apiService.patch('/v1/api/notification/$notificationId/read');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await _apiService.patch('/v1/api/notification/read-all');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    if (e.response?.statusCode != null) {
      return ApiException.fromStatusCode(e.response!.statusCode!, e.response?.data);
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