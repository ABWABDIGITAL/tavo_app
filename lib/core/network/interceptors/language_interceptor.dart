// lib/core/network/interceptors/language_interceptor.dart
import 'package:dio/dio.dart';
import '../../localization/language_service.dart';

class LanguageInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.queryParameters['lang'] = LanguageService.langCode;
    options.headers['Accept-Language'] = LanguageService.langCode;
    handler.next(options);
  }
}