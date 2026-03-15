import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:tavo/core/cache/cache_helper.dart';
import 'package:tavo/core/network/api_constants.dart';
import 'package:tavo/core/network/api_service.dart';
import '../models/auth_response.dart';
import '../models/register_request.dart';

import '../models/verify_otp_request.dart';
import '../models/login_request.dart';

class AuthRepo {
  final ApiService _apiService;

  AuthRepo(this._apiService);

  Future<AuthResponse> register(RegisterRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: request.toJson(),
      );
      await CacheHelper.setPhone(request.phone);
      await CacheHelper.setCountryCode(request.countryCode);
      return _parseResponse(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AuthResponse> login(LoginRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      await CacheHelper.setPhone(request.phone);
      await CacheHelper.setCountryCode(request.countryCode);
      return _parseResponse(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<AuthResponse> verifyOtp(VerifyOtpRequest request) async {
    try {
      final response = await _apiService.post(
        ApiConstants.verifyOtp,
        data: request.toJson(),
      );
      final authResponse = _parseResponse(response.data);
      if (authResponse.token != null && authResponse.token!.isNotEmpty) {
        await CacheHelper.setToken(authResponse.token!);
      }
      if (authResponse.user != null) {
        await CacheHelper.setUser(jsonEncode(authResponse.user!.toJson()));
        if (authResponse.user!.id != null &&
            authResponse.user!.id!.isNotEmpty) {
          await CacheHelper.setUserId(authResponse.user!.id!);
        }
        if (authResponse.user!.name != null &&
            authResponse.user!.name!.isNotEmpty) {
          await CacheHelper.setUserName(authResponse.user!.name!);
        }
        if (authResponse.user!.phone != null) {
          await CacheHelper.setPhone(authResponse.user!.phone!);
        }
      }
      return authResponse;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    await CacheHelper.clearUserData();
  }

  AuthResponse _parseResponse(dynamic data) {
    if (data == null) {
      return AuthResponse(success: false, message: 'Empty response');
    }
    if (data is String) {
      return AuthResponse(success: true, message: data);
    }
    if (data is Map<String, dynamic>) {
      return AuthResponse.fromJson(data);
    }
    return AuthResponse(success: false, message: 'Unknown response format');
  }

  String _handleDioError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response?.data;

      if (data is String && data.contains('<!DOCTYPE html>')) {
        return 'API endpoint not found';
      }

      if (data is String) {
        return data;
      }

      if (data is Map<String, dynamic>) {
        if (data['errors'] != null && data['errors'] is List) {
          final errors = data['errors'] as List;
          if (errors.isNotEmpty) {
            return errors.map((e) => e['msg']?.toString() ?? '').join(', ');
          }
        }
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'Something went wrong';
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.badResponse:
        return _getStatusCodeMessage(e.response?.statusCode);
      default:
        return 'Something went wrong';
    }
  }

  String _getStatusCodeMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Endpoint not found';
      case 422:
        return 'Validation error';
      case 500:
        return 'Server error';
      default:
        return 'Something went wrong';
    }
  }
}
