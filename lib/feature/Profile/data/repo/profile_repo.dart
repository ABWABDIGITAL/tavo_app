// lib/feature/profile/data/repo/profile_repo.dart
import 'package:dio/dio.dart';
import 'package:tavo/core/cache/cache_helper.dart';
import 'package:tavo/core/network/api_constants.dart';
import 'package:tavo/core/network/api_service.dart';
import 'package:tavo/feature/profile/data/model/user_model.dart';

class ProfileRepo {
  final ApiService _apiService;

  ProfileRepo(this._apiService);

  Future<UserModel> getUserProfile() async {
    final userId = CacheHelper.getUserId();
    if (userId == null || userId.isEmpty) {
      final cachedName = CacheHelper.getUserName();
      final cachedPhone = CacheHelper.getPhone();
      if (cachedName != null) {
        return UserModel(
          id: '',
          name: cachedName,
          phone: cachedPhone,
          image: CacheHelper.getUserImage(),
        );
      }
      throw 'لم يتم تسجيل الدخول';
    }

    try {
      final response = await _apiService.get(ApiConstants.userProfile(userId));
      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        final userData = responseData['data'] ?? responseData;
        if (userData is Map<String, dynamic>) {
          final user = UserModel.fromJson(userData);
          if (user.name.isNotEmpty) await CacheHelper.setUserName(user.name);
          if (user.phone != null) await CacheHelper.setPhone(user.phone!);
          if (user.image != null) await CacheHelper.setUserImage(user.image!);
          return user;
        }
      }
      throw 'خطأ في تنسيق البيانات';
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      final cachedName = CacheHelper.getUserName();
      if (cachedName != null) {
        return UserModel(
          id: userId,
          name: cachedName,
          phone: CacheHelper.getPhone(),
          image: CacheHelper.getUserImage(),
        );
      }
      rethrow;
    }
  }

  Future<UserModel> updateUserProfile({String? name, String? phone}) async {
    final userId = CacheHelper.getUserId();
    if (userId == null || userId.isEmpty) throw 'لم يتم تسجيل الدخول';

    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;

    try {
      final response = await _apiService.put(
        ApiConstants.userProfile(userId),
        data: body,
      );
      final responseData = response.data;

      if (responseData is Map<String, dynamic>) {
        final userData = responseData['data'] ?? responseData;
        if (userData is Map<String, dynamic>) {
          final user = UserModel.fromJson(userData);
          if (user.name.isNotEmpty) await CacheHelper.setUserName(user.name);
          if (user.phone != null) await CacheHelper.setPhone(user.phone!);
          return user;
        }
      }
      if (name != null) await CacheHelper.setUserName(name);
      if (phone != null) await CacheHelper.setPhone(phone);
      return UserModel(id: userId, name: name ?? '', phone: phone);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        return data['message']?.toString() ?? data['error']?.toString() ?? 'حدث خطأ';
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