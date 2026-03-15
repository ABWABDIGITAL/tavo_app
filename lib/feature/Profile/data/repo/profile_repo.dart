// lib/feature/Profile/data/repo/profile_repo.dart
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tavo/core/cache/cache_helper.dart';
import 'package:tavo/core/network/api_constants.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/core/network/dio_factory.dart';
import 'package:tavo/feature/Profile/data/model/user_model.dart';
import 'package:tavo/feature/Profile/data/model/user_stats.dart';

class ProfileRepo {
  final ApiService _apiService;

  ProfileRepo(this._apiService);

  Future<UserModel> getUserProfile() async {
    final token = CacheHelper.getToken();
    if (token == null || token.isEmpty) {
      throw 'لم يتم تسجيل الدخول';
    }

    try {
      final response = await _apiService.get(ApiConstants.profile);
      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        final userData = responseData['data'] ?? responseData;
        if (userData is Map<String, dynamic>) {
          final user = UserModel.fromJson(userData);
          await _cacheUserData(user);
          return user;
        }
      }
      throw 'خطأ في تنسيق البيانات';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> updateUserProfile({String? name, String? phone}) async {
    final token = CacheHelper.getToken();
    if (token == null || token.isEmpty) throw 'لم يتم تسجيل الدخول';

    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;

    try {
      final response = await _apiService.put(ApiConstants.profile, data: body);
      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        final userData = responseData['data'] ?? responseData;
        if (userData is Map<String, dynamic>) {
          final user = UserModel.fromJson(userData);
          await _cacheUserData(user);
          return user;
        }
      }
      if (name != null) await CacheHelper.setUserName(name);
      if (phone != null) await CacheHelper.setPhone(phone);
      return UserModel(id: '', name: name ?? '', phone: phone);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserModel> uploadAvatar(File imageFile) async {
    final token = CacheHelper.getToken();
    if (token == null || token.isEmpty) throw 'لم يتم تسجيل الدخول';

    try {
      final fileName = imageFile.path.split('/').last;
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      final dio = DioFactory.dio;
      final response = await dio.post(
        ApiConstants.uploadAvatar,
        data: formData,
      );

      final responseData = response.data;
      if (responseData is Map<String, dynamic>) {
        final userData = responseData['data']?['user'] ?? responseData['data'];
        if (userData is Map<String, dynamic>) {
          final user = UserModel.fromJson(userData);
          if (user.image != null) {
            await CacheHelper.setUserImage(user.image!);
          }
          return user;
        }
        final avatarUrl = responseData['data']?['url']?.toString();
        if (avatarUrl != null) {
          await CacheHelper.setUserImage(avatarUrl);
          return UserModel(id: '', name: '', image: avatarUrl);
        }
      }
      throw 'خطأ في رفع الصورة';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<UserStats> getUserStats() async {
    final token = CacheHelper.getToken();
    if (token == null || token.isEmpty) throw 'لم يتم تسجيل الدخول';

    try {
      final response = await _apiService.get(ApiConstants.userStats);
      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        final statsData = responseData['data'] ?? responseData;
        if (statsData is Map<String, dynamic>) {
          return UserStats.fromJson(statsData);
        }
      }
      throw 'خطأ في تنسيق البيانات';
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> _cacheUserData(UserModel user) async {
    if (user.id.isNotEmpty) await CacheHelper.setUserId(user.id);
    if (user.name.isNotEmpty) await CacheHelper.setUserName(user.name);
    if (user.phone != null) await CacheHelper.setPhone(user.phone!);
    if (user.image != null) await CacheHelper.setUserImage(user.image!);
  }

  String _handleError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ??
            data['error']?.toString() ??
            'حدث خطأ';
      }
      if (data is String) return data;
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
