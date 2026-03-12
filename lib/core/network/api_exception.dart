// lib/core/network/api_exception.dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final ApiErrorType type;

  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.type = ApiErrorType.unknown,
  });

  factory ApiException.fromStatusCode(int statusCode, [dynamic data]) {
    final message = _getMessageForStatus(statusCode, data);
    final type = _getTypeForStatus(statusCode);

    return ApiException(
      message: message,
      statusCode: statusCode,
      data: data,
      type: type,
    );
  }

  static String _getMessageForStatus(int statusCode, dynamic data) {
    // محاولة استخراج الرسالة من الـ response
    if (data is Map<String, dynamic>) {
      if (data['message'] is String) return data['message'] as String;
      if (data['error'] is String) return data['error'] as String;
    }

    switch (statusCode) {
      case 400: return 'Bad request';
      case 401: return 'Unauthorized - Please login again';
      case 403: return 'Forbidden - Access denied';
      case 404: return 'Not found';
      case 409: return 'Conflict - Resource already exists';
      case 422: return 'Validation error';
      case 429: return 'Too many requests - Please slow down';
      case 500: return 'Server error - Please try again later';
      case 502: return 'Bad gateway';
      case 503: return 'Service unavailable';
      default: return 'Something went wrong';
    }
  }

  static ApiErrorType _getTypeForStatus(int statusCode) {
    switch (statusCode) {
      case 400: return ApiErrorType.badRequest;
      case 401: return ApiErrorType.unauthorized;
      case 403: return ApiErrorType.forbidden;
      case 404: return ApiErrorType.notFound;
      case 422: return ApiErrorType.validation;
      case 429: return ApiErrorType.tooManyRequests;
      case >= 500: return ApiErrorType.server;
      default: return ApiErrorType.unknown;
    }
  }

  bool get isNetworkError => type == ApiErrorType.network;
  bool get isAuthError => type == ApiErrorType.unauthorized;
  bool get isServerError => type == ApiErrorType.server;

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

enum ApiErrorType {
  network,
  unauthorized,
  forbidden,
  notFound,
  badRequest,
  validation,
  tooManyRequests,
  server,
  timeout,
  cancelled,
  unknown,
}