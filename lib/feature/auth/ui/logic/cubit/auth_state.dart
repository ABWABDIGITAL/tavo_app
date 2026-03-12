abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class RegisterSuccess extends AuthState {
  final String message;
  RegisterSuccess(this.message);
}

class SendOtpSuccess extends AuthState {
  final String phone;
  final String countryCode;
  SendOtpSuccess({required this.phone, required this.countryCode});
}

class VerifyOtpSuccess extends AuthState {
  final String? token;
  VerifyOtpSuccess(this.token);
}

class AuthError extends AuthState {
  final String error;
  AuthError(this.error);
}

class ResendOtpSuccess extends AuthState {}