// lib/core/network/request_queue/pending_request.dart
import 'dart:async';
import 'package:dio/dio.dart';

enum RequestMethod { get, post, put, patch, delete }

class PendingRequest<T> {
  final String id;
  final String path;
  final RequestMethod method;
  final dynamic data;
  final Map<String, dynamic>? queryParameters;
  final Options? options;
  final Completer<Response<T>> completer;
  final DateTime createdAt;
  final int retryCount;
  final int maxRetries;
  final bool isPriority;

  PendingRequest({
    required this.id,
    required this.path,
    required this.method,
    this.data,
    this.queryParameters,
    this.options,
    required this.completer,
    DateTime? createdAt,
    this.retryCount = 0,
    this.maxRetries = 3,
    this.isPriority = false,
  }) : createdAt = createdAt ?? DateTime.now();

  PendingRequest<T> copyWith({
    int? retryCount,
  }) {
    return PendingRequest<T>(
      id: id,
      path: path,
      method: method,
      data: data,
      queryParameters: queryParameters,
      options: options,
      completer: completer,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
      maxRetries: maxRetries,
      isPriority: isPriority,
    );
  }

  bool get canRetry => retryCount < maxRetries;

  bool get isExpired {
    // الطلب ينتهي بعد 5 دقائق
    return DateTime.now().difference(createdAt).inMinutes > 5;
  }

  @override
  String toString() => 'PendingRequest($method $path, retry: $retryCount/$maxRetries)';
}