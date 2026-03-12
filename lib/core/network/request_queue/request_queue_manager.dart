// lib/core/network/request_queue/request_queue_manager.dart
import 'dart:async';
import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'pending_request.dart';
import '../connectivity/connectivity_service.dart';

class RequestQueueManager {
  RequestQueueManager._internal() {
    _init();
  }

  static final RequestQueueManager _instance = RequestQueueManager._internal();
  factory RequestQueueManager() => _instance;

  final Queue<PendingRequest> _queue = Queue();
  final ConnectivityService _connectivity = ConnectivityService();

  bool _isProcessing = false;
  Dio? _dio;

  // Stream للإشعار بعدد الطلبات المعلقة
  final _pendingCountController = StreamController<int>.broadcast();
  Stream<int> get pendingCountStream => _pendingCountController.stream;
  int get pendingCount => _queue.length;

  void _init() {
    _connectivity.addOnOnlineCallback(_processQueue);
  }

  void setDio(Dio dio) {
    _dio = dio;
  }

  void addRequest<T>(PendingRequest<T> request) {
    if (request.isExpired) {
      request.completer.completeError(
        Exception('Request expired before being queued'),
      );
      return;
    }

    // إضافة الطلبات ذات الأولوية في البداية
    if (request.isPriority) {
      _queue.addFirst(request);
    } else {
      _queue.add(request);
    }

    _pendingCountController.add(_queue.length);
    debugPrint('📥 Request queued: ${request.path} (${_queue.length} pending)');

    // إذا الإنترنت موجود، نفذ فوراً
    if (_connectivity.isOnline) {
      _processQueue();
    }
  }

  Future<void> _processQueue() async {
    if (_isProcessing || _queue.isEmpty || _dio == null) return;

    _isProcessing = true;
    debugPrint('🔄 Processing ${_queue.length} queued requests...');

    while (_queue.isNotEmpty && _connectivity.isOnline) {
      final request = _queue.removeFirst();
      _pendingCountController.add(_queue.length);

      if (request.isExpired) {
        request.completer.completeError(Exception('Request expired'));
        continue;
      }

      try {
        final response = await _executeRequest(request);
        request.completer.complete(response);
        debugPrint('✅ Queued request completed: ${request.path}');
      } catch (e) {
        if (request.canRetry && _isRetryableError(e)) {
          // إعادة الطلب للـ Queue
          _queue.addFirst(request.copyWith(retryCount: request.retryCount + 1));
          _pendingCountController.add(_queue.length);
          debugPrint('🔁 Request re-queued: ${request.path}');

          // انتظار قبل المحاولة التالية
          await Future.delayed(Duration(seconds: request.retryCount + 1));
        } else {
          request.completer.completeError(e);
          debugPrint('❌ Queued request failed: ${request.path}');
        }
      }
    }

    _isProcessing = false;
  }

  Future<Response> _executeRequest(PendingRequest request) async {
    switch (request.method) {
      case RequestMethod.get:
        return _dio!.get(
          request.path,
          queryParameters: request.queryParameters,
          options: request.options,
        );
      case RequestMethod.post:
        return _dio!.post(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          options: request.options,
        );
      case RequestMethod.put:
        return _dio!.put(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          options: request.options,
        );
      case RequestMethod.patch:
        return _dio!.patch(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          options: request.options,
        );
      case RequestMethod.delete:
        return _dio!.delete(
          request.path,
          data: request.data,
          queryParameters: request.queryParameters,
          options: request.options,
        );
    }
  }

  bool _isRetryableError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.connectionError;
    }
    return false;
  }

  void clearQueue() {
    for (final request in _queue) {
      request.completer.completeError(Exception('Queue cleared'));
    }
    _queue.clear();
    _pendingCountController.add(0);
  }

  void dispose() {
    clearQueue();
    _pendingCountController.close();
  }
}