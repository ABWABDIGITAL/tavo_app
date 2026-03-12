// lib/core/network/interceptors/retry_interceptor.dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../connectivity/connectivity_service.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration retryDelay;
  final ConnectivityService _connectivity = ConnectivityService();

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final retries = err.requestOptions.extra['retries'] as int? ?? 0;

    if (retries >= maxRetries) {
      debugPrint('🚫 Max retries reached for ${err.requestOptions.path}');
      return handler.next(err);
    }

    debugPrint('🔄 Retry ${retries + 1}/$maxRetries for ${err.requestOptions.path}');

    // انتظار عودة الإنترنت
    if (!_connectivity.isOnline) {
      await _waitForConnection();
    }

    // انتظار قبل إعادة المحاولة (Exponential Backoff)
    await Future.delayed(retryDelay * (retries + 1));

    try {
      err.requestOptions.extra['retries'] = retries + 1;
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500);
  }

  Future<void> _waitForConnection() async {
    if (_connectivity.isOnline) return;

    debugPrint('⏳ Waiting for connection...');

    final completer = Completer<void>();

    void onOnline() {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }

    _connectivity.addOnOnlineCallback(onOnline);

    // Timeout بعد 30 ثانية
    await completer.future.timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        _connectivity.removeOnOnlineCallback(onOnline);
        throw DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.connectionError,
          message: 'Connection timeout while waiting for network',
        );
      },
    );

    _connectivity.removeOnOnlineCallback(onOnline);
    debugPrint('✅ Connection restored!');
  }
}