// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'api_constants.dart';

import 'interceptors/language_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'request_queue/request_queue_manager.dart';

class DioClient {
  DioClient._internal() {
    _dio = Dio(_baseOptions);
    _setupInterceptors();
    RequestQueueManager().setDio(_dio);
  }

  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late final Dio _dio;
  Dio get dio => _dio;

  BaseOptions get _baseOptions => BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
    responseType: ResponseType.json,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    validateStatus: (status) => status != null && status < 500,
  );

  void _setupInterceptors() {
    _dio.interceptors.addAll([
      LanguageInterceptor(),

      RetryInterceptor(dio: _dio),
      LoggingInterceptor(),
    ]);
  }

  // ✅ إضافة method لتحديث الـ Token
  void setAuthToken(String? token) {
    if (token == null || token.isEmpty) {
      _dio.options.headers.remove('Authorization');
    } else {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  // ✅ إضافة method لمسح الـ Token
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  void updateBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  void clearInterceptors() {
    _dio.interceptors.clear();
  }
}