import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tavo/feature/auth/ui/data/models/login_request.dart';
import 'package:tavo/feature/auth/ui/data/models/register_request.dart';

import 'package:tavo/feature/auth/ui/data/models/verify_otp_request.dart';
import 'package:tavo/feature/auth/ui/data/repo/auth_repo.dart';

import 'auth_state.dart';


class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthInitial());

  String _phone = '';
  String _countryCode = '+965';

  String get phone => _phone;
  String get countryCode => _countryCode;

  void setPhone(String phone) => _phone = phone;
  void setCountryCode(String code) => _countryCode = code;

  Future<void> login({
    required String phone,
    required String countryCode,
  }) async {
    emit(AuthLoading());
    try {
      final request = LoginRequest(
        countryCode: countryCode,
        phone: phone,
      );
      await _authRepo.login(request);
      _phone = phone;
      _countryCode = countryCode;
      emit(SendOtpSuccess(phone: phone, countryCode: countryCode));
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String countryCode,
  }) async {
    emit(AuthLoading());
    try {
      final request = RegisterRequest(
        name: name,
        countryCode: countryCode,
        phone: phone,
        email: email,
      );
      await _authRepo.register(request);
      _phone = phone;
      _countryCode = countryCode;
      emit(RegisterSuccess('Registration successful'));
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> verifyOtp(String otp) async {
    emit(AuthLoading());
    try {
      final request = VerifyOtpRequest(
        countryCode: _countryCode,
        phone: _phone,
        otp: otp,
      );
      final response = await _authRepo.verifyOtp(request);
      emit(VerifyOtpSuccess(response.token));
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> resendOtp() async {
    emit(AuthLoading());
    try {
      final request = LoginRequest(
        countryCode: _countryCode,
        phone: _phone,
      );
      await _authRepo.login(request);
      emit(ResendOtpSuccess());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> logout() async {
    await _authRepo.logout();
    emit(AuthInitial());
  }

  String _getErrorMessage(dynamic error) {
    if (error is String) {
      return error;
    }
    return error.toString();
  }
}