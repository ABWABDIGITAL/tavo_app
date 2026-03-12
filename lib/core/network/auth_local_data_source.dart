// lib/features/auth/data/datasources/auth_local_data_source.dart
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  String? getToken();
  Future<void> clearToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _tokenKey = 'auth_token';

  final SharedPreferences prefs;

  AuthLocalDataSourceImpl(this.prefs);

  @override
  Future<void> saveToken(String token) async {
    await prefs.setString(_tokenKey, token);
  }

  @override
  String? getToken() {
    return prefs.getString(_tokenKey);
  }

  @override
  Future<void> clearToken() async {
    await prefs.remove(_tokenKey);
  }
}