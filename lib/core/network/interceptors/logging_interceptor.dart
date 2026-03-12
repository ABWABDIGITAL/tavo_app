// lib/core/network/interceptors/logging_interceptor.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────');
      debugPrint('│ 📤 REQUEST: ${options.method} ${options.uri}');
      debugPrint('│ Headers: ${options.headers}');
      if (options.data != null) {
        debugPrint('│ Body: ${options.data}');
      }
      debugPrint('└─────────────────────────────────────────────');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────');
      debugPrint('│ 📥 RESPONSE: ${response.statusCode}');
      debugPrint('│ ${response.requestOptions.method} ${response.requestOptions.uri}');
      debugPrint('│ Data: ${_truncate(response.data.toString(), 500)}');
      debugPrint('└─────────────────────────────────────────────');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('┌─────────────────────────────────────────────');
      debugPrint('│ ❌ ERROR: ${err.type}');
      debugPrint('│ ${err.requestOptions.method} ${err.requestOptions.uri}');
      debugPrint('│ Status: ${err.response?.statusCode}');
      debugPrint('│ Message: ${err.message}');
      debugPrint('│ Data: ${err.response?.data}');
      debugPrint('└─────────────────────────────────────────────');
    }
    handler.next(err);
  }

  String _truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}